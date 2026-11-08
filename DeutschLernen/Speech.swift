import AudioToolbox
import AVFoundation
import Speech
import SwiftUI

enum Talk {
    static let synth = AVSpeechSynthesizer()

    static func de(_ text: String, rate: Float = 0.46, voice: String? = nil) {
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothHFP])
        try? AVAudioSession.sharedInstance().setActive(true)
        let clean = text.replacingOccurrences(of: "*", with: "")
        synth.stopSpeaking(at: .immediate)
        let u = AVSpeechUtterance(string: clean)
        if let voice, let picked = AVSpeechSynthesisVoice(identifier: voice) {
            u.voice = picked
        } else {
            u.voice = AVSpeechSynthesisVoice(language: "de-DE")
        }
        u.rate = rate
        synth.speak(u)
    }

    static func stop() { synth.stopSpeaking(at: .immediate) }
}

@MainActor
final class Mic: ObservableObject {
    @Published var text = ""
    @Published var listening = false
    @Published var note = ""
    @Published var level: Double = 0
    @Published var wantsPrompt = false

    private var recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private var engine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var tapped = false
    private var recorder: AVAudioRecorder?
    private var recordURL: URL?
    private var ear: CaptureEar?
    private var queueEar: QueueEar?
    private var meter = Meter()
    private var generation = 0
    private var heardError: String?

    func toggle() {
        if listening {
            stop()
            return
        }
        let audio = AVCaptureDevice.authorizationStatus(for: .audio)
        let speech = SFSpeechRecognizer.authorizationStatus()
        if audio == .authorized, speech == .authorized {
            begin()
            return
        }
        note = permissionLine()
        wantsPrompt = true
    }

