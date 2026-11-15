import SwiftUI

struct Vocab: Identifiable, Codable, Hashable {
    var id: String { de }
    let de: String
    let pl: String
    let plural: String
    let ex: String
    let exPl: String
    let topic: String
    let kind: String
    let note: String
}

@MainActor
enum VocabBook {
    static let built: [Vocab] = [
        v("die Baustelle", "plac budowy", "die Baustellen", "Ich arbeite auf der Baustelle.", "Pracuję na budowie.", "Budowa", "Rzeczownik – rodzaj żeński", "auf der Baustelle arbeiten"),
        v("das Gerüst", "rusztowanie", "die Gerüste", "Das Gerüst wackelt.", "Rusztowanie się kiwa.", "Budowa", "Rzeczownik – rodzaj nijaki", "aufs Gerüst gehen"),
        v("die Grube", "wykop", "die Gruben", "Die Grube ist noch offen.", "Wykop jest jeszcze otwarty.", "Budowa", "Rzeczownik – rodzaj żeński", "in die Grube gehen"),
        v("der Beton", "beton", "bez liczby mnogiej", "Der Beton ist schon da.", "Beton już jest.", "Materiały", "Rzeczownik – rodzaj męski", "Beton gießen"),
        v("der Zement", "cement", "bez liczby mnogiej", "Wir brauchen noch Zement.", "Potrzebujemy jeszcze cementu.", "Materiały", "Rzeczownik – rodzaj męski", "Zement anmachen"),
        v("der Sand", "piasek", "bez liczby mnogiej", "Der Sand ist nass.", "Piasek jest mokry.", "Materiały", "Rzeczownik – rodzaj męski", ""),
        v("die Schraube", "śruba", "die Schrauben", "Die Schraube ist zu kurz.", "Śruba jest za krótka.", "Materiały", "Rzeczownik – rodzaj żeński", "eine Schraube anziehen"),
        v("der Nagel", "gwóźdź", "die Nägel", "Der Nagel ist krumm.", "Gwóźdź jest krzywy.", "Materiały", "Rzeczownik – rodzaj męski", "einen Nagel einschlagen"),
        v("der Dübel", "kołek", "die Dübel", "Der Dübel hält nicht.", "Kołek nie trzyma.", "Materiały", "Rzeczownik – rodzaj męski", "einen Dübel setzen"),
        v("der Hammer", "młotek", "die Hämmer", "Hol den Hammer.", "Przynieś młotek.", "Narzędzia", "Rzeczownik – rodzaj męski", "mit dem Hammer schlagen"),
        v("die Schaufel", "łopata", "die Schaufeln", "Hol die Schaufel.", "Przynieś łopatę.", "Narzędzia", "Rzeczownik – rodzaj żeński", ""),
        v("die Leiter", "drabina", "die Leitern", "Die Leiter steht hinten.", "Drabina stoi z tyłu.", "Narzędzia", "Rzeczownik – rodzaj żeński", "auf die Leiter steigen"),
        v("der Akkuschrauber", "wkrętarka", "die Akkuschrauber", "Der Akku ist leer.", "Akumulator jest pusty.", "Narzędzia", "Rzeczownik – rodzaj męski", "den Akkuschrauber laden"),
        v("die Wasserwaage", "poziomica", "die Wasserwaagen", "Prüf die Wasserwaage.", "Sprawdź poziomicę.", "Narzędzia", "Rzeczownik – rodzaj żeński", ""),
        v("der Helm", "kask", "die Helme", "Ohne Helm geht hier nichts.", "Bez kasku tutaj nic.", "Praca", "Rzeczownik – rodzaj męski", "den Helm aufsetzen"),
        v("der Chef", "szef", "die Chefs", "Der Chef ist im Büro.", "Szef jest w biurze.", "Praca", "Rzeczownik – rodzaj męski", "dem Chef Bescheid sagen"),
        v("der Kollege", "kolega", "die Kollegen", "Mein Kollege hilft mir.", "Kolega mi pomaga.", "Praca", "Rzeczownik – rodzaj męski", ""),
        v("die Schicht", "zmiana", "die Schichten", "Die Schicht beginnt um sechs.", "Zmiana zaczyna się o szóstej.", "Praca", "Rzeczownik – rodzaj żeński", "Schicht haben"),
        v("der Lohn", "wypłata", "die Löhne", "Wann kommt der Lohn?", "Kiedy będzie wypłata?", "Praca", "Rzeczownik – rodzaj męski", ""),
        v("die Pause", "przerwa", "die Pausen", "Die Pause ist um neun.", "Przerwa jest o dziewiątej.", "Praca", "Rzeczownik – rodzaj żeński", "Pause machen"),
        v("der Bus", "autobus", "die Busse", "Der Bus hat Verspätung.", "Autobus ma opóźnienie.", "Transport", "Rzeczownik – rodzaj męski", "den Bus verpassen"),
        v("der Zug", "pociąg", "die Züge", "Der Zug fällt aus.", "Pociąg jest odwołany.", "Transport", "Rzeczownik – rodzaj męski", "den Zug nehmen"),
        v("die Haltestelle", "przystanek", "die Haltestellen", "Die Haltestelle ist da vorne.", "Przystanek jest tam z przodu.", "Transport", "Rzeczownik – rodzaj żeński", ""),
        v("das Brot", "chleb", "die Brote", "Ich nehme das Brot.", "Biorę chleb.", "Jedzenie", "Rzeczownik – rodzaj nijaki", "Brot kaufen"),
        v("das Wasser", "woda", "bez liczby mnogiej", "Ich brauche Wasser.", "Potrzebuję wody.", "Jedzenie", "Rzeczownik – rodzaj nijaki", ""),
        v("der Apfel", "jabłko", "die Äpfel", "Der Apfel ist süß.", "Jabłko jest słodkie.", "Jedzenie", "Rzeczownik – rodzaj męski", ""),
        v("der Bon", "paragon", "die Bons", "Ich habe den Bon.", "Mam paragon.", "Sklep", "Rzeczownik – rodzaj męski", "den Bon mitnehmen"),
        v("die Karte", "karta", "die Karten", "Kann ich mit Karte zahlen?", "Czy mogę zapłacić kartą?", "Sklep", "Rzeczownik – rodzaj żeński", "mit Karte zahlen"),
        v("die Rechnung", "rachunek", "die Rechnungen", "Die Rechnung stimmt nicht.", "Rachunek się nie zgadza.", "Sklep", "Rzeczownik – rodzaj żeński", "die Rechnung prüfen"),
        v("der Arzt", "lekarz", "die Ärzte", "Ich muss zum Arzt.", "Muszę iść do lekarza.", "Lekarz", "Rzeczownik – rodzaj męski", "zum Arzt gehen"),
        v("die Krankschreibung", "zwolnienie", "die Krankschreibungen", "Ich brauche eine Krankschreibung.", "Potrzebuję zwolnienia.", "Lekarz", "Rzeczownik – rodzaj żeński", ""),
        v("das Rezept", "recepta", "die Rezepte", "Hier ist das Rezept.", "Tu jest recepta.", "Lekarz", "Rzeczownik – rodzaj nijaki", "ein Rezept holen"),
        v("die Apotheke", "apteka", "die Apotheken", "Die Apotheke ist um die Ecke.", "Apteka jest za rogiem.", "Lekarz", "Rzeczownik – rodzaj żeński", ""),
        v("der Ausweis", "dowód", "die Ausweise", "Haben Sie den Ausweis dabei?", "Ma pan przy sobie dowód?", "Urząd", "Rzeczownik – rodzaj męski", "den Ausweis zeigen"),
        v("das Formular", "formularz", "die Formulare", "Füllen Sie das Formular aus.", "Proszę wypełnić formularz.", "Urząd", "Rzeczownik – rodzaj nijaki", "ein Formular ausfüllen"),
        v("der Termin", "termin", "die Termine", "Ich brauche einen Termin.", "Potrzebuję terminu.", "Urząd", "Rzeczownik – rodzaj męski", "einen Termin machen"),
        v("die Wohnung", "mieszkanie", "die Wohnungen", "Die Wohnung ist kalt.", "Mieszkanie jest zimne.", "Mieszkanie", "Rzeczownik – rodzaj żeński", ""),
        v("der Schlüssel", "klucz", "die Schlüssel", "Ich habe den Schlüssel verloren.", "Zgubiłem klucz.", "Mieszkanie", "Rzeczownik – rodzaj męski", "den Schlüssel suchen"),
        v("die Heizung", "ogrzewanie", "die Heizungen", "Die Heizung geht nicht.", "Ogrzewanie nie działa.", "Mieszkanie", "Rzeczownik – rodzaj żeński", "die Heizung aufdrehen"),
        v("die Tür", "drzwi", "die Türen", "Die Tür klemmt.", "Drzwi się zacinają.", "Mieszkanie", "Rzeczownik – rodzaj żeński", "die Tür zumachen"),
        v("der Nachbar", "sąsiad", "die Nachbarn", "Der Nachbar ist zu laut.", "Sąsiad jest za głośny.", "Codzienne życie", "Rzeczownik – rodzaj męski", ""),
        v("machen", "robić", "machte, gemacht", "Was muss ich machen?", "Co mam zrobić?", "Czasowniki", "Czasownik", "Pause machen, Feierabend machen"),
        v("brauchen", "potrzebować", "brauchte, gebraucht", "Ich brauche eine Leiter.", "Potrzebuję drabiny.", "Czasowniki", "Czasownik", "Hilfe brauchen, Zeit brauchen"),
        v("kommen", "przyjść", "kam, gekommen", "Ich komme um neun.", "Przyjdę o dziewiątej.", "Czasowniki", "Czasownik", "zu spät kommen"),
        v("sagen", "powiedzieć", "sagte, gesagt", "Sag dem Chef Bescheid.", "Powiedz szefowi.", "Czasowniki", "Czasownik", "Bescheid sagen"),
        v("gehen", "iść", "ging, gegangen", "Ich muss zum Arzt gehen.", "Muszę iść do lekarza.", "Czasowniki", "Czasownik", "nach Hause gehen"),
        v("verstehen", "rozumieć", "verstand, verstanden", "Ich habe das nicht verstanden.", "Nie zrozumiałem tego.", "Czasowniki", "Czasownik", "kein Wort verstehen"),
        v("helfen", "pomagać", "half, geholfen", "Kannst du mir kurz helfen?", "Możesz mi na chwilę pomóc?", "Czasowniki", "Czasownik", "beim Tragen helfen"),
        v("schnell", "szybki", "schneller, am schnellsten", "Er spricht zu schnell.", "Mówi za szybko.", "Przymiotniki", "Przymiotnik", "zu schnell sprechen"),
        v("fertig", "gotowy", "—", "Ich bin gleich fertig.", "Zaraz skończę.", "Przymiotniki", "Przymiotnik", "fertig sein"),
        v("kaputt", "zepsuty", "—", "Der Aufzug ist kaputt.", "Winda jest zepsuta.", "Przymiotniki", "Przymiotnik", "kaputt gehen"),
        v("nass", "mokry", "nasser", "Der Boden ist nass.", "Podłoga jest mokra.", "Przymiotniki", "Przymiotnik", ""),
        v("Was muss ich machen?", "Co mam zrobić?", "—", "Was muss ich jetzt machen?", "Co mam teraz zrobić?", "Zwroty", "Zwrot", "całe pytanie, nie samo machen"),
        v("Ich habe das nicht verstanden.", "Nie zrozumiałem tego.", "—", "Ich habe das nicht verstanden. Können Sie das wiederholen?", "Nie zrozumiałem. Czy może pan powtórzyć?", "Zwroty", "Zwrot", "prośba o powtórzenie"),
        v("Können Sie langsamer sprechen?", "Czy może pan mówić wolniej?", "—", "Können Sie bitte langsamer sprechen?", "Czy może pan mówić wolniej?", "Zwroty", "Zwrot", "gdy ktoś mówi za szybko")
    ]

