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
        }
    }

    private var startScreen: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Słówek w bazie: \(store.words.count)").font(.headline)
            Text("Opanowane: \(store.masteredCount) · W nauce: \(store.learningCount) · Nowe: \(store.newCount)")
                .font(.subheadline).foregroundStyle(.secondary)
            Button("Zacznij sesję") { start() }
                .buttonStyle(.borderedProminent).controlSize(.large)
            Spacer()
        }
    }

    private func questionScreen(_ w: Word) -> some View {
        let prompt = typing ? w.pl : (deToPl ? w.de : w.pl)
        let expected = typing ? w.de : (deToPl ? w.pl : w.de)
        return ScrollView {
            VStack(spacing: 16) {
                Text("\(min(index + 1, queue.count)) / \(queue.count)")
                    .font(.caption).foregroundStyle(.secondary)
                Text(w.topic).font(.caption).padding(6)
                    .background(.thinMaterial, in: Capsule())
                Text(prompt).font(.largeTitle.bold()).multilineTextAlignment(.center)
                Text(typing ? "Wpisz po niemiecku" : (deToPl ? "Wybierz tłumaczenie" : "Wybierz po niemiecku"))
                    .font(.footnote).foregroundStyle(.secondary)

                if typing {
                    TextField("Odpowiedź", text: $typed)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disabled(answered)
                        .onSubmit { if !answered { finish(Normalizer.same(typed, w.de), w) } }
                    if !answered {
                        Button("Sprawdź") { finish(Normalizer.same(typed, w.de), w) }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    ForEach(options, id: \.self) { opt in
                        Button { choose(opt, expected: expected, w: w) } label: {
                            Text(opt).frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                        .buttonStyle(.bordered)
                        .tint(color(for: opt, expected: expected))
                    }
                }

                if answered {
                    VStack(spacing: 6) {
                        Text(wasCorrect ? "Dobrze!" : "Poprawnie: \(expected)")
                            .font(.headline).foregroundStyle(wasCorrect ? .green : .red)
                        Text(w.ex).italic()
                        Text(w.exPl).font(.footnote).foregroundStyle(.secondary)
                    }
                    Button("Dalej") { next() }.buttonStyle(.borderedProminent)
                }
            }
        }
    }

    private var finishScreen: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Koniec sesji").font(.title.bold())
            Text("Poprawne odpowiedzi: \(score)")
            Button("Następna sesja") { start() }.buttonStyle(.borderedProminent)
            Text("Chcesz nowe słówka dopasowane do twoich błędów? Zakładka Postępy → Lekcja od AI.")
                .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Spacer()
        }
    }

    // MARK: logika

    private func color(for opt: String, expected: String) -> Color {
        guard answered else { return .accentColor }
        if opt == expected { return .green }
        if opt == picked { return .red }
        return .gray
    }

    private func start() {
        queue = store.nextSession()
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
        typing = (store.stats[w.de]?.box ?? 0) >= 2
        deToPl = Bool.random()
        let pool = store.words.filter { $0.de != w.de }
        let same = pool.filter { $0.topic == w.topic }.shuffled()
        let rest = pool.filter { $0.topic != w.topic }.shuffled()
        let distractors = Array((same + rest).prefix(3))
        options = ([w] + distractors).shuffled().map { deToPl ? $0.pl : $0.de }
    }

    private func choose(_ opt: String, expected: String, w: Word) {
        guard !answered else { return }
        picked = opt
        finish(opt == expected, w)
    }

    private func finish(_ ok: Bool, _ w: Word) {
        answered = true
        wasCorrect = ok
        store.record(w, correct: ok)
        if ok { score += 1 } else { queue.append(w) }  // błędne wraca na koniec sesji
    }

    private func next() {
        index += 1
        prepare()
    }
}
