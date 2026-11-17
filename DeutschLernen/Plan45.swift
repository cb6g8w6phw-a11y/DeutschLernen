import SwiftUI

struct PlanBlock: Identifiable, Equatable {
    let id: String
    let title: String
    let minutes: Int
    let why: String
    var detail: String = ""
    var kind: String = ""
    var topic: String = ""
    var clock: String = ""
}

private struct SavedStep: Codable {
    let id: String
    let title: String
    let minutes: Int
    let why: String
    let detail: String
    let kind: String
    let topic: String
    let clock: String

    init(_ block: PlanBlock) {
        id = block.id
        title = block.title
        minutes = block.minutes
        why = block.why
        detail = block.detail
        kind = block.kind
        topic = block.topic
        clock = block.clock
    }

    var block: PlanBlock {
        PlanBlock(id: id, title: title, minutes: minutes, why: why, detail: detail, kind: kind, topic: topic, clock: clock)
    }
}

enum DayPlan {
    static func make(_ journal: Journal) -> (blocks: [PlanBlock], note: String) {
        let saved = load()
        if !saved.isEmpty {
            return (saved, "Plan z dzisiaj. Kolejność zostaje, dopóki nie skończysz dnia.")
        }
        return (fallback(journal), "Około 45 minut: powtórki, nowe słowa, słuchanie i mówienie.")
    }

    @MainActor
    static func ensure(_ store: LearningStore) -> [PlanBlock] {
        let saved = load()
        if !saved.isEmpty { return saved }
        let built = build(store)
        if let data = try? JSONEncoder().encode(built.map(SavedStep.init)) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        UserDefaults.standard.set(built.first?.id ?? "", forKey: "daypath-first-\(LearningStore.dayKey())")
        return built
    }

    @MainActor
    static func rebuild(_ store: LearningStore) {
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.set(0, forKey: indexKey)
        _ = ensure(store)
    }

    static func index() -> Int { UserDefaults.standard.integer(forKey: indexKey) }

    static func currentKind() -> String? {
        let blocks = load()
        let cursor = index()
        guard cursor < blocks.count else { return nil }
        return blocks[cursor].kind
    }

    @discardableResult
    static func complete(kind: String) -> Bool {
        let blocks = load()
        let cursor = index()
        guard cursor < blocks.count else { return false }
        let step = blocks[cursor]
        guard step.kind == kind else { return false }
        if finished().contains(step.id) { return false }
        advance(done: true)
        return true
    }

    static func advance(done: Bool) {
        let blocks = load()
        let cursor = index()
        guard cursor < blocks.count else { return }
        var finished = UserDefaults.standard.stringArray(forKey: doneKey) ?? []
        var skipped = UserDefaults.standard.stringArray(forKey: skipKey) ?? []
        let id = blocks[cursor].id
        if done {
            if !finished.contains(id) { finished.append(id) }
        } else if !skipped.contains(id) {
            skipped.append(id)
        }
        UserDefaults.standard.set(finished, forKey: doneKey)
        UserDefaults.standard.set(skipped, forKey: skipKey)
        UserDefaults.standard.set(cursor + 1, forKey: indexKey)
    }

    static func finished() -> [String] { UserDefaults.standard.stringArray(forKey: doneKey) ?? [] }
    static func skipped() -> [String] { UserDefaults.standard.stringArray(forKey: skipKey) ?? [] }

    static func minutes(_ id: String, _ journal: Journal) -> Int {
        if let block = load().first(where: { $0.clock == id || $0.id == id }) { return block.minutes }
        return fallback(journal).first { $0.id == id }?.minutes ?? 10
    }

    private static var storageKey: String { "daypath-\(LearningStore.dayKey())" }
    private static var indexKey: String { "daypath-index-\(LearningStore.dayKey())" }
    private static var doneKey: String { "daypath-done-\(LearningStore.dayKey())" }
    private static var skipKey: String { "daypath-skip-\(LearningStore.dayKey())" }

