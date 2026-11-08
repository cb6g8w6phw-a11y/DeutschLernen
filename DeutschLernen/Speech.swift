import AVFoundation
import Speech
import SwiftUI

enum Talk {
    static let synth = AVSpeechSynthesizer()

    static func de(_ text: String) {
        let clean = text.replacingOccurrences(of: "*", with: "")
        synth.stopSpeaking(at: .immediate)
        let u = AVSpeechUtterance(string: clean)
        u.voice = AVSpeechSynthesisVoice(language: "de-DE")
        u.rate = 0.46
        synth.speak(u)
    }

    static func stop() { synth.stopSpeaking(at: .immediate) }
}

@MainActor
final class Mic: ObservableObject {
    @Published var text = ""
    @Published var listening = false
    @Published var note = ""

    private var recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private var engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var tapped = false
    private var recorder: AVAudioRecorder?
    private var recordURL: URL?

    func toggle() {
        if listening { stop() } else { ask() }
    }

    private func ask() {
        SFSpeechRecognizer.requestAuthorization { status in
            Task { @MainActor in
                guard status == .authorized else {
                    self.note = "Włącz rozpoznawanie mowy dla LiveContainer: Ustawienia iPhone → Prywatność → Rozpoznawanie mowy."
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
                    self.note = "Brak mikrofonu. Ustawienia iPhone → Prywatność → Mikrofon → włącz LiveContainer."
                    return
                }
                self.begin()
            }
        }
    }

    private func begin() {
        stopEngine()
        Talk.stop()
        text = ""
        note = ""
        pickRecognizer()
        do {
            try openSession()
            engine = AVAudioEngine()
            try startEngine()
            if recognizer == nil || recognizer?.isAvailable != true {
                note = "Słucham, ale brakuje niemieckiego dyktowania. Ustawienia → Ogólne → Klawiatura → Dyktowanie."
            } else {
                note = "Słucham. Jak skończysz zdanie, samo pójdzie."
            }
        } catch {
            stopEngine()
            engine = AVAudioEngine()
            do {
                try startRecorder()
                note = "Słucham. Stuknij jeszcze raz, żeby wysłać."
            } catch {
                note = "Mikrofon nie wstał (\(error.localizedDescription)). Zgoda jest włączona, więc to nie przełącznik."
                listening = false
            }
        }
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
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        let attempts: [(AVAudioSession.Category, AVAudioSession.Mode, AVAudioSession.CategoryOptions)] = [
            (.playAndRecord, .default, [.defaultToSpeaker]),
            (.record, .default, []),
            (.playAndRecord, .default, [.defaultToSpeaker, .mixWithOthers, .allowBluetoothHFP])
        ]
        var last: Error?
        for (category, mode, options) in attempts {
            do {
                try session.setCategory(category, mode: mode, options: options)
                if let mic = session.availableInputs?.first(where: { $0.portType == .builtInMic }) {
                    try? session.setPreferredInput(mic)
                }
                try session.setActive(true)
                return
            } catch {
                last = error
                try? session.setActive(false, options: .notifyOthersOnDeactivation)
            }
        }
        throw last ?? NSError(domain: "Mic", code: 1, userInfo: [NSLocalizedDescriptionKey: "sesja audio"])
    }

    private func startEngine() throws {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        let input = engine.inputNode
        let output = input.outputFormat(forBus: 0)
        let incoming = input.inputFormat(forBus: 0)
        let hw: AVAudioFormat
        if output.sampleRate > 0, output.channelCount > 0 { hw = output }
        else if incoming.sampleRate > 0, incoming.channelCount > 0 { hw = incoming }
        else {
            throw NSError(domain: "Mic", code: 2, userInfo: [NSLocalizedDescriptionKey: "brak formatu mikrofonu"])
        }
        input.installTap(onBus: 0, bufferSize: 1024, format: hw) { buffer, _ in
            request.append(buffer)
        }
        tapped = true
        engine.prepare()
        try engine.start()
        listening = true
        task = recognizer?.recognitionTask(with: request) { result, _ in
            Task { @MainActor in
                if let result { self.text = result.bestTranscription.formattedString }
                if result?.isFinal == true { self.finishEngine() }
            }
        }
    }

    private func startRecorder() throws {
        try openSession()
        let folders = [
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        ].compactMap { $0 }
        let formats: [(String, [String: Any])] = [
            ("mowa.m4a", [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
            ]),
            ("mowa.caf", [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsBigEndianKey: false
            ])
        ]
        for folder in folders {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            for (name, settings) in formats {
                let url = folder.appendingPathComponent(name)
                try? FileManager.default.removeItem(at: url)
                guard let rec = try? AVAudioRecorder(url: url, settings: settings) else { continue }
                rec.prepareToRecord()
                if rec.record() {
                    recorder = rec
                    recordURL = url
                    listening = true
                    return
                }
                Thread.sleep(forTimeInterval: 0.2)
                if rec.record() {
                    recorder = rec
                    recordURL = url
                    listening = true
                    return
                }
            }
        }
        let session = AVAudioSession.sharedInstance()
        let inputs = session.availableInputs?.map(\.portName).joined(separator: ", ")
        throw NSError(
            domain: "Mic",
            code: 3,
            userInfo: [NSLocalizedDescriptionKey: "brak wejścia (\(inputs?.isEmpty == false ? inputs! : "telefon nie podał mikrofonu"))"]
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
        finishEngine()
    }

    private func finishEngine() {
        stopEngine()
        listening = false
    }

    private func stopEngine() {
        if engine.isRunning { engine.stop() }
        if tapped {
            engine.inputNode.removeTap(onBus: 0)
            tapped = false
        }
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
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