    static func v(_ de: String, _ pl: String, _ plural: String, _ ex: String, _ exPl: String, _ topic: String, _ kind: String, _ note: String) -> Vocab {
        Vocab(de: de, pl: pl, plural: plural, ex: ex, exPl: exPl, topic: topic, kind: kind, note: note)
    }

    static var custom: [Vocab] {
        guard let data = UserDefaults.standard.data(forKey: "myVocab"),
              let list = try? JSONDecoder().decode([Vocab].self, from: data) else { return [] }
        return list
    }

    static func saveCustom(_ list: [Vocab]) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: "myVocab")
        }
    }

    static func all(_ store: LearningStore) -> [Vocab] {
        var seen = Set<String>()
        var list: [Vocab] = []
        for card in built + custom {
            let key = card.de.lowercased()
            if seen.insert(key).inserted { list.append(card) }
        }
        for word in store.words where seen.insert(word.de.lowercased()).inserted {
            list.append(from(word))
        }
        return list
    }

    static func from(_ word: Word) -> Vocab {
        let low = word.de.lowercased()
        let kind: String
        if low.hasPrefix("die ") { kind = "Rzeczownik – rodzaj żeński" }
        else if low.hasPrefix("der ") { kind = "Rzeczownik – rodzaj męski" }
        else if low.hasPrefix("das ") { kind = "Rzeczownik – rodzaj nijaki" }
        else { kind = word.topic }
        return Vocab(de: word.de, pl: word.pl, plural: "", ex: word.ex, exPl: word.exPl, topic: mapTopic(word.topic), kind: kind, note: "")
    }

    static func mapTopic(_ topic: String) -> String {
        switch topic {
        case "Zakupy": return "Sklep"
        case "Zdrowie": return "Lekarz"
        case "Urzędy": return "Urząd"
        case "Na co dzień", "Komunikacja": return "Codzienne życie"
        case "Dojazd": return "Transport"
        case "Magazyn": return "Praca"
        default: return topic
        }
    }

    static let topics = ["Budowa", "Narzędzia", "Materiały", "Praca", "Codzienne życie", "Sklep", "Lekarz", "Urząd", "Mieszkanie", "Jedzenie", "Transport", "Czasowniki", "Przymiotniki", "Zwroty", "Moje"]

    static func today(_ store: LearningStore, limit: Int, topic: String) -> [Vocab] {
        let key = "wortToday-\(LearningStore.dayKey())-\(topic)-\(limit)"
        let core = core(store, topic: topic)
        if let saved = UserDefaults.standard.stringArray(forKey: key) {
            let map = Dictionary(uniqueKeysWithValues: all(store).map { ($0.de, $0) })
            let kept = saved.compactMap { map[$0] }
            if !kept.isEmpty { return kept }
        }
        let unseen = core.filter { stat(store, $0).correct + stat(store, $0).wrong == 0 }
        let source = (unseen.isEmpty ? core : unseen).shuffled()
        let pick = Array(source.prefix(limit))
        UserDefaults.standard.set(pick.map(\.de), forKey: key)
        return pick
    }

    static func core(_ store: LearningStore, topic: String) -> [Vocab] {
        let mine = topic == "Moje" ? custom : built.filter { topic == "Wszystko" || topic.isEmpty || $0.topic == topic }
        if topic == "Moje" { return custom }
        return mine
    }

    static func due(_ store: LearningStore) -> [Vocab] {
        let now = Date()
        return all(store).filter { card in
            let s = stat(store, card)
            return s.correct + s.wrong > 0 && s.due <= now
        }
    }

    static func stat(_ store: LearningStore, _ card: Vocab) -> WordStat {
        store.stats[card.de] ?? WordStat()
    }

    static func remember(_ card: Vocab) {
        var list = UserDefaults.standard.stringArray(forKey: "freshVocab") ?? []
        list.removeAll { $0 == card.de }
        list.insert(card.de, at: 0)
        UserDefaults.standard.set(Array(list.prefix(8)), forKey: "freshVocab")
        if built.contains(where: { $0.de.lowercased() == card.de.lowercased() }) { return }
        var mine = custom
        if !mine.contains(where: { $0.de.lowercased() == card.de.lowercased() }) {
            mine.insert(card, at: 0)
            saveCustom(Array(mine.prefix(80)))
        }
    }

    static func freshListen() -> [CoachData.ListenQ] {
        let known = Dictionary(uniqueKeysWithValues: (built + custom).map { ($0.de, $0) })
        let ids = UserDefaults.standard.stringArray(forKey: "freshVocab") ?? []
        return ids.compactMap { id -> CoachData.ListenQ? in
            guard let card = known[id] else { return nil }
            let wrong = built.filter { $0.pl != card.pl }.prefix(2).map(\.pl)
            guard wrong.count == 2 else { return nil }
            let options = ([card.pl] + wrong).shuffled()
            return CoachData.ListenQ(de: card.ex.isEmpty ? card.de : card.ex, pl: card.pl, question: "Co znaczy to, co słyszysz?", options: Array(options), answer: options.firstIndex(of: card.pl) ?? 0)
        }
    }

    static func filtered(_ store: LearningStore, topic: String) -> [Vocab] {
        let list = all(store)
        if topic.isEmpty || topic == "Wszystko" { return list }
        if topic == "Moje" { return custom }
        return list.filter { $0.topic == topic }
    }
}