    private static func load() -> [PlanBlock] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([SavedStep].self, from: data) else { return [] }
        return saved.map(\.block)
    }

    private static func fallback(_ journal: Journal) -> [PlanBlock] {
        _ = journal
        return [
            PlanBlock(id: "listen", title: "Słuchanie", minutes: 10, why: "Najpierw ucho.", detail: "rozumienie mowy", kind: "listen", clock: "listen"),
            PlanBlock(id: "talk", title: "Rozmowa z AI", minutes: 10, why: "Krótka odpowiedź i poprawka.", detail: "mówienie", kind: "talk", clock: "talk"),
            PlanBlock(id: "work", title: "Niemiecki w pracy", minutes: 10, why: "Budowa i szef.", detail: "praca", kind: "scene", topic: "Budowa", clock: "work"),
            PlanBlock(id: "life", title: "Codzienne życie", minutes: 8, why: "Poza pracą.", detail: "życie", kind: "scene", topic: "Codzienne życie", clock: "life"),
            PlanBlock(id: "fix", title: "Twoje błędy", minutes: 7, why: "To, co pomyliłeś.", detail: "błędy", kind: "fix", clock: "fix")
        ]
    }

    @MainActor
    private static func build(_ store: LearningStore) -> [PlanBlock] {
        let stored = UserDefaults.standard.integer(forKey: "dailyMinutes")
        let budget = max(15, stored == 0 ? 45 : stored)
        let journal = store.journal
        let salt = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let topics = ["Budowa", "Praca", "Narzędzia", "Materiały", "Codzienne życie", "Sklep", "Mieszkanie", "Lekarz", "Transport", "Urząd", "Jedzenie"]
        var topic = topics[salt % topics.count]
        let yesterday = UserDefaults.standard.string(forKey: "daypath-topic-\(yesterdayKey())") ?? ""
        if topic == yesterday { topic = topics[(salt + 1) % topics.count] }
        UserDefaults.standard.set(topic, forKey: "daypath-topic-\(LearningStore.dayKey())")

        let review = VocabBook.today(store, limit: 8, topic: "Wszystko", band: "Wszystkie", mode: "review")
        let hard = VocabBook.today(store, limit: 8, topic: "Wszystko", band: "Wszystkie", mode: "hard")
        let skills = [
            ("listen", journal.skillListenOK, journal.skillListenBad),
            ("speak", journal.skillSpeakOK, journal.skillSpeakBad),
            ("sentence", journal.skillSentenceOK, journal.skillSentenceBad),
            ("vocab", journal.skillVocabOK, journal.skillVocabBad),
            ("grammar", journal.skillGrammarOK, journal.skillGrammarBad)
        ]
        let weakest = skills.filter { $0.1 + $0.2 >= 2 }.min { lhs, rhs in
            Double(lhs.1) / Double(max(lhs.1 + lhs.2, 1)) < Double(rhs.1) / Double(max(rhs.1 + rhs.2, 1))
        }?.0

        var blocks: [PlanBlock] = []
        if !review.isEmpty || !hard.isEmpty {
            let count = max(review.count, min(hard.count, 6))
            blocks.append(PlanBlock(id: "weak-\(salt)", title: "Powtórka trudnych słówek", minutes: 8, why: hard.isEmpty ? "Minął termin powtórki." : "Te słowa ostatnio sprawiały trudność.", detail: "\(count) słów do utrwalenia", kind: "weak", topic: "Wszystko", clock: "vocab"))
        }
        blocks.append(PlanBlock(id: "fresh-\(topic)", title: "Nowe słownictwo", minutes: 10, why: "Temat dnia: \(topic.lowercased()). Inny niż wczoraj.", detail: "temat: \(topic.lowercased())", kind: "fresh", topic: topic, clock: "vocab2"))
        blocks.append(PlanBlock(id: "listen-\(salt)", title: "Słuchanie", minutes: weakest == "listen" ? 12 : 8, why: weakest == "listen" ? "Słuchanie wychodzi najsłabiej." : "Rozumienie naturalnej mowy.", detail: "ucho i znaczenie", kind: "listen", clock: "listen"))
        let speaking = weakest == "speak" || salt % 2 == 1
        blocks.append(PlanBlock(id: "speak-\(salt)", title: speaking ? "Mówienie" : "Rozmowa z AI", minutes: 10, why: speaking ? "Mówienie wychodzi najsłabiej." : "Reagujesz na zdanie i dostajesz poprawkę.", detail: salt % 2 == 0 ? "rozmowa z szefem" : "krótka odpowiedź", kind: speaking ? "speak" : "talk", topic: topic, clock: speaking ? "speak" : "talk"))
        let dialog = salt % 2 == 0
        blocks.append(PlanBlock(id: "scene-\(topic)", title: dialog ? "Mini dialog" : "Tekst z życia", minutes: 5, why: "Praktyczna sytuacja: \(topic.lowercased()).", detail: "praktyczna sytuacja", kind: dialog ? "scene" : "text", clock: dialog ? "work" : "life"))
        if !journal.mistakes.isEmpty || weakest == "grammar" || weakest == "sentence" {
            blocks.append(PlanBlock(id: "fix-\(salt)", title: "Sprawdzenie postępów", minutes: 5, why: journal.mistakes.isEmpty ? "Krótka gramatyka z tego, co mylisz." : "Wracają tylko Twoje błędy.", detail: "błędy i utrwalenie", kind: weakest == "grammar" ? "grammar" : "fix", clock: "fix"))
        }
        let raw = blocks.reduce(0) { $0 + $1.minutes }
        let scale = raw == 0 ? 1 : Double(budget) / Double(raw)
        let fitted = blocks.map { block -> PlanBlock in
            var copy = block
            copy.minutes = max(4, Int((Double(block.minutes) * scale).rounded()))
            return copy
        }
        let yesterdayFirst = UserDefaults.standard.string(forKey: "daypath-first-\(yesterdayKey())") ?? ""
        if let first = fitted.first, first.id == yesterdayFirst, fitted.count > 1, review.isEmpty {
            return Array(fitted.dropFirst()) + [fitted[0]]
        }
        return fitted
    }

    private static func yesterdayKey() -> String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return LearningStore.dayKey(date)
    }
}

