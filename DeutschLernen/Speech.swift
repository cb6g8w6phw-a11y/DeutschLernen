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

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var tapped = false

    func toggle() {
        if listening { stop() } else { ask() }
    }

    private func ask() {
        SFSpeechRecognizer.requestAuthorization { status in
            Task { @MainActor in
                guard status == .authorized else {
                    self.note = "Włącz rozpoznawanie mowy w ustawieniach iPhone."
                    return
                }
                AVAudioApplication.requestRecordPermission { ok in
                    Task { @MainActor in
                        guard ok else { self.note = "Brak dostępu do mikrofonu."; return }
                        self.begin()
                    }
                }
            }
        }
    }

    private func begin() {
        stop()
        Talk.stop()
        text = ""
        note = ""
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true)
            let input = engine.inputNode
            let format = input.outputFormat(forBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                request.append(buffer)
            }
            tapped = true
            engine.prepare()
            try engine.start()
            listening = true
            task = recognizer?.recognitionTask(with: request) { result, error in
                Task { @MainActor in
                    if let result { self.text = result.bestTranscription.formattedString }
                    if error != nil || (result?.isFinal ?? false) { self.stop() }
                }
            }
        } catch {
            note = "Mikrofon nie wystartował."
            stop()
        }
    }

    func stop() {
        if engine.isRunning { engine.stop() }
        if tapped {
            engine.inputNode.removeTap(onBus: 0)
            tapped = false
        }
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
        listening = false
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
