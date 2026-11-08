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
    @State private var speakGate = false
    @State private var saidWell = false
    @State private var sayNote = ""
    @State private var flip = false
    @State private var explain = ""
    @State private var requeued: Set<String> = []
    @AppStorage("drill") private var drill = "slowa"
    @AppStorage("band") private var band = "A1"
    @AppStorage("dailyGoal") private var dailyGoal = 20
    @AppStorage("sessionSize") private var savedSize = 20
    var sessionSize: Int = 0
    var onDone: ((Int) -> Void)? = nil
    @StateObject private var mic = Mic()

    private var size: Int { sessionSize > 0 ? sessionSize : savedSize }

    private var current: Word? { index < queue.count ? queue[index] : nil }

    var body: some View {
        Group {
            if !started {
                startScreen
            } else if let w = current {
                questionScreen(w)
            } else {
                finishScreen
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("Nauka")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { mic.stop() }
        .onChange(of: mic.listening) { was, now in
            guard was, !now, let w = current else { return }
            let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            if speakGate {
                if saidSentence(w.ex, heard) {
                    speakGate = false
                    saidWell = true
                    score += 1
                    Haptic.good()
                    store.grade(w, .easy)
                } else {
                    sayNote = "Jeszcze raz, wolniej: \(w.ex)"
                }
            } else if !answered, drill == "luki" {
                finish(hears(w, heard), w)
            }
        }
    }

    private var startScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Słówek w bazie: \(store.words.count)")
                .font(.headline)
                .foregroundStyle(Theme.text)
            Text("Opanowane: \(store.masteredCount) · W nauce: \(store.learningCount) · Nowe: \(store.newCount)")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            VStack(alignment: .leading, spacing: 8) {
                Text("Zrobione dziś: \(store.reviewsToday)/\(dailyGoal)")
                    .font(.headline)
                    .contentTransition(.numericText())
                ProgressView(value: Double(store.reviewsToday), total: Double(max(dailyGoal, 1)))
                    .tint(Theme.accent)
                Text("Do powtórki: \(store.dueToday). Cel nie zatrzymuje sesji.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Stepper("Słówek w sesji: \(savedSize)", value: $savedSize, in: 5...200, step: 5)
                Stepper("Cel dzienny: \(dailyGoal)", value: $dailyGoal, in: 5...200, step: 5)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .themedCard(radius: 18)
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
                .font(.footnote)
                .foregroundStyle(Theme.text2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Button { start() } label: {
                Text("Zacznij sesję").primaryButton()
            }
            .buttonStyle(.plain)
            Spacer(minLength: 0)
        }
        .padding(.top, 8)
    }

    private func questionScreen(_ w: Word) -> some View {
        let prompt = promptText(w)
        let expected = expectedText(w)
        let progress = Double(index) / Double(max(queue.count, 1))
        return VStack(spacing: 16) {
            Capsule()
                .fill(Theme.track)
                .frame(height: 4)
                .overlay(alignment: .leading) {
                    GeometryReader { geo in
                        Capsule()
                            .fill(Theme.gradient)
                            .frame(width: max(4, geo.size.width * progress))
                    }
                }
                .animation(.spring(duration: 0.35), value: progress)
            Text(topicMark(w.topic))
                .font(.caption)
                .foregroundStyle(Theme.text2)
            HStack(spacing: 8) {
                Text(prompt)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Button { Talk.de(drill == "zdania" && !flip ? w.ex : prompt) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.accent)
            }
            if let s = store.stats[w.de], s.wrong >= 3 {
                Text("To słowo często ci ucieka. Zostaje w powtórkach, aż siądzie.")
                    .font(.footnote)
                    .foregroundStyle(Theme.orange)
                    .multilineTextAlignment(.center)
            }
            Text(hint)
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Spacer(minLength: 8)
            if drill == "luki", !answered {
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powiedz brakujące słowo", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.text)
                if mic.listening {
                    Text(mic.text.isEmpty ? "Słucham…" : mic.text).font(.footnote).foregroundStyle(Theme.text2)
                }
            }
            if typing {
                TextField("Odpowiedź", text: $typed)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .disabled(answered)
                    .onSubmit { if !answered { finish(Normalizer.same(typed, expected), w) } }
                if !answered {
                    Button { finish(Normalizer.same(typed, expected), w) } label: {
                        Text("Sprawdź").frame(maxWidth: .infinity).frame(minHeight: 44)
                    }
                }
            } else {
                ForEach(options, id: \.self) { opt in
                    Button { choose(opt, expected: expected, w: w) } label: {
                        Text(opt)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(fill(opt, expected), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.25), lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(picked == opt ? 0.98 : 1)
                    .animation(.spring(duration: 0.25), value: picked)
                }
            }
            if !answered {
                Button { giveUp(w) } label: {
                    Text("Nie wiem")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.text2)
            }
            if speakGate {
                VStack(spacing: 8) {
                    Text("Powiedz to na głos")
                        .font(.headline)
                    Button { mic.toggle() } label: {
                        Label(mic.listening ? "Stop" : "Mówię", systemImage: "mic.fill")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.accent)
                    if !sayNote.isEmpty {
                        Text(sayNote).font(.footnote).foregroundStyle(Theme.text2).multilineTextAlignment(.center)
                    }
                }
            }
            if answered, !speakGate || saidWell {
                VStack(spacing: 6) {
                    Text(wasCorrect ? "Dobrze. Dzień \(min(3, store.stats[w.de]?.days.count ?? 1)) z 3." : "Poprawnie: \(expected)")
                        .font(.headline)
                        .foregroundStyle(wasCorrect ? Theme.ok : Theme.bad)
                        .contentTransition(.numericText())
                    Text(explain.isEmpty ? w.exPl : explain)
                        .font(.subheadline)
                        .foregroundStyle(Theme.text2)
                        .multilineTextAlignment(.center)
                }
                Button { next() } label: {
                    Text("Następne").primaryButton()
                }
                .buttonStyle(.plain)
            }
            Spacer(minLength: 8)
        }
        .safeAreaPadding(.bottom, 90)
    }

    private var finishScreen: some View {
        VStack(spacing: 16) {
            Text("Koniec sesji")
                .font(.largeTitle.bold())
            Text("Poprawne: \(score)")
                .font(.title2.weight(.bold))
                .contentTransition(.numericText())
            Text("Do powtórki: \(max(queue.count - score, 0))")
                .font(.body)
                .foregroundStyle(Theme.text2)
            Text("Zdanie jest opanowane, gdy 3 różne dni wybierzesz je dobrze i powiesz je na głos.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
                .multilineTextAlignment(.center)
            if onDone != nil {
                Button { onDone?(score) } label: { Text("Zakończ").primaryButton() }
                    .buttonStyle(.plain)
            } else {
                Button { start() } label: { Text("Następna sesja").primaryButton() }
                    .buttonStyle(.plain)
                Button { started = false } label: { Text("Zakończ").ghostButton() }
                    .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.top, 24)
        .overlay { ConfettiView() }
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
        case "zdania": return flip ? w.ex : w.exPl
        case "luki": return cloze(w)
        default: return typing ? w.pl : (deToPl ? w.de : w.pl)
        }
    }

    private func expectedText(_ w: Word) -> String {
        switch drill {
        case "zdania": return flip ? w.exPl : w.ex
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
        case "zdania": return flip ? item.exPl : item.ex
        case "luki": return item.de
        default: return deToPl ? item.pl : item.de
        }
    }

    private func fill(_ opt: String, _ expected: String) -> Color {
        guard answered else { return Color.white.opacity(0.08) }
        if opt == expected { return Theme.ok.opacity(0.85) }
        if opt == picked { return Theme.bad.opacity(0.85) }
        return Color.white.opacity(0.05)
    }

    private func start() {
        queue = store.nextSession(size: size, level: band)
        index = 0
        score = 0
        requeued = []
        started = true
        prepare()
    }

    private func prepare() {
        answered = false
        picked = nil
        typed = ""
        speakGate = false
        saidWell = false
        sayNote = ""
        explain = ""
        guard let w = current else { return }
        typing = drill == "slowa" && (store.stats[w.de]?.box ?? 0) >= 2
        flip = drill == "zdania" && (index + 1) % 4 == 0
        deToPl = flip ? true : Bool.random()
        if drill == "zdania" {
            let wrong = near(flip ? w.exPl : w.ex)
            options = ([flip ? w.exPl : w.ex] + wrong).shuffled()
            if !flip { loadSimilar(w.ex) }
        } else {
            let pool = store.words.filter { $0.de != w.de && (band == "oba" || $0.level == band) }
            let same = pool.filter { $0.topic == w.topic }.shuffled()
            let rest = pool.filter { $0.topic != w.topic }.shuffled()
            let distractors = Array((same + rest).prefix(3))
            options = ([w] + distractors).shuffled().map { choice($0) }
        }
    }

    private func near(_ sentence: String) -> [String] {
        let words = sentence.split(separator: " ").map(String.init)
        guard words.count > 2 else {
            return [sentence + " nicht", "Nicht " + sentence, sentence + " morgen"]
        }
        var order = words
        order.swapAt(0, order.count - 1)
        var ending = words
        if let i = ending.firstIndex(where: { $0.count > 4 }) {
            var token = ending[i]
            if token.hasSuffix("en") { token = String(token.dropLast(2)) + "t" }
            else if token.hasSuffix("t") { token = String(token.dropLast()) + "e" }
            else { token += "e" }
            ending[i] = token
        }
        var extra = words
        extra.insert("nicht", at: max(1, extra.count - 1))
        return [order, ending, extra].map { $0.joined(separator: " ") }.filter { $0 != sentence }
    }

    private func loadSimilar(_ correct: String) {
        let prompt = """
        Poprawne zdanie: \(correct)
        Podaj dokładnie 3 błędne zdania po niemiecku. Każde ma być bardzo podobne do poprawnego: inny czasownik, zły szyk albo zła końcówka. Nie dawaj zdań o innym temacie.
        Zwróć tylko JSON {"bad":["","",""]}.
        """
        Task {
            guard let text = try? await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Zwracasz wyłącznie JSON z trzema podobnymi, błędnymi zdaniami.",
                json: true
            ) else { return }
            let cleaned = text.replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "")
            guard let data = cleaned.data(using: .utf8),
                  let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let bad = obj["bad"] as? [String] else { return }
            let fresh = bad.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty && $0 != correct }
            guard fresh.count >= 2, !answered, current?.ex == correct else { return }
            options = ([correct] + fresh.prefix(3)).shuffled()
        }
    }

    private func saidSentence(_ expected: String, _ heard: String) -> Bool {
        let words = Normalizer.clean(expected).split(separator: " ").map(String.init).filter { $0.count > 2 }
        let said = Normalizer.clean(heard)
        guard !words.isEmpty else { return false }
        let hit = words.filter { said.contains($0) }.count
        return Double(hit) / Double(words.count) >= 0.6
    }

    private func choose(_ opt: String, expected: String, w: Word) {
        guard !answered else { return }
        picked = opt
        let ok = opt == expected
        if ok, drill == "zdania" {
            answered = true
            wasCorrect = true
            speakGate = true
            explain = "Najpierw powiedz to na głos. Dzień liczy się dopiero wtedy."
            Talk.de(w.ex)
            Haptic.good()
            return
        }
        finish(ok, w)
    }

    private func giveUp(_ w: Word) {
        guard !answered else { return }
        answered = true
        wasCorrect = false
        speakGate = false
        explain = "Jutro wraca. Poprawnie: \(expectedText(w))"
        Haptic.bad()
        store.scheduleTomorrow(w)
    }

    private func finish(_ ok: Bool, _ w: Word) {
        answered = true
        wasCorrect = ok
        speakGate = false
        if ok {
            score += 1
            explain = "Tak się to mówi. \(w.exPl)"
            Haptic.good()
            store.grade(w, .easy)
        } else {
            explain = "Poprawnie: \(expectedText(w)). \(w.exPl)"
            Haptic.bad()
            store.grade(w, .hard)
            bringBack(w)
        }
        if mic.listening { mic.stop() }
    }

    private func bringBack(_ w: Word) {
        guard !requeued.contains(w.de) else { return }
        requeued.insert(w.de)
        let at = min(queue.count, index + Int.random(in: 4...5))
        queue.insert(w, at: at)
    }

    private func next() {
        index += 1
        prepare()
    }
}
