import SwiftUI

enum SpokenMatch {
    static func ok(_ said: String, _ want: String) -> Bool {
        let got = AnswerCheck.fold(said)
        let need = AnswerCheck.fold(want)
        if got.isEmpty || need.isEmpty { return false }
        if got == need { return true }
        if AnswerCheck.distance(got, need) <= max(2, need.count / 7) { return true }
        let words = need.split(separator: " ").map(String.init).filter { $0.count > 2 }
        guard !words.isEmpty else { return false }
        let hit = words.filter { got.contains($0) }.count
        return Double(hit) / Double(words.count) >= 0.6
    }

    static func missing(_ said: String, _ want: String) -> [String] {
        let got = AnswerCheck.fold(said)
        return AnswerCheck.fold(want)
            .split(separator: " ")
            .map(String.init)
            .filter { $0.count > 2 && !got.contains($0) }
    }
}

struct SkillToday: View {
    @EnvironmentObject var store: LearningStore

    private var pick: (name: String, key: String) {
        let j = store.journal
        let rows = [
            ("Mówienie", j.skillSpeakOK, j.skillSpeakBad, "speak"),
            ("Słuchanie", j.skillListenOK, j.skillListenBad, "listen"),
            ("Zdania", j.skillSentenceOK, j.skillSentenceBad, "sentence"),
            ("Słówka", j.skillVocabOK, j.skillVocabBad, "vocab"),
            ("Gramatyka", j.skillGrammarOK, j.skillGrammarBad, "grammar")
        ]
        let used = rows.filter { $0.1 + $0.2 > 0 }
        guard let worst = used.max(by: { left, right in
            Double(left.2) / Double(left.1 + left.2) < Double(right.2) / Double(right.1 + right.2)
        }) else {
            return ("Nowe słówka", "vocab")
        }
        return (worst.0, worst.3)
    }

    var body: some View {
        NavigationLink {
            destination
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dziś według braków").font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                Text(pick.name).font(.headline).foregroundStyle(.white)
                Text("To wychodzi najsłabiej. Ćwiczenie jest z tego, nie z pierwszej lekcji na liście.")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var destination: some View {
        switch pick.key {
        case "speak", "sentence": SpeakCoach()
        case "listen": ClozeListen()
        case "grammar": GrammarView()
        default: WortSession(mode: .fresh, topic: "Wszystko", limit: 15)
        }
    }
}

struct SpeakCoach: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var note = ""
    @State private var missing: [String] = []
    @State private var started = false

    private var card: Vocab? { index < deck.count ? deck[index] : nil }
    private var line: String { card.map { $0.ex.isEmpty ? $0.de : $0.ex } ?? "" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let card {
                    Text("\(index + 1) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                    Text(card.pl).font(.title2.bold())
                    Text("Najpierw posłuchaj, potem powiedz to samo po niemiecku.")
                        .foregroundStyle(Theme.text2)
                    Button { Talk.de(line, rate: 0.46) } label: {
                        Label("Posłuchaj", systemImage: "speaker.wave.2")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.glass)
                    Button { mic.toggle() } label: {
                        Label(mic.listening ? "Stop" : "Mówię", systemImage: "mic.fill")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.glass)
                    if !mic.text.isEmpty { Text(mic.text).foregroundStyle(Theme.text2) }
                    if !note.isEmpty { Text(note).font(.headline) }
                    if revealed || !missing.isEmpty {
                        Text(line).font(.title3.weight(.semibold)).foregroundStyle(Theme.ok)
                        if !card.plural.isEmpty, card.plural != "—" {
                            Text("Liczba mnoga: \(card.plural)").font(.subheadline).foregroundStyle(Theme.text2)
                        }
                    }
                    if !missing.isEmpty {
                        Text("Brakuje: \(missing.joined(separator: ", "))")
                            .foregroundStyle(Theme.bad)
                    }
                    HStack {
                        Button("Pokaż") { revealed = true }.ghostButton()
                        Button("Jeszcze raz") { retry() }.ghostButton()
                    }
                    if !note.isEmpty {
                        Button(index + 1 >= deck.count ? "Koniec" : "Dalej") { advance(card) }
                            .primaryButton()
                    }
                } else if started {
                    LessonDone(title: "Koniec mówienia", line: "Zdania, które wypadły, wrócą w trudnych.")
                } else {
                    Text("Ładuję…")
                }
            }
            .padding(20)
        }
        .navigationTitle("Mówienie")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear {
            mic.arm("de-DE")
            guard deck.isEmpty else { return }
            let pack = VocabBook.today(store, limit: 8, topic: "Wszystko")
            deck = pack.isEmpty ? Array(VocabBook.extra.prefix(8)) : pack
            started = true
            if let first = deck.first { Talk.de(first.ex.isEmpty ? first.de : first.ex, rate: 0.46) }
        }
        .onChange(of: mic.listening) { was, now in
            if was && !now { judge() }
        }
        .onDisappear { mic.stop(); Talk.stop() }
    }