    func allowPrompt() {
        let before = AVCaptureDevice.authorizationStatus(for: .audio)
        note = "Wysyłam pytanie do iPhone'a…"
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            AVAudioApplication.requestRecordPermission { sessionOK in
                SFSpeechRecognizer.requestAuthorization { speech in
                    Task { @MainActor in
                        let micOK = granted || sessionOK
                        let window = before == .notDetermined
                            ? "iPhone powinien pokazać pytanie."
                            : "iPhone nie pokaże pytania drugi raz, decyzja już była."
                        let speechOK = speech == .authorized
                        self.note = "Mikrofon: \(micOK ? "tak" : "nie"). Rozpoznawanie mowy: \(speechOK ? "tak" : "nie"). \(window)"
                        self.wantsPrompt = false
                        guard micOK else { return }
                        self.begin()
                    }
                }
            }
        }
    }

    func permissionLine() -> String {
        let audio: String
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined: audio = "jeszcze niepytany"
        case .authorized: audio = "zgoda jest"
        case .denied: audio = "odmowa"
        case .restricted: audio = "zablokowany"
        @unknown default: audio = "nieznany"
        }
        let speech: String
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined: speech = "jeszcze niepytany"
        case .authorized: speech = "zgoda jest"
        case .denied: speech = "odmowa"
        case .restricted: speech = "zablokowany"
        @unknown default: speech = "nieznany"
        }
        return "Mikrofon: \(audio). Rozpoznawanie mowy: \(speech)."
    }

    static func plain(_ error: Error) -> String {
        let raw = error.localizedDescription.lowercased()
        if raw.contains("no speech") || raw.contains("nie wykryto") {
            return "Słucham dalej. Powiedz całe zdanie, nie pojedyncze słowo."
        }
        if raw.contains("denied") || raw.contains("not authorized") || raw.contains("niedozwol") {
            return "Brak zgody. Ustawienia → Prywatność → Mikrofon i Rozpoznawanie mowy → LiveContainer."
        }
        return error.localizedDescription
    }

    private func begin() {
        Task { await boot() }
    }

    private func boot() async {
        stopAll()
        generation += 1
        let token = generation
        Talk.stop()
        text = ""
        level = 0
        heardError = nil
        meter.peak = 0
        rearmCount = 0
        note = "Włączam mikrofon…"
        pickRecognizer()
        let allowed = await askMic()
        guard token == generation else { return }

        do {
            try calmSession()
            try startQueue()
            listening = true
            note = "Słucham. Mów całe zdanie."
            watch(token)
            return
        } catch {
            stopQueue()
            heardError = error.localizedDescription
        }
        guard token == generation else { return }

        do {
            try await startCapture()
            listening = true
            note = "Słucham. Mów całe zdanie."
            watch(token)
            return
        } catch {
            ear?.stop()
            ear = nil
            stopEngine()
            heardError = error.localizedDescription
        }
        guard token == generation else { return }

        do {
            try calmSession()
            try startRecorder()
            listening = true
            note = "Nagrywam. Powiedz zdanie i stuknij kwadrat."
            return
        } catch {
            let prior = heardError.map { " \($0)" } ?? ""
            if allowed {
                note = "Nie mogę włączyć mikrofonu. Zamknij inne aplikacje w LiveContainer, odpal Deutsch samą, bez podziału ekranu, i stuknij jeszcze raz. (\(error.localizedDescription)\(prior))"
            } else {
                note = "Brak zgody. Ustawienia → Prywatność → Mikrofon → włącz LiveContainer."
            }
            listening = false
        }
    }

    private func watch(_ token: Int) {
        Task { @MainActor in
            while token == self.generation, self.listening {
                try? await Task.sleep(nanoseconds: 200_000_000)
                self.level = Double(min(1, self.meter.peak * 8))
                if !self.text.isEmpty {
                    self.note = "Słyszę…"
                } else if self.meter.peak > 0.012 {
                    self.note = "Słyszę głos…"
                }
            }
        }
    }

    private func askMic() async -> Bool {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            return true
        case .denied:
            return false
        default:
            return await withCheckedContinuation { cont in
                AVAudioApplication.requestRecordPermission { ok in
                    cont.resume(returning: ok)
                }
            }
        }
    }

    private func calmSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothHFP])
        try session.setActive(true)
    }

    private func pickRecognizer() {
        for id in ["de-DE", "pl-PL", Locale.current.identifier] {
            if let r = SFSpeechRecognizer(locale: Locale(identifier: id)), r.isAvailable {
                recognizer = r
                return
            }
        }
    }

    private var rearmCount = 0

    private func handleSpeech(_ result: SFSpeechRecognitionResult?, _ error: Error?) {
        if let result {
            let said = result.bestTranscription.formattedString
            if !said.isEmpty { text = said }
        }
        if result?.isFinal == true, !text.isEmpty {
            finishListen()
            return
        }
        guard let error, text.isEmpty, listening else { return }
        let raw = error.localizedDescription.lowercased()
        if raw.contains("no speech") || raw.contains("nie wykryto"), rearmCount < 5 {
            rearmCount += 1
            note = meter.peak > 0.012 ? "Słyszę głos. Mów całe zdanie." : "Słucham. Mów bliżej dolnej krawędzi telefonu."
            rearm()
            return
        }
        note = Self.plain(error)
    }

    private func rearm() {
        task?.cancel()
        let request = makeRequest()
        self.request = request
        ear?.request = request
        queueEar?.request = request
        task = recognizer?.recognitionTask(with: request) { result, error in
            Task { @MainActor in
                self.handleSpeech(result, error)
            }
        }
    }

    private func makeRequest() -> SFSpeechAudioBufferRecognitionRequest {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false
        request.taskHint = .dictation
        return request
    }

    private func listen(to request: SFSpeechAudioBufferRecognitionRequest) {
        task = recognizer?.recognitionTask(with: request) { result, error in
            Task { @MainActor in
                self.handleSpeech(result, error)
            }
        }
    }

    private func startEngine() throws {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false
        request.taskHint = .dictation
        self.request = request
        meter.peak = 0
        var last = "brak formatu"
        for attempt in 0..<3 {
            let engine = AVAudioEngine()
            self.engine = engine
            let input = engine.inputNode
            let output = input.outputFormat(forBus: 0)
            let incoming = input.inputFormat(forBus: 0)
            let hw: AVAudioFormat?
            if output.sampleRate > 0, output.channelCount > 0 { hw = output }
            else if incoming.sampleRate > 0, incoming.channelCount > 0 { hw = incoming }
            else { hw = nil }
            if let hw {
                let meter = self.meter
                try? engine.connect(input, to: engine.mainMixerNode, format: hw)
                engine.mainMixerNode.outputVolume = 0
                input.installTap(onBus: 0, bufferSize: 1024, format: hw) { buffer, _ in
                    request.append(buffer)
                    meter.eat(buffer)
                }
                tapped = true
                engine.prepare()
                try engine.start()
                task = recognizer?.recognitionTask(with: request) { result, error in
                    Task { @MainActor in
                        if let result {
                            let said = result.bestTranscription.formattedString
                            if !said.isEmpty { self.text = said }
                        }
                        if let error {
                            self.heardError = error.localizedDescription
                            self.note = Self.plain(error)
                        }
                        if result?.isFinal == true, !self.text.isEmpty { self.finishListen() }
                    }
                }
                return
            }
            engine.stop()
            self.engine = nil
            last = "format 0, próba \(attempt + 1)"
            Thread.sleep(forTimeInterval: 0.12)
        }
        throw NSError(domain: "Mic", code: 2, userInfo: [NSLocalizedDescriptionKey: last])
    }

    private func startCapture() async throws {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        let ear = CaptureEar()
        ear.request = request
        ear.meter = meter
        try await ear.start()
        self.ear = ear
        listen(to: request)
    }

    private func startQueue() throws {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false
        request.taskHint = .dictation
        self.request = request
        let ear = QueueEar(request: request, meter: meter)
        try ear.start()
        queueEar = ear
        listen(to: request)
    }

    private func stopQueue() {
        queueEar?.stop()
        queueEar = nil
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
    }

    private func startRecorder() throws {
        let folders = [
            URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true),
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        ].compactMap { $0 }
        let rate = AVAudioSession.sharedInstance().sampleRate > 0 ? AVAudioSession.sharedInstance().sampleRate : 16_000
        let formats: [(String, [String: Any])] = [
            ("mowa.caf", [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: rate,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsBigEndianKey: false
            ]),
            ("mowa.m4a", [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
            ])
        ]
        var writable = 0
        for folder in folders {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let probe = folder.appendingPathComponent("probe.txt")
            if (try? Data("x".utf8).write(to: probe)) != nil { writable += 1 }
            for (name, settings) in formats {
                let url = folder.appendingPathComponent(name)
                try? FileManager.default.removeItem(at: url)
                guard let rec = try? AVAudioRecorder(url: url, settings: settings) else { continue }
                rec.prepareToRecord()
                if rec.record() {
                    recorder = rec
                    recordURL = url
                    return
                }
            }
        }
        let session = AVAudioSession.sharedInstance()
        let inputs = session.currentRoute.inputs.map(\.portName).joined(separator: ", ")
        let seen = session.availableInputs?.map(\.portName).joined(separator: ", ") ?? ""
        throw NSError(
            domain: "Mic",
            code: 3,
            userInfo: [NSLocalizedDescriptionKey: "zapis \(writable), trasa \(inputs.isEmpty ? "pusta" : inputs), widzi \(seen.isEmpty ? "nic" : seen)"]
        )
    }

    func stop() {
        if recorder?.isRecording == true {
            recorder?.stop()
            recorder = nil
            note = "Rozpoznaję…"
            recognizeFile()
            return
        }
        finishListen()
    }

    private func finishListen() {
        ear?.stop()
        ear = nil
        stopQueue()
        stopEngine()
        listening = false
    }

    private func stopEngine() {
        if let engine {
            if tapped {
                engine.inputNode.removeTap(onBus: 0)
                tapped = false
            }
            if engine.isRunning { engine.stop() }
        }
        engine = nil
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
    }

    private func stopAll() {
        recorder?.stop()
        recorder = nil
        ear?.stop()
        ear = nil
        stopQueue()
        stopEngine()
        listening = false
    }

    private func recognizeFile() {
        guard let url = recordURL else {
            listening = false
            note = "Nie ma nagrania."
            return
        }
        let req = SFSpeechURLRecognitionRequest(url: url)
        req.shouldReportPartialResults = false
        recognizer?.recognitionTask(with: req) { result, error in
            Task { @MainActor in
                if let result {
                    self.text = result.bestTranscription.formattedString
                    if result.isFinal {
                        self.listening = false
                        self.note = ""
                    }
                } else if error != nil {
                    self.listening = false
                    self.note = "Nie rozpoznałem mowy. Powiedz jeszcze raz albo użyj plusa i wpisz."
                }
            }
        }
    }
}

