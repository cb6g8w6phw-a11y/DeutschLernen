import SwiftUI

struct PlanBlock: Identifiable {
    let id: String
    let title: String
    let minutes: Int
    let why: String
}

enum DayPlan {
    static func make(_ journal: Journal) -> (blocks: [PlanBlock], note: String) {
        let listenN = journal.skillListenOK + journal.skillListenBad
        let speakN = journal.skillSpeakOK + journal.skillSpeakBad
        let sentenceN = journal.skillSentenceOK + journal.skillSentenceBad
        let listen = rate(journal.skillListenOK, listenN)
        let speak = rate(journal.skillSpeakOK, speakN)
        let sentence = rate(journal.skillSentenceOK, sentenceN)
        var listenMin = 4
        var talkMin = 3
        var workMin = 3
        var lifeMin = 2
        var note = "Około 14 minut: powtórki, kilka nowych zdań, słuchanie i krótka rozmowa."
        let known = [listenN, speakN, sentenceN].filter { $0 >= 4 }
        if known.count >= 2 {
            if listen <= speak && listen <= sentence {
                listenMin = 5
                talkMin = 3
                workMin = 3
                lifeMin = 2
                note = "Słuchanie idzie słabiej. Dziś jest go trochę więcej."
            } else if sentence <= speak {
                listenMin = 3
                talkMin = 4
                workMin = 4
                lifeMin = 2
                note = "Zdania idą słabiej. Dziś więcej mówienia i pracy."
            } else {
                listenMin = 3
                talkMin = 5
                workMin = 3
                lifeMin = 2
                note = "Mówienie idzie słabiej. Dziś dłuższa rozmowa."
            }
        }
        let day = Calendar.current.component(.weekday, from: Date())
        let workWhy = ["Polecenia szefa.", "Koledzy na zmianie.", "Narzędzia i materiały.", "Bezpieczeństwo.", "Godziny i koniec pracy."][day % 5]
        let lifeWhy = ["Sklep.", "Dojazd.", "Lekarz.", "Sąsiad.", "Telefon."][day % 5]
        let blocks = [
            PlanBlock(id: "listen", title: "Słuchanie", minutes: listenMin, why: day % 2 == 0 ? "Najpierw wolno, potem normalne tempo." : "Najpierw normalne tempo, wolniej tylko gdy nie wejdziesz."),
            PlanBlock(id: "talk", title: "Rozmowa z AI", minutes: talkMin, why: "Jedno pytanie, Twoja odpowiedź, krótka poprawka."),
            PlanBlock(id: "work", title: "Niemiecki w pracy", minutes: workMin, why: workWhy),
            PlanBlock(id: "life", title: "Codzienne życie", minutes: lifeMin, why: lifeWhy),
            PlanBlock(id: "fix", title: "Twoje błędy", minutes: 2, why: "Tylko to, co naprawdę pomyliłeś.")
        ]
        return (blocks, note)
    }

    static func minutes(_ id: String, _ journal: Journal) -> Int {
        make(journal).blocks.first { $0.id == id }?.minutes ?? 10
    }

    private static func rate(_ ok: Int, _ total: Int) -> Double {
        guard total > 0 else { return 1 }
        return Double(ok) / Double(total)
    }
}

struct Plan45View: View {
    @EnvironmentObject var store: LearningStore
    @State private var done: Set<String> = []

    private var plan: (blocks: [PlanBlock], note: String) { DayPlan.make(store.journal) }
    private var key: String { "plan45-\(LearningStore.dayKey())" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("\(plan.blocks.reduce(0) { $0 + $1.minutes }) minut")
                    .font(.largeTitle.bold())
                Text(plan.note)
                    .foregroundStyle(Theme.text2)
                Text("\(done.count) z \(plan.blocks.count) bloków dziś")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ForEach(plan.blocks) { block in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(block.title).font(.headline)
                            Spacer()
                            Text("\(block.minutes) min")
                                .foregroundStyle(Theme.text2)
                        }
                        Text(block.why)
                            .font(.subheadline)
                            .foregroundStyle(Theme.text2)
                        Text("\(LessonClock.label(block.id)) z \(block.minutes) min")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.ok)
                        destination(block.id)
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
        .onAppear {
            done = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        }
    }

    @ViewBuilder
    private func destination(_ id: String) -> some View {
        switch id {
        case "listen":
            NavigationLink("Otwórz słuchanie") { ListenView() }
        case "talk":
            NavigationLink("Otwórz rozmowę") { TutorView() }
        case "work":
            NavigationLink("Otwórz pracę") { WorkHubView() }
        case "life":
            NavigationLink("Otwórz codzienność") { LifeView() }
        default:
            NavigationLink("Otwórz błędy") { RepairView() }
        }
    }
}

@MainActor
enum LessonClock {
    static func key(_ id: String) -> String { "lessonClock-\(LearningStore.dayKey())-\(id)" }

    static func seconds(_ id: String) -> Int {
        UserDefaults.standard.integer(forKey: key(id))
    }

    static func add(_ id: String, _ extra: Int) {
        guard extra > 0 else { return }
        let name = key(id)
        UserDefaults.standard.set(seconds(id) + extra, forKey: name)
    }

    static func label(_ id: String) -> String {
        LearningStore.minuteText(seconds(id))
    }
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