    private func judge() {
        let said = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !said.isEmpty, card != nil else { return }
        let good = SpokenMatch.ok(said, line)
        missing = SpokenMatch.missing(said, line)
        revealed = true
        note = good ? "Dobrze. Możesz iść dalej." : "Jeszcze nie. Powiedz jeszcze raz albo idź dalej."
        store.noteSkill("speak", ok: good)
        if good { Haptic.good() } else { Haptic.bad() }
    }

    private func retry() {
        note = ""
        missing = []
        mic.text = ""
        revealed = false
        Talk.de(line, rate: 0.46)
    }

    private func advance(_ card: Vocab) {
        let word = Word(de: card.de, pl: card.pl, ex: line, exPl: card.exPl, topic: card.topic)
        let good = note.hasPrefix("Dobrze")
        store.grade(word, good ? .easy : .hard, produced: true)
        if good { VocabBook.remember(card) }
        index += 1
        note = ""
        missing = []
        mic.text = ""
        revealed = false
        if index < deck.count { Talk.de(line, rate: 0.46) }
    }
}

struct ClozeListen: View {
    @EnvironmentObject var store: LearningStore
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var hole = ""
    @State private var shown = ""
    @State private var choices: [String] = []
    @State private var picked: String?
    @State private var started = false

    private var card: Vocab? { index < deck.count ? deck[index] : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let card {
                    Text("\(index + 1) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                    Text("Najpierw samo ucho. Potem uzupełnij lukę.")
                        .foregroundStyle(Theme.text2)
                    Button {
                        Talk.de(card.ex.isEmpty ? card.de : card.ex, rate: 0.42)
                    } label: {
                        Label(picked == nil ? "Posłuchaj bez tekstu" : "Odtwórz jeszcze raz", systemImage: "speaker.wave.2")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.glass)
                    Text(shown).font(.title3.bold())
                    ForEach(choices, id: \.self) { choice in
                        Button(choice) { choose(card, choice) }
                            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.white)
                            .background(fill(choice), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .disabled(picked != nil)
                    }
                    if picked != nil {
                        Text(card.exPl).foregroundStyle(Theme.text2)
                        Button(index + 1 >= deck.count ? "Koniec" : "Dalej") { next() }.primaryButton()
                    }
                } else if started {
                    LessonDone(title: "Koniec luk", line: "To, co wypadło, wraca w trudnych słówkach.")
                } else {
                    Text("Ładuję…")
                }
            }
            .padding(20)
        }
        .navigationTitle("Luki ze słuchu")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear(perform: load)
        .onDisappear { Talk.stop() }
    }

    private func fill(_ choice: String) -> Color {
        guard picked != nil else { return Color.white.opacity(0.08) }
        if choice == hole { return Theme.ok.opacity(0.85) }
        if choice == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }

    private func load() {
        guard deck.isEmpty else { return }
        let pack = VocabBook.today(store, limit: 8, topic: "Wszystko")
        deck = pack.isEmpty ? Array(VocabBook.extra.prefix(8)) : pack
        started = true
        prepare()
    }

    private func prepare() {
        picked = nil
        guard let card else { return }
        let sentence = card.ex.isEmpty ? card.de : card.ex
        let skip: Set<String> = ["der", "die", "das", "ein", "eine", "ich", "und", "ist", "sind", "nicht"]
        let parts = sentence.split(separator: " ").map(String.init)
        let target = parts.first { word in
            let bare = word.trimmingCharacters(in: .punctuationCharacters)
            return bare.count > 3 && !skip.contains(bare.lowercased())
        }.map { $0.trimmingCharacters(in: .punctuationCharacters) } ?? card.de
        hole = target
        shown = sentence.replacingOccurrences(of: target, with: "______")
        let others = VocabBook.extra.map(\.de).filter { AnswerCheck.fold($0) != AnswerCheck.fold(target) }.shuffled().prefix(2)
        choices = ([target] + others).shuffled()
        Talk.de(sentence, rate: 0.42)
    }

    private func choose(_ card: Vocab, _ choice: String) {
        guard picked == nil else { return }
        picked = choice
        let good = AnswerCheck.fold(choice) == AnswerCheck.fold(hole)
        store.noteSkill("listen", ok: good)
        let word = Word(de: card.de, pl: card.pl, ex: card.ex, exPl: card.exPl, topic: card.topic)
        store.grade(word, good ? .easy : .hard)
        if good { Haptic.good() } else { Haptic.bad() }
    }

    private func next() {
        index += 1
        prepare()
    }
}

