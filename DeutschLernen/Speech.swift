import AVFoundation
import Speech
import SwiftUI

enum Talk {
    static let synth = AVSpeechSynthesizer()

    static func de(_ text: String, rate: Float = 0.46, voice: String? = nil) {
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

    private var recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private var engine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var tapped = false
    private var recorder: AVAudioRecorder?
    private var recordURL: URL?
    private var ear: CaptureEar?
    private var meter = Meter()
    private var generation = 0
    private var heardError: String?

    func toggle() {
        if listening { stop() } else { ask() }
    }

    private func ask() {
        SFSpeechRecognizer.requestAuthorization { status in
            Task { @MainActor in
                guard status == .authorized else {
                    self.note = "Włącz rozpoznawanie mowy dla LiveContainer: Ustawienia → Prywatność → Rozpoznawanie mowy."
                    return
                }
                self.askMic()
            }
        }
    }

    private func askMic() {
        let session = AVAudioSession.sharedInstance()
        if session.recordPermission == .granted {
            begin()
            return
        }
        session.requestRecordPermission { ok in
            Task { @MainActor in
                guard ok else {
                    self.note = "Brak mikrofonu. Ustawienia → Prywatność → Mikrofon → LiveContainer."
                    return
                }
                self.begin()
            }
        }
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
        note = "Włączam mikrofon…"
        pickRecognizer()
        do {
            try openSession()
            try startEngine()
            listening = true
            note = "Słucham…"
            if await healthy(token) { return }
            stopEngine()
        } catch {
            stopEngine()
            heardError = error.localizedDescription
        }
        guard token == generation else { return }
        do {
            try openSession()
            try await startCapture()
            listening = true
            note = "Słucham drugą drogą…"
            meter.peak = 0
            if await healthy(token) { return }
            ear?.stop()
            ear = nil
            stopEngine()
        } catch {
            ear?.stop()
            ear = nil
            stopEngine()
            heardError = error.localizedDescription
        }
        guard token == generation else { return }
        do {
            try openSession()
            try startRecorder()
            listening = true
            note = "Nagrywam. Powiedz zdanie i stuknij kwadrat."
        } catch {
            listening = false
            let extra = heardError.map { " \($0)" } ?? ""
            note = "Mikrofon nie wstał (\(error.localizedDescription)).\(extra)"
        }
    }

    private func healthy(_ token: Int) async -> Bool {
        for _ in 0..<7 {
            try? await Task.sleep(nanoseconds: 200_000_000)
            guard token == generation, listening else { return true }
            level = Double(min(1, meter.peak * 8))
            if !text.isEmpty {
                note = "Słyszę…"
                return true
            }
        }
        guard token == generation, listening else { return true }
        if meter.peak > 0.012 {
            note = heardError ?? "Słyszę głos. Mów całe zdanie po niemiecku."
            return heardError == nil
        }
        if let heardError { note = heardError }
        return false
    }

    private func pickRecognizer() {
        for id in ["de-DE", "pl-PL", Locale.current.identifier] {
            if let r = SFSpeechRecognizer(locale: Locale(identifier: id)), r.isAvailable {
                recognizer = r
                return
            }
        }
    }

    private func openSession() throws {
        let session = AVAudioSession.sharedInstance()
        let attempts: [(AVAudioSession.Category, AVAudioSession.Mode, AVAudioSession.CategoryOptions)] = [
            (.playAndRecord, .spokenAudio, [.defaultToSpeaker, .allowBluetoothHFP]),
            (.playAndRecord, .voiceChat, [.defaultToSpeaker, .allowBluetoothHFP]),
            (.record, .measurement, []),
            (.playAndRecord, .default, [.defaultToSpeaker, .mixWithOthers])
        ]
        var last: Error?
        for (category, mode, options) in attempts {
            do {
                try session.setCategory(category, mode: mode, options: options)
                try? session.setPreferredSampleRate(44_100)
                try session.setActive(true)
                if session.currentRoute.inputs.isEmpty, let mic = session.availableInputs?.first(where: { $0.portType == .builtInMic }) {
                    try? session.setPreferredInput(mic)
                    try? session.setActive(true)
                }
                return
            } catch {
                last = error
            }
        }
        throw last ?? NSError(domain: "Mic", code: 1, userInfo: [NSLocalizedDescriptionKey: "sesja audio"])
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
                            self.note = error.localizedDescription
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
        task = recognizer?.recognitionTask(with: request) { result, _ in
            Task { @MainActor in
                if let result { self.text = result.bestTranscription.formattedString }
                if result?.isFinal == true { self.finishListen() }
            }
        }
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

final class CaptureEar: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    var request: SFSpeechAudioBufferRecognitionRequest?
    var meter: Meter?
    private let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "deutsch.capture")

    func start() async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                do {
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