struct PlanStepLink: View {
    let block: PlanBlock
    var prominent: Bool = false

    var body: some View {
        NavigationLink {
            Group {
                if block.kind == "listen" || block.kind == "talk" || block.kind == "fix" {
                    step
                } else {
                    step.lessonClock(block.clock, goal: block.minutes)
                }
            }
        } label: {
            Text(prominent ? "Rozpocznij pierwsze ćwiczenie" : "Rozpocznij")
                .font(.body.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color(hex: "2F6BFF"), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var step: some View {
        switch block.kind {
        case "weak":
            WortRun(topic: "Wszystko", band: "Wszystkie", mode: "hard", limit: 8)
        case "fresh":
            WortRun(topic: block.topic.isEmpty ? "Wszystko" : block.topic, band: "Wszystkie", mode: "new", limit: 10)
        case "listen":
            ListenView()
        case "speak":
            SpeakCoach()
        case "talk":
            TutorView()
        case "scene":
            SceneLibraryView()
        case "text":
            TextLibraryView()
        case "grammar":
            GrammarView()
        default:
            RepairView()
        }
    }
}

struct Plan45View: View {
    @EnvironmentObject var store: LearningStore
    @State private var done: Set<String> = []

    private var blocks: [PlanBlock] { DayPlan.ensure(store) }
    private var key: String { "plan45-\(LearningStore.dayKey())" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("\(blocks.reduce(0) { $0 + $1.minutes }) minut")
                    .font(.largeTitle.bold())
                Text("\(done.count) z \(blocks.count) bloków dziś")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ForEach(blocks) { block in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(block.title).font(.headline)
                            Spacer()
                            Text("\(block.minutes) min").foregroundStyle(Theme.text2)
                        }
                        Text(block.why).font(.subheadline).foregroundStyle(Theme.text2)
                        PlanStepLink(block: block)
                        Button(done.contains(block.id) ? "Zrobione" : "Odhacz ten blok") {
                            if done.contains(block.id) { done.remove(block.id) } else { done.insert(block.id) }
                            UserDefaults.standard.set(Array(done), forKey: key)
                        }
                        .buttonStyle(.glass)
                    }
                    .padding(14)
                    .themedCard(radius: 16)
                }
            }
            .padding(20)
        }
        .navigationTitle("Dzisiejsza nauka")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear { done = Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
    }
}

@MainActor
enum LessonClock {
    static func key(_ id: String) -> String { "lessonClock-\(LearningStore.dayKey())-\(id)" }
    static func seconds(_ id: String) -> Int { UserDefaults.standard.integer(forKey: key(id)) }
    static func add(_ id: String, _ extra: Int) {
        guard extra > 0 else { return }
        UserDefaults.standard.set(seconds(id) + extra, forKey: key(id))
    }
    static func label(_ id: String) -> String { LearningStore.minuteText(seconds(id)) }
}

private struct LessonClockModifier: ViewModifier {
    let id: String
    let goal: Int
    @State private var start = Date()
    @State private var base = 0

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top, spacing: 0) {
                TimelineView(.periodic(from: .now, by: 1)) { _ in
                    let now = base + max(0, Int(Date().timeIntervalSince(start)))
                    Text("\(LearningStore.minuteText(now)) z \(goal) min")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.ok)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.85))
                }
            }
            .onAppear {
                start = Date()
                base = LessonClock.seconds(id)
            }
            .onDisappear {
                LessonClock.add(id, Int(Date().timeIntervalSince(start)))
            }
    }
}

extension View {
    func lessonClock(_ id: String, goal: Int) -> some View {
        modifier(LessonClockModifier(id: id, goal: goal))
    }
}