final class QueueEar {
    let meter: Meter
    var request: SFSpeechAudioBufferRecognitionRequest
    private var queue: AudioQueueRef?
    private var rate: Double = 16_000

    init(request: SFSpeechAudioBufferRecognitionRequest, meter: Meter) {
        self.request = request
        self.meter = meter
    }

    func start() throws {
        let sessionRate = AVAudioSession.sharedInstance().sampleRate
        rate = sessionRate > 8_000 ? sessionRate : 16_000
        var desc = AudioStreamBasicDescription(
            mSampleRate: rate,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
        let pointer = Unmanaged.passUnretained(self).toOpaque()
        var created: AudioQueueRef?
        let made = AudioQueueNewInput(&desc, { user, queue, buffer, _, _, _ in
            guard let user else { return }
            let ear = Unmanaged<QueueEar>.fromOpaque(user).takeUnretainedValue()
            ear.consume(buffer)
            AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
        }, pointer, nil, nil, 0, &created)
        guard made == noErr, let created else {
            throw NSError(domain: "Mic", code: 8, userInfo: [NSLocalizedDescriptionKey: "kolejka \(made)"])
        }
        queue = created
        let bytes = UInt32(rate / 10) * 2
        for _ in 0..<3 {
            var buffer: AudioQueueBufferRef?
            guard AudioQueueAllocateBuffer(created, bytes, &buffer) == noErr, let buffer else { continue }
            AudioQueueEnqueueBuffer(created, buffer, 0, nil)
        }
        let started = AudioQueueStart(created, nil)
        guard started == noErr else {
            AudioQueueDispose(created, true)
            queue = nil
            throw NSError(domain: "Mic", code: 9, userInfo: [NSLocalizedDescriptionKey: "start kolejki \(started)"])
        }
    }

    func stop() {
        guard let queue else { return }
        self.queue = nil
        AudioQueueStop(queue, false)
        AudioQueueDispose(queue, false)
    }

    private func consume(_ buffer: AudioQueueBufferRef) {
        let bytes = Int(buffer.pointee.mAudioDataByteSize)
        let frames = bytes / 2
        guard frames > 0,
              let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: rate, channels: 1, interleaved: false),
              let pcm = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frames)),
              let dest = pcm.floatChannelData?[0] else { return }
        let source = buffer.pointee.mAudioData.assumingMemoryBound(to: Int16.self)
        pcm.frameLength = AVAudioFrameCount(frames)
        for index in 0..<frames {
            dest[index] = Float(source[index]) / 32768
        }
        request.append(pcm)
        meter.eat(pcm)
    }
}

