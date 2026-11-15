import AVFoundation
import SwiftUI

struct DeTurn {
    let speaker: String
    let text: String
}

@MainActor
final class GermanVoice: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = GermanVoice()
    enum Phase: String { case idle, playing, paused }

    @Published var phase: Phase = .idle
    @Published var note = ""
    private let synth = AVSpeechSynthesizer()
    private var last: [DeTurn] = []

    static let sample = "Größe: 12,50 €. Käse, süß und spät. Die Tür ist zu, die Straße ist nass. Ich heiße Jürgen und bin um 7:15 da."

    private override init() {
        super.init()
        synth.delegate = self
    }

    static func installed() -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix("de") }
            .sorted { Talk.rank($0) > Talk.rank($1) }
    }

    static func qualities() -> [String] {
        let keys = Set(installed().map(qualityKey))
        return ["all", "premium", "enhanced", "default"].filter { $0 == "all" || keys.contains($0) }
    }

    static func qualityKey(_ voice: AVSpeechSynthesisVoice) -> String {
        switch voice.quality {
        case .premium: return "premium"
        case .enhanced: return "enhanced"
        default: return "default"
        }
    }

    static func qualityTitle(_ key: String) -> String {
        switch key {
        case "premium": return "Najlepszy"
        case "enhanced": return "Naturalny"
        case "default": return "Zwykły"
        default: return "Wszystkie"
        }
    }

    static func genderKey(_ voice: AVSpeechSynthesisVoice) -> String {
        if voice.gender == .female || Talk.isGirl(voice) { return "f" }
        if voice.gender == .male { return "m" }
        return "u"
    }

    static func genderTitle(_ key: String) -> String {
        switch key {
        case "f": return "Kobieta"
        case "m": return "Mężczyzna"
        default: return "Wszystkie"
        }
    }

    static func usable() -> [AVSpeechSynthesisVoice] {
        let all = installed()
        let quality = UserDefaults.standard.string(forKey: "deQuality") ?? "all"
        var list = quality == "all" ? all : all.filter { qualityKey($0) == quality }
        if list.isEmpty { list = all }
        let sex = UserDefaults.standard.string(forKey: "deGender") ?? "all"
        if sex == "m" || sex == "f" {
            let narrowed = list.filter { genderKey($0) == sex }
            if !narrowed.isEmpty { list = narrowed }
        }
        return list
    }

    static func gendersAvailable() -> [String] {
        let keys = Set(usable().map(genderKey).filter { $0 == "m" || $0 == "f" })
        guard keys.count > 1 else { return [] }
        return ["all"] + ["m", "f"].filter { keys.contains($0) }
    }

    static func rateValue() -> Float {
        let raw = UserDefaults.standard.string(forKey: "deRate") ?? "1"
        let mult = Float(raw) ?? 1
        let base = AVSpeechUtteranceDefaultSpeechRate
        let value = base * mult
        return min(AVSpeechUtteranceMaximumSpeechRate, max(AVSpeechUtteranceMinimumSpeechRate, value))
    }

    static func voice(id: String?) -> AVSpeechSynthesisVoice? {
        guard let id, !id.isEmpty else { return nil }
        return installed().first { $0.identifier == id }
    }

    func speak(text: String, voiceID: String? = nil) {
        let clean = text.replacingOccurrences(of: "*", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        speak(lines: [DeTurn(speaker: "Ty", text: clean)], force: voiceID)
    }

    func speak(lines: [DeTurn], force: String? = nil) {
        let turns = lines.map { DeTurn(speaker: $0.speaker, text: $0.text.replacingOccurrences(of: "*", with: "").trimmingCharacters(in: .whitespacesAndNewlines)) }
            .filter { !$0.text.isEmpty }
        guard !turns.isEmpty else { return }
        synth.stopSpeaking(at: .immediate)
        last = turns
        let pool = Self.installed()
        guard !pool.isEmpty else {
            note = "Na tym iPhonie nie ma głosu niemieckiego. Ściągnij go: Ustawienia → Dostępność → Treść mówiona → Głosy → Niemiecki."
            phase = .idle
            return
        }
        note = ""
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        let names = turns.map(\.speaker)
        for turn in turns {
            let utterance = AVSpeechUtterance(string: turn.text)
            if let force, let voice = Self.voice(id: force) ?? pool.first(where: { $0.identifier == force }) {
                utterance.voice = voice
            } else {
                utterance.voice = Self.voice(for: turn.speaker, among: names)
            }
            utterance.rate = Self.rateValue()
            utterance.preUtteranceDelay = 0.04
            utterance.postUtteranceDelay = 0.26
            synth.speak(utterance)
        }
        phase = .playing
    }

    func pause() {
        guard synth.isSpeaking else { return }
        synth.pauseSpeaking(at: .word)
        phase = .paused
    }

    func resume() {
        if synth.isPaused {
            synth.continueSpeaking()
            phase = .playing
            return
        }
        if !last.isEmpty { speak(lines: last) }
    }

    func stop() {
        synth.stopSpeaking(at: .immediate)
        phase = .idle
    }

    func replay() {
        guard !last.isEmpty else { return }
        speak(lines: last)
    }

    static func voice(for speaker: String, among names: [String]) -> AVSpeechSynthesisVoice? {
        let pool = usable()
        guard let first = pool.first else { return installed().first }
        let you = voice(id: UserDefaults.standard.string(forKey: "deVoiceYou")) ?? first
        let extras = pool.filter { $0.identifier != you.identifier }
        if speaker == "Ty" || extras.isEmpty { return you }
        let picked = voice(id: UserDefaults.standard.string(forKey: "deVoiceOther"))
        if let picked, picked.identifier != you.identifier { return picked }
        var others: [String] = []
        for name in names where name != "Ty" && !others.contains(name) { others.append(name) }
        let index = others.firstIndex(of: speaker) ?? 0
        return extras[index % extras.count]
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if !synthesizer.isSpeaking { self.phase = .idle }
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if !synthesizer.isSpeaking, !synthesizer.isPaused { self.phase = .idle }
        }
    }
}

