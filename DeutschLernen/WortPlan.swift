import SwiftUI

struct WortPlan: View {
    @AppStorage("wortDaily") private var daily = 15
    @AppStorage("wortTopic") private var topic = "Wszystko"
    @AppStorage("wortBand") private var band = "Wszystkie"
    @AppStorage("wortStudy") private var study = "smart"

    private let topics: [(String, String)] = [
        ("Wszystko", "Wszystko"),
        ("Codzienne życie", "Codzienne życie"),
        ("Budowa", "Budowa"),
        ("Narzędzia", "Narzędzia"),
        ("Materiały", "Materiały"),
        ("Praca", "Praca"),
        ("Sklep", "Sklep i zakupy"),
        ("Mieszkanie", "Mieszkanie"),
        ("Lekarz", "Lekarz i zdrowie"),
        ("Transport", "Transport"),
        ("Urząd", "Urząd"),
        ("Jedzenie", "Jedzenie"),
        ("Czasowniki", "Czasowniki"),
        ("Przymiotniki", "Przymiotniki"),
        ("Zwroty", "Zwroty potoczne")
    ]
    private let bands = ["Wszystkie", "A1", "A2", "B1", "B2"]
    private let modes: [(String, String, String)] = [
        ("smart", "Inteligentna nauka", "Nowe słowa, powtórki i trudne słówka dobrane automatycznie."),
        ("review", "Tylko powtórki", "Słowa, których termin powtórzenia już nadszedł."),
        ("new", "Nowe słówka", "Jeszcze niepoznane słownictwo z wybranego tematu."),
        ("hard", "Trudne słówka", "Te, które wypadają częściej niż wychodzą.")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Co dziś chcesz ćwiczyć?").font(.title2.bold())
                Text("Wybór zostaje zapamiętany. Następnym razem nie musisz ustawiać tego od nowa.")
                    .foregroundStyle(Theme.text2)
                Text("Wybierz temat").font(.headline)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(topics, id: \.0) { id, title in
                        chip(title, on: topic == id) { topic = id }
                    }
                }
                Text("Wybierz poziom").font(.headline)
                HStack(spacing: 8) {
                    ForEach(bands, id: \.self) { item in
                        chip(item, on: band == item) { band = item }
                    }
                }
                Text("Co chcesz ćwiczyć?").font(.headline)
                ForEach(modes, id: \.0) { id, title, line in
                    Button { study = id } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title).font(.headline).foregroundStyle(.white)
                            Text(line).font(.subheadline).foregroundStyle(Theme.text2)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(study == id ? Theme.ok.opacity(0.16) : Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(study == id ? Theme.ok : Color.white.opacity(0.08), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                NavigationLink {
                    WortRun(topic: topic, band: band, mode: study, limit: daily)
                } label: {
                    Text("Rozpocznij").primaryButton()
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .navigationTitle("Nauka słówek")
        .containerBackground(for: .navigation) { Color.black }
    }

    private func chip(_ title: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(on ? Theme.ok : .white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(on ? Theme.ok.opacity(0.18) : Color.clear, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(on ? Theme.ok : Color.white.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct WortRun: View {
    @EnvironmentObject var store: LearningStore
    let topic: String
    let band: String
    let mode: String
    let limit: Int
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var choices: [String] = []
    @State private var picked: String?
    @State private var typed = ""
    @State private var hole = ""
    @State private var prompt = ""
    @State private var fresh = 0
    @State private var good = 0
    @State private var bad: [String] = []
    @State private var tomorrow: [String] = []
    @State private var loaded = false

    private var card: Vocab? { index < deck.count ? deck[index] : nil }
    private var kind: Int { index % 6 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let card {
                    Text("\(index + 1) z \(deck.count) · \(kindName)").font(.footnote).foregroundStyle(Theme.text2)
                    head(card)
                    if kind == 2 { typeBox(card) } else { options(card) }
                    if let picked {
                        Text(picked == expected(card) ? "Dobrze." : "Poprawnie: \(expected(card))")
                            .font(.headline)
                        if !card.plural.isEmpty, card.plural != "—" {
                            Text("Liczba mnoga: \(card.plural)").foregroundStyle(Theme.text2)
                        }
                        if !card.note.isEmpty, !["A1", "A2", "B1", "B2"].contains(card.note) {
                            Text(card.note).font(.subheadline).foregroundStyle(Theme.text2)
                        }
                        Button(index + 1 >= deck.count ? "Podsumowanie" : "Dalej") { advance(card, ok: picked == expected(card)) }
                            .primaryButton()
                    }
                } else if loaded {
                    summary
                } else {
                    Text("Dobieram słowa…")
                }
            }
            .padding(20)
        }
        .navigationTitle(modeTitle)
        .containerBackground(for: .navigation) { Color.black }
        .onAppear(perform: load)
        .onDisappear { Talk.stop() }
    }

    private var modeTitle: String {
        switch mode {
        case "review": return "Powtórki"
        case "new": return "Nowe słówka"
        case "hard": return "Trudne"
        default: return "Inteligentna nauka"
        }
    }

    private var kindName: String {
        switch kind {
        case 1: return "polski → niemiecki"
        case 2: return "z pamięci"
        case 3: return "ze słuchu"
        case 4: return "luka w zdaniu"
        case 5: return "zdanie"
        default: return "niemiecki → polski"
        }
    }

    @ViewBuilder private func head(_ card: Vocab) -> some View {
        switch kind {
        case 1:
            Text(card.pl).font(.system(size: 32, weight: .bold))
            Text("Wybierz po niemiecku, z rodzajnikiem.").foregroundStyle(Theme.text2)
        case 2:
            Text(card.pl).font(.title.bold())
            Text("Wpisz po niemiecku.").foregroundStyle(Theme.text2)
        case 3:
            Button { Talk.de(card.de) } label: {
                Label("Posłuchaj i wybierz znaczenie", systemImage: "speaker.wave.2")
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.glass)
        case 4:
            Text(prompt).font(.title3.bold())
            Button { Talk.de(card.ex.isEmpty ? card.de : card.ex) } label: { Label("Posłuchaj zdania", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
        case 5:
            Text(card.exPl.isEmpty ? card.pl : card.exPl).font(.title3.bold())
            Text("Które zdanie pasuje?").foregroundStyle(Theme.text2)
        default:
            Text(card.de).font(.system(size: 34, weight: .bold)).foregroundStyle(Theme.ok)
            if !card.ex.isEmpty { Text(card.ex).foregroundStyle(Theme.text2) }
            if !card.plural.isEmpty, card.plural != "—" {
                Text("Liczba mnoga: \(card.plural)").foregroundStyle(Theme.text2)
            }
            Button { Talk.de(card.de) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
        }
    }

    private func options(_ card: Vocab) -> some View {
        VStack(spacing: 8) {
            ForEach(choices, id: \.self) { choice in
                Button(choice) {
                    guard picked == nil else { return }
                    picked = choice
                    if choice != expected(card) { Haptic.bad() } else { Haptic.good() }
                }
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .padding(.horizontal, 12)
                .foregroundStyle(.white)
                .background(fill(choice, card), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .disabled(picked != nil)
            }
        }
    }

    private func typeBox(_ card: Vocab) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Po niemiecku", text: $typed)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button("Sprawdź") {
                let verdict = AnswerCheck.judge(typed, card.de)
                picked = verdict == .wrong ? typed : card.de
                if verdict == .wrong { Haptic.bad() } else { Haptic.good() }
            }
            .primaryButton()
            .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty || picked != nil)
        }
    }

    private func fill(_ choice: String, _ card: Vocab) -> Color {
        guard picked != nil else { return Color.white.opacity(0.08) }
        if choice == expected(card) { return Theme.ok.opacity(0.85) }
        if choice == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }

    private func expected(_ card: Vocab) -> String {
        switch kind {
        case 1, 2: return card.de
        case 4: return hole
        case 5: return card.ex.isEmpty ? card.de : card.ex
        default: return card.pl
        }
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 10) {
            LessonDone(title: "Koniec sesji", line: "Postęp i terminy są zapisane. Zamknięcie aplikacji ich nie kasuje.")
            Text("Nowe w tej sesji: \(fresh)").font(.headline)
            Text("Dobrze: \(good)")
            Text("Trudne: \(bad.count)")
            if bad.isEmpty {
                Text("Nic nie wypadło.").foregroundStyle(Theme.text2)
            } else {
                Text("Warto powtórzyć: \(bad.joined(separator: ", "))").foregroundStyle(Theme.text2)
            }
            if tomorrow.isEmpty {
                Text("Jutro nic z tej sesji nie wraca od razu.").foregroundStyle(Theme.text2)
            } else {
                Text("Wróci jutro albo wcześniej: \(tomorrow.joined(separator: ", "))").foregroundStyle(Theme.text2)
            }
            Text("Ten krok planu zalicza się dopiero, gdy ta sesja jest skończona.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
        }
    }

    private var saveKey: String { "wort-run-\(mode)-\(topic)-\(band)-\(LearningStore.dayKey())" }
    private var planKind: String {
        if mode == "hard" { return "weak" }
        if mode == "new" { return "fresh" }
        return ""
    }

    private struct RunSave: Codable {
        var ids: [String]
        var index: Int
        var good: Int
        var bad: [String]
        var tomorrow: [String]
        var fresh: Int
    }

    private func load() {
        guard !loaded else { return }
        loaded = true
        if restore() { return }
        deck = VocabBook.today(store, limit: limit, topic: topic, band: band, mode: mode)
        fresh = deck.filter { VocabBook.stat(store, $0).correct + VocabBook.stat(store, $0).wrong + VocabBook.stat(store, $0).reps == 0 }.count
        persist()
        prepare()
    }

    private func restore() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode(RunSave.self, from: data),
              !saved.ids.isEmpty else { return false }
        var map: [String: Vocab] = [:]
        for card in VocabBook.all(store) { map[card.de] = card }
        let cards = saved.ids.compactMap { map[$0] }
        guard !cards.isEmpty else { return false }
        if saved.index >= cards.count {
            UserDefaults.standard.removeObject(forKey: saveKey)
            return false
        }
        deck = cards
        good = saved.good
        bad = saved.bad
        tomorrow = saved.tomorrow
        fresh = saved.fresh
        index = saved.index
        prepare()
        return true
    }

    private func persist() {
        let saved = RunSave(ids: deck.map(\.de), index: index, good: good, bad: bad, tomorrow: tomorrow, fresh: fresh)
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func prepare() {
        picked = nil
        typed = ""
        guard let card else { return }
        let pool = VocabBook.core(store, topic: "Wszystko")
        switch kind {
        case 1:
            let wrong = pool.filter { $0.de != card.de }.shuffled().prefix(2).map(\.de)
            choices = ([card.de] + wrong).shuffled()
        case 4:
            let sentence = card.ex.isEmpty ? card.de : card.ex
            let skip: Set<String> = ["der", "die", "das", "ein", "eine", "ich", "und", "ist"]
            let word = sentence.split(separator: " ").map(String.init).first {
                let bare = $0.trimmingCharacters(in: .punctuationCharacters)
                return bare.count > 3 && !skip.contains(bare.lowercased())
            }?.trimmingCharacters(in: .punctuationCharacters) ?? card.de
            hole = word
            prompt = sentence.replacingOccurrences(of: word, with: "______")
            let others = pool.map(\.de).filter { $0 != word }.shuffled().prefix(2)
            choices = ([word] + others).shuffled()
        case 5:
            let right = card.ex.isEmpty ? card.de : card.ex
            let wrong = pool.filter { $0.de != card.de }.shuffled().prefix(2).map { $0.ex.isEmpty ? $0.de : $0.ex }
            choices = ([right] + wrong).shuffled()
        default:
            let wrong = pool.filter { $0.pl != card.pl }.shuffled().prefix(2).map(\.pl)
            choices = ([card.pl] + wrong).shuffled()
        }
        if kind == 3 { Talk.de(card.de) }
    }

    private func advance(_ card: Vocab, ok: Bool) {
        let line = card.ex.isEmpty ? card.de : card.ex
        let word = Word(de: card.de, pl: card.pl, ex: line, exPl: card.exPl, topic: card.topic)
        store.grade(word, ok ? .easy : .hard)
        store.noteSkill("vocab", ok: ok)
        VocabBook.didStudy(card.de, ok: ok)
        if ok {
            good += 1
            VocabBook.remember(card)
        } else {
            if !bad.contains(card.de) { bad.append(card.de) }
            let spot = min(deck.count, index + 3)
            if !deck.dropFirst(index + 1).prefix(3).contains(where: { $0.de == card.de }) {
                deck.insert(card, at: spot)
            }
        }
        if let due = store.stats[card.de]?.due, due.timeIntervalSinceNow < 36 * 3600, !tomorrow.contains(card.de) {
            tomorrow.append(card.de)
        }
        index += 1
        persist()
        if index >= deck.count, !deck.isEmpty, !planKind.isEmpty {
            DayPlan.complete(kind: planKind)
        }
        prepare()
    }
}