final class CaptureEar: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    var request: SFSpeechAudioBufferRecognitionRequest?
    var meter: Meter?
    private let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "deutsch.capture")

    func start() async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                do {
                    self.session.usesApplicationAudioSession = false
                    self.session.beginConfiguration()
                    self.session.inputs.forEach { self.session.removeInput($0) }
                    self.session.outputs.forEach { self.session.removeOutput($0) }
                    guard let device = AVCaptureDevice.default(for: .audio) else {
                        throw NSError(domain: "Mic", code: 4, userInfo: [NSLocalizedDescriptionKey: "brak urządzenia audio"])
                    }
                    let input = try AVCaptureDeviceInput(device: device)
                    guard self.session.canAddInput(input) else {
                        throw NSError(domain: "Mic", code: 5, userInfo: [NSLocalizedDescriptionKey: "nie mogę podłączyć mikrofonu"])
                    }
                    self.session.addInput(input)
                    let output = AVCaptureAudioDataOutput()
                    output.setSampleBufferDelegate(self, queue: self.queue)
                    guard self.session.canAddOutput(output) else {
                        throw NSError(domain: "Mic", code: 6, userInfo: [NSLocalizedDescriptionKey: "brak wyjścia audio"])
                    }
                    self.session.addOutput(output)
                    self.session.commitConfiguration()
                    self.session.startRunning()
                    if self.session.isRunning {
                        cont.resume()
                    } else {
                        cont.resume(throwing: NSError(domain: "Mic", code: 7, userInfo: [NSLocalizedDescriptionKey: "sesja kamery-audio nie ruszyła"]))
                    }
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    func stop() {
        queue.async {
            if self.session.isRunning { self.session.stopRunning() }
        }
    }

    deinit {
        if session.isRunning { session.stopRunning() }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = Self.pcm(sampleBuffer) else { return }
        request?.append(buffer)
        meter?.eat(buffer)
    }

    private static func pcm(_ sampleBuffer: CMSampleBuffer) -> AVAudioPCMBuffer? {
        guard let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer),
              let asbdPtr = CMAudioFormatDescriptionGetStreamBasicDescription(formatDesc) else { return nil }
        var asbd = asbdPtr.pointee
        guard let src = AVAudioFormat(streamDescription: &asbd) else { return nil }
        let frames = AVAudioFrameCount(CMSampleBufferGetNumSamples(sampleBuffer))
        guard frames > 0, let dst = AVAudioPCMBuffer(pcmFormat: src, frameCapacity: frames) else { return nil }
        dst.frameLength = frames
        guard let block = CMSampleBufferGetDataBuffer(sampleBuffer) else { return nil }
        var length = 0
        var dataPointer: UnsafeMutablePointer<Int8>?
        guard CMBlockBufferGetDataPointer(block, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &length, dataPointerOut: &dataPointer) == kCMBlockBufferNoErr,
              let dataPointer else { return nil }
        let bytes = Int(frames) * Int(asbd.mBytesPerFrame == 0 ? asbd.mBitsPerChannel / 8 : asbd.mBytesPerFrame)
        guard bytes > 0, length >= bytes else { return nil }
        if let channels = dst.floatChannelData {
            dataPointer.withMemoryRebound(to: Float.self, capacity: Int(frames)) { ptr in
                channels[0].update(from: ptr, count: Int(frames))
            }
        } else if let channels = dst.int16ChannelData {
            dataPointer.withMemoryRebound(to: Int16.self, capacity: Int(frames)) { ptr in
                channels[0].update(from: ptr, count: Int(frames))
            }
        } else {
            return nil
        }
        return dst
    }
}

