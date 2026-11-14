import SwiftUI

/// Najpierw pokazuje zdanie i je odtwarza. Potem je chowa.
/// Dzień do opanowania liczy się tylko wtedy, gdy uczeń sam je napisze.
struct StudyView: View {
    @EnvironmentObject var store: LearningStore
    @State private var queue: [Word] = []
    @State private var index = 0
    @State private var phase = 0
    @State private var typed = ""
    @State private var verdict = ""
    @State private var wasOK = false
    @State private var produced = 0
    @State private var missed = 0
    @AppStorage("band") private var band = "A1"
    @FocusState private var writing: Bool

    private var word: Word? { index < queue.count ? queue[index] : nil }
    private var done: Bool { !queue.isEmpty && word == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if queue.isEmpty {
                    Text("Nie ma teraz czego uczyć.").font(.title2.bold())
                } else if done {
                    Text("Koniec lekcji").font(.largeTitle.bold())
                    Text("Sam napisałeś \(produced). Nie weszło \(missed).")
                        .font(.title3)
                    Text("Opanowane jest tylko to, co napiszesz sam w różne dni. Samo rozpoznanie słowa tego nie zalicza.")
                        .foregroundStyle(Theme.text2)
                    Button("Następne zdania") { load() }.primaryButton()
                } else if let word {
                    Text("\(index + 1) z \(queue.count)")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    if phase == 0 {
                        teach(word)
                    } else if phase == 1 {
                        write(word)
                    } else {
                        result(word)
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .navigationTitle("Nauka")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { if queue.isEmpty { load() } }
        .onDisappear { Talk.stop() }
    }

    private func teach(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Najpierw się naucz. Odpowiedź schowam dopiero potem.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            Text(word.pl)
                .font(.title3.weight(.semibold))
            Text(sentence(word))
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text(word.topic)
                .font(.caption)
                .foregroundStyle(Theme.text2)
            Button { Talk.de(sentence(word), rate: 0.42) } label: {
                Label("Posłuchaj", systemImage: "speaker.wave.2.fill")
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.glass)
            Button("Schowaj i napisz sam") {
                typed = ""
                verdict = ""
                phase = 1
                writing = true
            }
            .primaryButton()
        }
    }

    private func write(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Napisz to po niemiecku. Podpowiedzi już nie ma.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            Text(word.pl)
                .font(.title2.bold())
            TextField("Twoje zdanie", text: $typed, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($writing)
            Button("Sprawdź") { check(word) }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
            Button("Nie pamiętam") { giveUp(word) }
                .ghostButton()
        }
    }

    private func result(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(wasOK ? "Sam to napisałeś. Ten dzień się liczy." : "Jeszcze nie. Jutro wraca.")
                .font(.headline)
                .foregroundStyle(wasOK ? Theme.ok : Theme.bad)
            Text(sentence(word)).font(.title3.bold())
            Text(word.pl).foregroundStyle(Theme.text2)
            if !verdict.isEmpty { Text(verdict).foregroundStyle(Theme.text2) }
            Button { Talk.de(sentence(word), rate: 0.42) } label: {
                Label("Posłuchaj jeszcze raz", systemImage: "speaker.wave.2")
            }
            .buttonStyle(.glass)
            Button(index + 1 >= queue.count ? "Zakończ" : "Następne") {
                index += 1
                phase = 0
                typed = ""
                verdict = ""
            }
            .primaryButton()
        }
    }

    private func sentence(_ word: Word) -> String {
        let ex = word.ex.trimmingCharacters(in: .whitespacesAndNewlines)
        if ex.split(separator: " ").count >= 3, ex.compare(word.de, options: .caseInsensitive) != .orderedSame {
            return ex
        }
        return word.de
    }

    private func check(_ word: Word) {
        let target = sentence(word)
        let said = typed.trimmingCharacters(in: .whitespacesAndNewlines)
        let hit = Normalizer.same(said, target) || Normalizer.same(said, word.de) || Normalizer.clean(said).contains(Normalizer.clean(word.de))
        wasOK = hit
        phase = 2
        writing = false
        if hit {
            produced += 1
            verdict = "Opanowanie idzie dopiero po trzech takich dniach, nie po rozpoznaniu w teście."
            store.grade(word, .easy, produced: true)
            Haptic.good()
        } else {
            missed += 1
            verdict = "Twoje: \(said)"
            store.grade(word, .hard, produced: false)
            Haptic.bad()
            if !queue.dropFirst(index + 1).contains(where: { $0.de == word.de }) {
                queue.append(word)
            }
        }
    }

    private func giveUp(_ word: Word) {
        wasOK = false
        missed += 1
        verdict = "Zerknąłeś. Ten raz nie liczy się jako opanowane."
        phase = 2
        store.scheduleTomorrow(word)
        Haptic.bad()
    }

    private func load() {
        queue = Array(store.nextSession(size: 8, level: band).prefix(8))
        if queue.isEmpty { queue = Array(store.catalog(level: band).prefix(8)) }
        index = 0
        phase = 0
        produced = 0
        missed = 0
        typed = ""
        verdict = ""
    }
}
