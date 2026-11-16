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
        var listenMin = 10
        var talkMin = 10
        var workMin = 10
        var lifeMin = 10
        var note = "Za mało Twoich odpowiedzi, żeby przesuwać czas. Plan jest równy: po 10 minut."
        let known = [listenN, speakN, sentenceN].filter { $0 >= 4 }
        if known.count >= 2 {
            if listen <= speak && listen <= sentence {
                listenMin = 15
                talkMin = 10
                workMin = 8
                lifeMin = 7
                note = "Słuchanie idzie słabiej niż mówienie. Dziś jest go więcej."
            } else if sentence <= speak {
                listenMin = 8
                talkMin = 15
                workMin = 10
                lifeMin = 7
                note = "Zdania idą słabiej. Dziś więcej mówienia i pracy."
            } else {
                listenMin = 10
                talkMin = 15
                workMin = 8
                lifeMin = 7
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
            PlanBlock(id: "fix", title: "Twoje błędy", minutes: 5, why: "Tylko to, co naprawdę pomyliłeś.")
        ]
        return (blocks, note)
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
                Text("45 minut")
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
                        if block.id == "listen" {
                            Text("Ukończone: dziś \(LearningStore.minuteText(store.journal.listenToday)), razem \(LearningStore.minuteText(store.journal.listenSeconds)).")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.ok)
                        }
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
            store.revealListenTime()
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