struct WortHome: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("wortDaily") private var daily = 12
    @State private var topic = "Wszystko"

    private var known: Int { VocabBook.all(store).filter { VocabBook.stat(store, $0).correct > 0 }.count }
    private var held: Int { VocabBook.all(store).filter { VocabBook.stat(store, $0).days.count >= 3 }.count }
    private var due: Int { VocabBook.due(store).count }
    private var rate: String {
        let cards = VocabBook.all(store)
        let ok = cards.reduce(0) { $0 + VocabBook.stat(store, $1).correct }
        let bad = cards.reduce(0) { $0 + VocabBook.stat(store, $1).wrong }
        let total = ok + bad
        if total == 0 { return "brak" }
        return "\(ok * 100 / total)%"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Wortschatz").font(.headline)
                    Spacer()
                    Text("Słownictwo")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.ok.opacity(0.2), in: Capsule())
                        .foregroundStyle(Theme.ok)
                }
                Text("Ucz się nowych słów").font(.system(size: 32, weight: .bold))
                Text("Poznawaj, zapamiętuj i wykorzystuj niemieckie słownictwo.")
                    .foregroundStyle(Theme.text2)
                Stepper("Nowe dziś: \(daily)", value: $daily, in: 10...15)
                    .padding(12)
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        topicChip("Wszystko")
                        ForEach(VocabBook.topics, id: \.self, content: topicChip)
                    }
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    tile("Nowe słówka", "Codzienna porcja nauki", "book") { WortSession(mode: .fresh, topic: topic, limit: daily) }
                    tile("Powtórki", "Zapamiętywanie na długo", "brain") { WortSession(mode: .review, topic: topic, limit: daily) }
                    tile("Fiszki", "Niemiecki i polski", "rectangle.on.rectangle") { WortSession(mode: .cards, topic: topic, limit: daily) }
                    tile("Wymowa", "Słuchaj i powtarzaj", "speaker.wave.2") { WortSession(mode: .hear, topic: topic, limit: daily) }
                }
                HStack {
                    tile("Quiz", "Wybierz znaczenie", "checkmark.circle") { WortSession(mode: .quiz, topic: topic, limit: daily) }
                    tile("Z pamięci", "Wpisz po niemiecku", "keyboard") { WortSession(mode: .type, topic: topic, limit: daily) }
                }
                NavigationLink { WortAdd() } label: {
                    Text("Dodaj swoje słówko z pracy")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.glass)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Twoje słowa").font(.headline)
                    HStack {
                        bit("\(known)", "poznane")
                        bit("\(held)", "zapamiętane")
                        bit("\(due)", "do powtórki")
                        bit(rate, "skuteczność")
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                if let sample = VocabBook.built.first {
                    WortCard(card: sample, show: true)
                }
            }
            .padding(16)
            .padding(.bottom, 90)
        }
        .navigationTitle("Słówka")
        .containerBackground(for: .navigation) { Color.black }
    }

    private func topicChip(_ name: String) -> some View {
        Button(name) { topic = name }
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(topic == name ? Theme.ok : Color.white.opacity(0.08), in: Capsule())
            .foregroundStyle(topic == name ? Theme.ink : .white)
    }

    private func tile<Dest: View>(_ title: String, _ text: String, _ icon: String, @ViewBuilder dest: () -> Dest) -> some View {
        NavigationLink { dest() } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).foregroundStyle(Theme.ok)
                Text(title).font(.headline).foregroundStyle(.white)
                Text(text).font(.caption).foregroundStyle(Theme.text2)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func bit(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value).font(.title3.bold())
            Text(label).font(.caption2).foregroundStyle(Theme.text2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WortCard: View {
    let card: Vocab
    let show: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(card.de).font(.system(size: 28, weight: .bold)).foregroundStyle(Theme.ok).multilineTextAlignment(.center)
            if show {
                Text(card.pl).foregroundStyle(Theme.text2)
                Text(card.de).font(.title3.bold())
                if !card.plural.isEmpty { Text("Liczba mnoga: \(card.plural)").font(.subheadline).foregroundStyle(Theme.text2) }
                if !card.note.isEmpty { Text(card.note).font(.subheadline) }
                Text(card.ex).font(.body)
                Text(card.exPl).foregroundStyle(Theme.text2)
                Text(card.kind)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.ok.opacity(0.18), in: Capsule())
                    .foregroundStyle(Theme.ok)
                Button { Talk.de(card.de + ". " + card.ex) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                    .buttonStyle(.glass)
            } else {
                Text("Stuknij, żeby odsłonić").font(.caption).foregroundStyle(Theme.text2)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "13241C"), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

enum WortMode { case fresh, review, cards, hear, quiz, type }

struct WortSession: View {
    @EnvironmentObject var store: LearningStore
    let mode: WortMode
    let topic: String
    let limit: Int
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var show = false
    @State private var picked: Int?
    @State private var typed = ""
    @State private var note = ""
    @State private var flipToPolish = false
    @State private var heard = false
    @State private var choices: [String] = []

    private var card: Vocab? { index < deck.count ? deck[index] : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if deck.isEmpty {
                    Text(mode == .review ? "Nie ma słów do powtórki." : "Brak słów w tej kategorii.")
                        .font(.title2.bold())
                    Text(mode == .review ? "Weź najpierw nowe słówka. Trudne wrócą same." : "Dodaj własne albo wybierz inną kategorię.")
                        .foregroundStyle(Theme.text2)
                } else if let card {
                    Text("\(index + 1) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                    switch mode {
                    case .fresh:
                        WortCard(card: card, show: true)
                        Button("Znam") { mark(card, ok: true) }.primaryButton()
                        Button("Jeszcze nie") { mark(card, ok: false) }.buttonStyle(.glass)
                    case .review, .cards:
                        Button { show.toggle() } label: { WortCard(card: face(card), show: show || mode == .review) }
                            .buttonStyle(.plain)
                        if mode == .cards {
                            Button(flipToPolish ? "Pokazuj najpierw niemiecki" : "Pokazuj najpierw polski") { flipToPolish.toggle(); show = false }
                                .buttonStyle(.glass)
                        }
                        Button("Znam") { mark(card, ok: true) }.primaryButton()
                        Button("Nie pamiętam") { mark(card, ok: false) }.buttonStyle(.glass)
                    case .hear:
                        Button {
                            heard = true
                            Talk.de(card.ex.isEmpty ? card.de : card.ex, rate: 0.42)
                        } label: { Label(heard ? "Odtwórz jeszcze raz" : "Posłuchaj bez tekstu", systemImage: "speaker.wave.2.fill").frame(maxWidth: .infinity, minHeight: 52) }
                            .buttonStyle(MatteGlassButton())
                        if heard { options(card, prompt: "Co słyszysz?") }
                    case .quiz:
                        Text(card.de).font(.title.bold())
                        options(card, prompt: "Co to znaczy?")
                    case .type:
                        Text(card.pl).font(.title2.bold())
                        Text(card.exPl).foregroundStyle(Theme.text2)
                        TextField("Po niemiecku", text: $typed)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button("Sprawdź") { checkType(card) }.primaryButton().disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                        if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                    }
                } else {
                    Text("Koniec serii").font(.largeTitle.bold())
                    Text("Poznane, zapamiętane i powtórki są zapisane.").foregroundStyle(Theme.text2)
                }
            }
            .padding(20)
        }
        .navigationTitle(title)
        .containerBackground(for: .navigation) { Color.black }
        .onAppear(perform: load)
        .onDisappear { Talk.stop() }
    }

    private var title: String {
        switch mode {
        case .fresh: return "Nowe słówka"
        case .review: return "Powtórki"
        case .cards: return "Fiszki"
        case .hear: return "Ze słuchu"
        case .quiz: return "Quiz"
        case .type: return "Z pamięci"
        }
    }

    private func face(_ card: Vocab) -> Vocab {
        guard mode == .cards, flipToPolish else { return card }
        return Vocab(de: card.pl, pl: card.de, plural: card.plural, ex: card.exPl, exPl: card.ex, topic: card.topic, kind: card.kind, note: card.note)
    }

    private func load() {
        if mode == .review {
            deck = VocabBook.due(store)
        } else {
            deck = VocabBook.today(store, limit: limit, topic: topic)
        }
        prepare()
    }

    private func prepare() {
        guard index < deck.count else { choices = []; return }
        let card = deck[index]
        let wrong = VocabBook.all(store).filter { $0.pl != card.pl }.shuffled().prefix(3).map(\.pl)
        choices = ([card.pl] + wrong).shuffled()
    }

    private func options(_ card: Vocab, prompt: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prompt).font(.headline)
            ForEach(choices, id: \.self) { choice in
                Button(choice) {
                    guard picked == nil else { return }
                    picked = 1
                    let ok = choice == card.pl
                    mark(card, ok: ok, advance: false)
                    note = ok ? "Dobrze." : "Poprawnie: \(card.pl). \(card.de)"
                }
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .padding(.horizontal, 12)
                .foregroundStyle(.white)
                .background(choice == card.pl && picked != nil ? Theme.ok.opacity(0.8) : (picked != nil && choice != card.pl ? Color.white.opacity(0.08) : Color.white.opacity(0.08)), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if picked != nil {
                Text(note).foregroundStyle(Theme.text2)
                Text(card.de).font(.headline)
                if !card.plural.isEmpty { Text(card.plural).foregroundStyle(Theme.text2) }
                Button("Dalej") { advance() }.primaryButton()
            }
        }
    }

    private func checkType(_ card: Vocab) {
        let ok = Normalizer.same(typed, card.de) || Normalizer.same(typed, card.ex)
        note = ok ? "Dobrze." : "Tak się pisze: \(card.de). Zdanie: \(card.ex)"
        mark(card, ok: ok, advance: false)
        if ok { advanceSoon() }
    }

    private func advanceSoon() {
        typed = ""
        note = ""
        advance()
    }

    private func mark(_ card: Vocab, ok: Bool, advance go: Bool = true) {
        let word = Word(de: card.de, pl: card.pl, ex: card.ex, exPl: card.exPl, topic: card.topic)
        if ok {
            store.grade(word, .easy)
            VocabBook.remember(card)
            Haptic.good()
        } else {
            store.grade(word, .hard)
            store.pinForReview(word)
            Haptic.bad()
        }
        if go { advance() }
    }

    private func advance() {
        show = false
        picked = nil
        heard = false
        typed = ""
        index += 1
        prepare()
    }
}