struct LocalPlayBar: View {
    @ObservedObject private var voice = GermanVoice.shared

    var body: some View {
        HStack(spacing: 18) {
            Button {
                if voice.phase == .playing { voice.pause() } else { voice.resume() }
            } label: {
                Image(systemName: voice.phase == .playing ? "pause.fill" : "play.fill")
                    .frame(width: 44, height: 44)
            }
            Button { voice.stop() } label: {
                Image(systemName: "stop.fill").frame(width: 44, height: 44)
            }
            Button { voice.replay() } label: {
                Image(systemName: "arrow.counterclockwise").frame(width: 44, height: 44)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(Theme.ok)
        .disabled(GermanVoice.installed().isEmpty)
    }
}

struct GermanVoicesView: View {
    @ObservedObject private var voice = GermanVoice.shared
    @AppStorage("deQuality") private var quality = "all"
    @AppStorage("deGender") private var gender = "all"
    @AppStorage("deRate") private var rate = "1"
    @AppStorage("deVoiceYou") private var youID = ""
    @AppStorage("deVoiceOther") private var otherID = ""
    @AppStorage("lessonMotion") private var motion = true
    @State private var voices: [AVSpeechSynthesisVoice] = []

    private let rates = ["0.75", "1", "1.25", "1.5"]

    var body: some View {
        let shown = GermanVoice.usable()
        let sexes = GermanVoice.gendersAvailable()
        Form {
            Section {
                if GermanVoice.installed().isEmpty {
                    Text("Na tym iPhonie nie ma głosu niemieckiego. Ściągnij go w Ustawieniach iPhone’a: Dostępność → Treść mówiona → Głosy → Niemiecki. Dopiero wtedy da się odsłuchać próbkę. Nic nie jest wysyłane do sieci.")
                } else {
                    Text("Głos jest z iPhone’a i działa bez internetu. Tekst lekcji nie idzie do AI.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("Odsłuchaj próbkę") { GermanVoice.shared.speak(text: GermanVoice.sample) }
                    LocalPlayBar()
                    if !voice.note.isEmpty {
                        Text(voice.note).font(.footnote)
                    }
                }
            } header: {
                Text("Głos z iPhone’a")
            }
            if GermanVoice.qualities().count > 1 {
                Section("Jakość, tylko to, co jest na telefonie") {
                    Picker("Jakość", selection: $quality) {
                        ForEach(GermanVoice.qualities(), id: \.self) { key in
                            Text(GermanVoice.qualityTitle(key)).tag(key)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            if sexes.count > 1 {
                Section("Płeć, tylko dostępne warianty") {
                    Picker("Płeć", selection: $gender) {
                        ForEach(sexes, id: \.self) { key in
                            Text(GermanVoice.genderTitle(key)).tag(key)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            Section("Szybkość") {
                Picker("Szybkość", selection: $rate) {
                    ForEach(rates, id: \.self) { value in
                        Text(value == "1" ? "1.0x" : "\(value)x").tag(value)
                    }
                }
                .pickerStyle(.segmented)
            }
            if !shown.isEmpty {
                Section("Twój głos w dialogu") {
                    ForEach(shown, id: \.identifier) { voice in
                        voiceRow(voice, selected: youID == voice.identifier) { youID = voice.identifier }
                    }
                }
            }
            if shown.count > 1 {
                Section("Głos drugiej osoby") {
                    ForEach(shown, id: \.identifier) { voice in
                        voiceRow(voice, selected: otherID == voice.identifier) { otherID = voice.identifier }
                    }
                }
            }
            Section("Po lekcji") {
                Toggle("Animacja na koniec lekcji", isOn: $motion)
            }
            Section("Piper, Thorsten — nie jest w tej wersji") {
                Text("Głos Thorsten da się dodać później jako drugi głos offline. Nagrania Thorstena są publikowane jako CC0, a repozytorium Thorsten-Voice/Piper jest oznaczone MIT. Nowy silnik Piper (piper1-gpl) jest na GPL i ciągnie za sobą duży model, około 60–100 MB, plus osobną bibliotekę. Dlatego nie jest wbudowany. Rozmowa z AI zostaje osobno i dalej może używać ElevenLabs.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Głosy niemieckie")
        .scrollContentBackground(.hidden)
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { refresh() }
        .onChange(of: quality) { _, _ in refresh() }
        .onChange(of: gender) { _, _ in refresh() }
        .onDisappear { GermanVoice.shared.stop() }
    }

    private func refresh() {
        voices = GermanVoice.installed()
        let ids = Set(voices.map(\.identifier))
        if !youID.isEmpty, !ids.contains(youID) { youID = "" }
        if !otherID.isEmpty, !ids.contains(otherID) { otherID = "" }
        if !GermanVoice.qualities().contains(quality) { quality = "all" }
        if !GermanVoice.gendersAvailable().contains(gender), gender != "all" { gender = "all" }
    }

    private func voiceRow(_ voice: AVSpeechSynthesisVoice, selected: Bool, pick: @escaping () -> Void) -> some View {
        HStack {
            Button {
                pick()
                GermanVoice.shared.speak(text: GermanVoice.sample, voiceID: voice.identifier)
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(voice.name)
                    Text("\(voice.language) · \(GermanVoice.qualityTitle(GermanVoice.qualityKey(voice))) · \(GermanVoice.genderTitle(GermanVoice.genderKey(voice)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            Spacer()
            if selected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.ok)
            }
        }
    }
}
