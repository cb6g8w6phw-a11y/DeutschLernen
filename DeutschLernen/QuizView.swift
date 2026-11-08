import SwiftUI

struct QuizView: View {
    @EnvironmentObject var store: LearningStore

    @State private var queue: [Word] = []
    @State private var index = 0
    @State private var score = 0
    @State private var started = false

    @State private var deToPl = true
    @State private var typing = false
    @State private var options: [String] = []
    @State private var picked: String?
    @State private var typed = ""
    @State private var answered = false
    @State private var wasCorrect = false
    @AppStorage("drill") private var drill = "slowa"
    @AppStorage("band") private var band = "A1"
    var sessionSize: Int = 8
    @StateObject private var mic = Mic()

    private var current: Word? { index < queue.count ? queue[index] : nil }

    var body: some View {
        NavigationStack {
            Group {
                if !started {
                    startScreen
                } else if let w = current {
                    questionScreen(w)
                } else {
                    finishScreen
                }
            }
            .padding()
            .navigationTitle("Nauka")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                if started {
                    Button("Wróć") { started = false }.buttonStyle(.glass)
                }
            }
            .onDisappear { mic.stop() }
            .onChange(of: mic.listening) { was, now in
                guard was, !now, !answered, drill == "luki", let w = current else { return }
                let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !heard.isEmpty else { return }
                finish(hears(w, heard), w)
            }
        }
    }

    private var startScreen: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Słówek w bazie: \(store.words.count)").font(.headline)
            Text("Opanowane: \(store.masteredCount) · W nauce: \(store.learningCount) · Nowe: \(store.newCount)")
                .font(.subheadline).foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 6) {
                Text("Do powtórki dzisiaj: \(store.dueToday)").font(.headline)
                let done = min(store.reviewsToday, 20)
                ProgressView(value: Double(done), total: 20).tint(Ink.brass)
                Text("Dzisiejszy cel: \(done)/20 słówek")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass(radius: 18)
            Picker("Poziom", selection: $band) {
                Text("A1").tag("A1")
                Text("A2").tag("A2")
                Text("Oba").tag("oba")
            }
            .pickerStyle(.segmented)
            Picker("Tryb", selection: $drill) {
                Text("Słówka").tag("slowa")
                Text("Zdania").tag("zdania")
                Text("Luki").tag("luki")
            }
            .pickerStyle(.segmented)
            Text(drillHint)
                .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button("Zacznij sesję") { start() }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
                .controlSize(.large)
            Spacer()
        }
    }

    private func questionScreen(_ w: Word) -> some View {
        let prompt = promptText(w)
        let expected = expectedText(w)
        return ScrollView {
            VStack(spacing: 16) {
                Text("\(min(index + 1, queue.count)) / \(queue.count)")
                    .font(.caption).foregroundStyle(.secondary)
                Text(topicMark(w.topic)).font(.caption).padding(.horizontal, 10).padding(.vertical, 6)
                    .liquidGlass(radius: 20)
                Text(prompt)
                    .font(drill == "slowa" ? .largeTitle.bold() : .title3.bold())
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                if let s = store.stats[w.de], s.wrong >= 3 {
                    Text("To słowo często ci ucieka. Zostaje w powtórkach, aż siądzie.")
                        .font(.footnote).foregroundStyle(Ink.clay)
                        .multilineTextAlignment(.center)
                }
                Text(hint)
                    .font(.footnote).foregroundStyle(.secondary)
                if drill == "luki", !answered {
                    Button { mic.toggle() } label: {
                        Label(mic.listening ? "Stop" : "Powiedz brakujące słowo", systemImage: "mic.fill")
                    }
                    .buttonStyle(.glass)
                    if mic.listening {
                        Text(mic.text.isEmpty ? "Słucham…" : mic.text).font(.footnote)
                    }
                    if !mic.note.isEmpty { Text(mic.note).font(.caption).foregroundStyle(.secondary) }
                }

                if typing {
                    TextField("Odpowiedź", text: $typed)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disabled(answered)
                        .onSubmit { if !answered { finish(Normalizer.same(typed, expected), w) } }
                    if !answered {
                        Button("Sprawdź") { finish(Normalizer.same(typed, expected), w) }
                            .buttonStyle(.glassProminent)
                            .tint(Ink.brass)
                    }
                } else {
                    ForEach(options, id: \.self) { opt in
                        Button { choose(opt, expected: expected, w: w) } label: {
                            Text(opt).frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                        .buttonStyle(.glass)
                        .tint(color(for: opt, expected: expected))
                    }
                }

                if answered {
                    VStack(spacing: 6) {
                        Text(wasCorrect ? "Dobrze. Słówko jest opanowane." : "Poprawnie: \(expected)")
                            .font(.headline).foregroundStyle(wasCorrect ? .green : .red)
                        Text(w.ex).italic()
                        Text(w.exPl).font(.footnote).foregroundStyle(.secondary)
                    }
                    Button("Następne") { next() }
                        .buttonStyle(.glassProminent)
                        .tint(Ink.brass)
                }
            }
        }
    }

    private var finishScreen: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Koniec sesji").font(.title.bold())
            Text("Poprawne odpowiedzi: \(score)")
            Button("Następna sesja") { start() }.buttonStyle(.glassProminent).tint(Ink.brass)
            NavigationLink("Postępy i lekcja od AI") { StatsView() }
                .buttonStyle(.glass)
            Text("Trudne wraca za 10 minut, średnie jutro, łatwe za 4 dni. Sesja bierze tylko to, co już czas powtórzyć.")
                .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Spacer()
        }
    }

    // MARK: logika

    private var drillHint: String {
        switch drill {
        case "zdania": return "Widzisz polskie zdanie. Wybierz, jak to powiedzieć po niemiecku."
        case "luki": return "W zdaniu brakuje słowa. Możesz je stuknąć albo powiedzieć do mikrofonu."
        default: return "Słówka i krótkie zwroty z życia i z pracy. Bez „dzień dobry”."
        }
    }

    private var hint: String {
        if typing { return "Wpisz po niemiecku" }
        switch drill {
        case "zdania": return "Wybierz zdanie po niemiecku"
        case "luki": return "Uzupełnij lukę"
        default: return deToPl ? "Wybierz tłumaczenie" : "Wybierz po niemiecku"
        }
    }

    private func promptText(_ w: Word) -> String {
        switch drill {
        case "zdania": return w.exPl
        case "luki": return cloze(w)
        default: return typing ? w.pl : (deToPl ? w.de : w.pl)
        }
    }

    private func expectedText(_ w: Word) -> String {
        switch drill {
        case "zdania": return w.ex
        case "luki", "slowa": return typing ? w.de : (drill == "luki" ? w.de : (deToPl ? w.pl : w.de))
        default: return w.de
        }
    }

    private func cloze(_ w: Word) -> String {
        let token = bare(w.de)
        if let r = w.ex.range(of: token) {
            return w.ex.replacingCharacters(in: r, with: "______")
        }
        return "______  ·  \(w.exPl)"
    }

    private func bare(_ de: String) -> String {
        var token = de
        for a in ["der ", "die ", "das ", "sich "] where token.lowercased().hasPrefix(a) {
            token = String(token.dropFirst(a.count))
        }
        return token
    }

    private func hears(_ w: Word, _ heard: String) -> Bool {
        let key = Normalizer.clean(bare(w.de)).filter(\.isLetter)
        let said = Normalizer.clean(heard)
        guard key.count > 1 else { return false }
        return said.contains(key)
    }

    private func topicMark(_ topic: String) -> String {
        let s = topic.lowercased()
        let mark: String
        if s.contains("warsztat") || s.contains("auto") { mark = "🔧" }
        else if s.contains("budow") { mark = "🧱" }
        else if s.contains("magaz") { mark = "📦" }
        else if s.contains("lekar") || s.contains("zdrow") { mark = "🩺" }
        else if s.contains("miesz") || s.contains("dom") { mark = "🏠" }
        else if s.contains("sklep") { mark = "🛒" }
        else { mark = "💬" }
        return "\(mark) \(topic)"
    }

    private func choice(_ item: Word) -> String {
        switch drill {
        case "zdania": return item.ex
        case "luki": return item.de
        default: return deToPl ? item.pl : item.de
        }
    }

    private func color(for opt: String, expected: String) -> Color {
        guard answered else { return Ink.brass }
        if opt == expected { return Ink.pine }
        if opt == picked { return Ink.clay }
        return .gray
    }

    private func start() {
        queue = store.nextSession(size: sessionSize, level: band)
        index = 0
        score = 0
        started = true
        prepare()
    }

    private func prepare() {
        answered = false
        picked = nil
        typed = ""
        guard let w = current else { return }
        typing = drill == "slowa" && (store.stats[w.de]?.box ?? 0) >= 2
        deToPl = Bool.random()
        let pool = store.words.filter { $0.de != w.de && (band == "oba" || $0.level == band) }
        let same = pool.filter { $0.topic == w.topic }.shuffled()
        let rest = pool.filter { $0.topic != w.topic }.shuffled()
        let distractors = Array((same + rest).prefix(3))
        options = ([w] + distractors).shuffled().map { choice($0) }
    }

    private func choose(_ opt: String, expected: String, w: Word) {
        guard !answered else { return }
        picked = opt
        finish(opt == expected, w)
    }

    private func finish(_ ok: Bool, _ w: Word) {
        answered = true
        wasCorrect = ok
        if ok {
            score += 1
            Haptic.good()
        } else {
            Haptic.bad()
        }
        if mic.listening { mic.stop() }
        store.grade(w, ok ? .easy : .hard)
    }

    private func next() {
        index += 1
        prepare()
    }
}
