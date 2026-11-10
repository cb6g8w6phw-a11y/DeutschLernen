import SwiftUI

struct DailyRunView: View {
    @EnvironmentObject var store: LearningStore
    @State private var step = 0
    @State private var wordScore = 0
    @State private var testScore = 0

    var body: some View {
        Group {
            switch step {
            case 0:
                LessonStep { step = 1 }
            case 1:
                QuizView(sessionSize: 8, onDone: { score in
                    wordScore = score
                    step = 2
                })
            case 2:
                sceneStep
            case 3:
                QuizView(sessionSize: 5, onDone: { score in
                    testScore = score
                    step = 4
                })
            default:
                summary
            }
        }
        .navigationTitle(step == 4 ? "Podsumowanie" : "Dziś")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var scene: Scenario {
        if let open = Scenarios.all.enumerated().first(where: { store.sceneUnlocked($0.offset) && store.stars(for: $0.element.id) < 3 })?.element {
            return open
        }
        return Scenarios.all[0]
    }

    private var sceneStep: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Jedna scena")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text(scene.title)
                .font(.title3.weight(.semibold))
            Text(scene.task)
                .font(.body)
                .foregroundStyle(Theme.text2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            NavigationLink { SceneChatView(scenario: scene) } label: {
                Text("Wejdź w scenę").primaryButton()
            }
            .padding(.horizontal)
            Button("Scena zrobiona, dalej") { step = 3 }
                .ghostButton()
            Spacer()
        }
        .padding()
        .appBackground()
    }

    private var summary: some View {
        let today = LearningStore.dayKey()
        let fresh = store.words.filter { (store.stats[$0.de]?.days ?? []).contains(today) && (store.stats[$0.de]?.days.count ?? 0) == 1 }
        let hit = UserDefaults.standard.string(forKey: "lastHit").flatMap { id in store.words.first { $0.de == id } }
        let miss = UserDefaults.standard.string(forKey: "lastMiss").flatMap { id in store.words.first { $0.de == id } }
        return ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Dobra robota")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("Powtórki: \(wordScore) poprawnych. Test: \(testScore) z 5.")
                    .foregroundStyle(Theme.text2)
                card("Nowe zdania dziś", fresh.isEmpty ? "Dziś wracały powtórki. Nowe zdanie wejdzie w następnej sesji." : "\(fresh.count) nowych. Na przykład: \(fresh[0].de)")
                card("Najlepsze zdanie", hit.map { "\($0.de)\n\($0.ex)" } ?? "Jeszcze jedno trafienie i pokażę je tutaj.")
                card("Jedno do poprawy", miss.map { "\($0.de) — \($0.pl)\n\($0.ex)" } ?? (store.mistakesToday.first.map { $0.fix.isEmpty ? $0.text : $0.fix } ?? "Bez potknięcia. Tak trzymaj."))
                Text("Opanowane: \(store.masteredCount). Słówko wchodzi tam po 3 dniach z poprawną odpowiedzią.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
            .padding(20)
        }
        .appBackground()
    }

    private func card(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 14, design: .rounded)).foregroundStyle(Theme.text2)
            Text(text).font(.system(size: 17, weight: .semibold, design: .rounded))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .themedCard()
    }
}

struct LessonStep: View {
    @EnvironmentObject var store: LearningStore
    var onDone: () -> Void
    @State private var lines: [Word] = []
    @State private var index = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Najpierw usłysz")
                .font(.largeTitle.bold())
            Text("Trzy zdania, wolno i po kolei. Tłumaczenie jest od razu pod spodem. Dopiero potem powtórki i scena.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            if lines.isEmpty {
                Text("Brak zdań w bazie.")
                Button("Dalej") { onDone() }.primaryButton()
            } else {
                let word = lines[min(index, lines.count - 1)]
                Text("\(index + 1) z \(lines.count)")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Text(word.ex.isEmpty ? word.de : word.ex)
                    .font(.title2.weight(.bold))
                Text(word.pl)
                    .font(.body)
                    .foregroundStyle(Theme.text2)
                Button {
                    Talk.de(word.ex.isEmpty ? word.de : word.ex)
                } label: {
                    Label("Odtwórz wolno", systemImage: "speaker.wave.2")
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                PaceButtons()
                Button(index + 1 < lines.count ? "Następne zdanie" : "Rozumiem, idę do powtórek") {
                    if index + 1 < lines.count {
                        index += 1
                        let next = lines[index]
                        Talk.de(next.ex.isEmpty ? next.de : next.ex)
                    } else {
                        onDone()
                    }
                }
                .primaryButton()
            }
            Spacer()
        }
        .padding(20)
        .appBackground()
        .onAppear {
            if lines.isEmpty {
                lines = Array(store.nextSession(size: 3).prefix(3))
                if let first = lines.first {
                    Talk.de(first.ex.isEmpty ? first.de : first.ex)
                }
            }
        }
    }
}