final class Meter: @unchecked Sendable {
    var peak: Float = 0

    func eat(_ buffer: AVAudioPCMBuffer) {
        let count = Int(buffer.frameLength)
        guard count > 0 else { return }
        var energy: Float = 0
        if let channel = buffer.floatChannelData?[0] {
            for index in 0..<count {
                let sample = channel[index]
                energy += sample * sample
            }
        } else if let channel = buffer.int16ChannelData?[0] {
            for index in 0..<count {
                let sample = Float(channel[index]) / 32768
                energy += sample * sample
            }
        } else {
            return
        }
        let rms = sqrt(energy / Float(count))
        peak = max(peak * 0.85, rms)
    }
}

enum Heard {
    static func parts(target: String, heard: String) -> [(word: String, ok: Bool)] {
        let bag = Set(Normalizer.clean(heard).split(separator: " ").map { String($0.filter(\.isLetter)) })
        return target.split(separator: " ").map { raw in
            let token = String(raw)
            let key = Normalizer.clean(token).filter(\.isLetter)
            let ok = key.count > 1 && bag.contains(where: { $0 == key || $0.contains(key) || key.contains($0) })
            return (token, ok)
        }
    }
}

extension View {
    func micPrompt(_ mic: Mic) -> some View {
        modifier(MicPrompt(mic: mic))
    }
}

private struct MicPrompt: ViewModifier {
    @ObservedObject var mic: Mic

    func body(content: Content) -> some View {
        content.alert("Dostęp do mikrofonu", isPresented: $mic.wantsPrompt) {
            Button("Pozwól") { mic.allowPrompt() }
            Button("Nie teraz", role: .cancel) {}
        } message: {
            Text("Aplikacja chce dostępu do mikrofonu, żeby słyszeć, jak mówisz po niemiecku.")
        }
    }
}