struct WeakDrill: View {
    @EnvironmentObject var store: LearningStore
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var choices: [String] = []
    @State private var picked: String?
    @State private var loaded = false

    private var card: Vocab? { index < deck.count ? deck[index] : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let card {
                    Text("\(index + 1) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                    Text("To słowo wraca, bo wypadło albo termin minął.").foregroundStyle(Theme.text2)
                    Text(card.de).font(.system(size: 32, weight: .bold)).foregroundStyle(Theme.ok)
                    if !card.plural.isEmpty, card.plural != "—" {
                        Text("Liczba mnoga: \(card.plural)").foregroundStyle(Theme.text2)
                    }
                    Button { Talk.de(card.de) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                        .buttonStyle(.glass)
                    ForEach(choices, id: \.self) { choice in
                        Button(choice) { mark(card, choice) }
                            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.white)
                            .background(fill(choice, card), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .disabled(picked != nil)
                    }
                    if picked != nil {
                        Text(card.ex).foregroundStyle(Theme.text2)
                        Button(index + 1 >= deck.count ? "Koniec" : "Dalej") { index += 1; picked = nil; prepare() }
                            .primaryButton()
                    }
                } else if loaded {
                    LessonDone(title: "Brak trudnych", line: deck.isEmpty && index == 0 ? "Jak coś wypadnie w słówkach albo w mówieniu, wróci tutaj." : "Te karty mają nowy termin.")
                }
            }
            .padding(20)
        }
        .navigationTitle("Trudne")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear(perform: load)
        .onDisappear { Talk.stop() }
    }

    private func fill(_ choice: String, _ card: Vocab) -> Color {
        guard picked != nil else { return Color.white.opacity(0.08) }
        if choice == card.pl { return Theme.ok.opacity(0.85) }
        if choice == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }

    private func load() {
        guard !loaded else { return }
        loaded = true
        let now = Date()
        deck = VocabBook.all(store).filter { card in
            let s = VocabBook.stat(store, card)
            let seen = s.correct + s.wrong + s.reps > 0
            if !seen { return false }
            return s.wrong > s.correct || s.due <= now
        }
        prepare()
    }

    private func prepare() {
        guard let card else { return }
        let wrong = VocabBook.all(store).filter { $0.pl != card.pl }.shuffled().prefix(2).map(\.pl)
        choices = ([card.pl] + wrong).shuffled()
    }

    private func mark(_ card: Vocab, _ choice: String) {
        guard picked == nil else { return }
        picked = choice
        let good = choice == card.pl
        let word = Word(de: card.de, pl: card.pl, ex: card.ex, exPl: card.exPl, topic: card.topic)
        store.grade(word, good ? .easy : .hard)
        store.noteSkill("vocab", ok: good)
        if good { Haptic.good() } else { Haptic.bad() }
    }
}