struct WortAdd: View {
    @EnvironmentObject var store: LearningStore
    @State private var de = ""
    @State private var pl = ""
    @State private var plural = ""
    @State private var ex = ""
    @State private var exPl = ""
    @State private var topic = "Moje"
    @State private var saved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Słowo, które usłyszałeś w pracy.").foregroundStyle(Theme.text2)
                field("Po niemiecku, z rodzajnikiem", $de)
                field("Po polsku", $pl)
                field("Liczba mnoga", $plural)
                field("Zdanie po niemiecku", $ex)
                field("Zdanie po polsku", $exPl)
                Button("Zapisz do słówek i powtórek") { save() }
                    .primaryButton()
                    .disabled(de.trimmingCharacters(in: .whitespaces).isEmpty || pl.trimmingCharacters(in: .whitespaces).isEmpty)
                if saved { Text("Jest w Twoich słówkach. Wróci w powtórkach.").foregroundStyle(Theme.ok) }
            }
            .padding(20)
        }
        .navigationTitle("Własne słówko")
        .containerBackground(for: .navigation) { Color.black }
    }

    private func field(_ title: String, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(Theme.text2)
            TextField(title, text: text).textFieldStyle(.roundedBorder)
        }
    }

    private func save() {
        let card = Vocab(de: de.trimmingCharacters(in: .whitespaces), pl: pl.trimmingCharacters(in: .whitespaces), plural: plural, ex: ex.isEmpty ? de : ex, exPl: exPl.isEmpty ? pl : exPl, topic: "Moje", kind: "Twoje słowo", note: "")
        var list = VocabBook.custom
        list.removeAll { $0.de.lowercased() == card.de.lowercased() }
        list.insert(card, at: 0)
        VocabBook.saveCustom(list)
        store.pinForReview(Word(de: card.de, pl: card.pl, ex: card.ex, exPl: card.exPl, topic: "Moje"))
        saved = true
        de = ""; pl = ""; plural = ""; ex = ""; exPl = ""
    }
}
