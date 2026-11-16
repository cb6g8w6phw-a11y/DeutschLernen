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
        let pool = core(store, topic: topic)
        let map = Dictionary(uniqueKeysWithValues: all(store).map { ($0.de, $0) })
        let saved = UserDefaults.standard.stringArray(forKey: key) ?? []
        var kept = saved.compactMap { map[$0] }.filter { !VocabPace.resting(VocabBook.stat(store, $0), $0.de) }
        if kept.count < limit {
            let used = Set(kept.map(\.de))
            let more = pool.filter { !used.contains($0.de) && !VocabPace.resting(VocabBook.stat(store, $0), $0.de) }.shuffled()
            kept.append(contentsOf: more.prefix(limit - kept.count))
        }
        let pick = Array(kept.prefix(limit))
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
            guard let s = store.stats[card.de] else { return false }
            if s.correct + s.wrong > 0 { return s.due <= now }
            return s.box == 0 && s.due <= now && s.due.timeIntervalSince1970 > 0
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

    static func saveMine(_ card: Vocab) {
        var list = UserDefaults.standard.stringArray(forKey: "freshVocab") ?? []
        list.removeAll { $0 == card.de }
        list.insert(card.de, at: 0)
        UserDefaults.standard.set(Array(list.prefix(8)), forKey: "freshVocab")
        var mine = custom
        mine.removeAll { $0.de.lowercased() == card.de.lowercased() }
        mine.insert(card, at: 0)
        saveCustom(Array(mine.prefix(80)))
    }

    static func freshListen() -> [CoachData.ListenQ] {
        let known = Dictionary(uniqueKeysWithValues: (built + custom).map { ($0.de, $0) })
        let ids = UserDefaults.standard.stringArray(forKey: "freshVocab") ?? []
        return ids.compactMap { id -> CoachData.ListenQ? in
            guard let card = known[id] else { return nil }
            let wrong = built.filter { $0.pl != card.pl }.prefix(3).map(\.pl)
            guard wrong.count == 3 else { return nil }
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
                NavigationLink { WortSetup() } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Jak chcesz się uczyć?").font(.headline).foregroundStyle(.white)
                        Text("Odpowiedzi do wyboru, pisanie albo obie metody. Przy błędzie wychodzi wskazówka.")
                            .font(.caption)
                            .foregroundStyle(Theme.text2)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.ok.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
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

enum VocabPace {
    static func streak(_ de: String) -> Int {
        let raw = UserDefaults.standard.dictionary(forKey: "vocabHitStreak") ?? [:]
        if let n = raw[de] as? Int { return n }
        if let n = raw[de] as? NSNumber { return n.intValue }
        return 0
    }

    static func set(_ de: String, _ n: Int) {
        var raw = UserDefaults.standard.dictionary(forKey: "vocabHitStreak") as? [String: Int] ?? [:]
        if n <= 0 { raw.removeValue(forKey: de) } else { raw[de] = n }
        UserDefaults.standard.set(raw, forKey: "vocabHitStreak")
    }

    static func resting(_ stat: WordStat, _ de: String) -> Bool {
        stat.correct > 0 && stat.due > Date()
    }
}

enum WortMode { case fresh, review, cards, hear, quiz, type, learn }

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
    @State private var banner = ""
    @State private var showHint = false
    @State private var chosen: String?

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
                    Text("\(min(index + 1, deck.count)) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                    if !banner.isEmpty {
                        Text(banner).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ok)
                    }
                    switch mode {
                    case .fresh, .review, .cards, .quiz:
                        Text(card.de)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(Theme.ok)
                            .frame(maxWidth: .infinity)
                        if !card.ex.isEmpty {
                            Text(card.ex)
                                .foregroundStyle(Theme.text2)
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            Talk.de(card.de)
                        } label: {
                            Label("Posłuchaj", systemImage: "speaker.wave.2")
                        }
                        .buttonStyle(.glass)
                        pickBlock(card)
                    case .hear:
                        Button {
                            heard = true
                            Talk.de(card.ex.isEmpty ? card.de : card.ex, rate: 0.42)
                        } label: { Label(heard ? "Odtwórz jeszcze raz" : "Posłuchaj bez tekstu", systemImage: "speaker.wave.2.fill").frame(maxWidth: .infinity, minHeight: 52) }
                            .buttonStyle(MatteGlassButton())
                        if heard { pickBlock(card) }
                    case .type:
                        Text(card.pl).font(.title2.bold())
                        Text(card.exPl).foregroundStyle(Theme.text2)
                        TextField("Po niemiecku", text: $typed)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button("Sprawdź") { checkType(card) }.primaryButton().disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                        if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                        if showHint { VocabHintCard(card: card) }
                    case .learn:
                        WortDrill(topic: topic, limit: limit)
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
        case .learn: return "Słówka"
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

    private func pickBlock(_ card: Vocab) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(choices, id: \.self) { choice in
                Button(choice) {
                    guard picked == nil else { return }
                    picked = 1
                    chosen = choice
                    let ok = choice == card.pl
                    showHint = !ok
                    mark(card, ok: ok, advance: false)
                    note = ok ? "Dobrze." : "Poprawnie: \(card.pl)"
                }
                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                .padding(.horizontal, 14)
                .foregroundStyle(.white)
                .background(reviewFill(choice, card), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .disabled(picked != nil)
            }
            if picked != nil {
                Text(card.pl).font(.headline)
                if showHint { VocabHintCard(card: card) }
                Button("Dalej") { advance() }.primaryButton()
            }
        }
    }

    private func reviewFill(_ choice: String, _ card: Vocab) -> Color {
        guard picked != nil else { return Color.white.opacity(0.08) }
        if choice == card.pl { return Theme.ok.opacity(0.85) }
        if choice == chosen { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }

    private func checkType(_ card: Vocab) {
        let ok = Normalizer.same(typed, card.de) || Normalizer.same(typed, card.ex)
        note = ok ? "Dobrze." : "Tak się pisze: \(card.de). Zdanie: \(card.ex)"
        showHint = !ok
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
            banner = ReviewAlgo.when(store.stats[word.de] ?? WordStat())
            replace(card)
            Haptic.good()
            if go { step(keepIndex: true) }
            return
        } else {
            VocabPace.set(card.de, 0)
            store.grade(word, .hard)
            banner = "Jeszcze nie. Wróci za kilka kart, a potem za 10 minut."
            again(card)
            Haptic.bad()
        }
        if go { step(keepIndex: false) }
    }

    private func again(_ card: Vocab) {
        let spot = min(deck.count, index + 3)
        let ahead = deck.dropFirst(min(deck.count, index + 1)).prefix(3)
        if !ahead.contains(where: { $0.de == card.de }) {
            deck.insert(card, at: spot)
        }
    }

    private func replace(_ card: Vocab) {
        deck.removeAll { $0.de == card.de }
        let more = VocabBook.today(store, limit: limit, topic: topic)
        for item in more where !deck.contains(where: { $0.de == item.de }) {
            deck.append(item)
            if deck.count >= limit { break }
        }
    }

    private func step(keepIndex: Bool) {
        show = false
        picked = nil
        heard = false
        typed = ""
        showHint = false
        chosen = nil
        if !keepIndex { index += 1 }
        if index > deck.count { index = deck.count }
        prepare()
    }

    private func advance() { step(keepIndex: false) }
}

struct WortSetup: View {
    @AppStorage("wortMethod") private var method = "choice"
    @EnvironmentObject var store: LearningStore
    @AppStorage("wortDaily") private var daily = 12

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Jak chcesz się uczyć?").font(.title2.bold())
                methodRow("choice", "Odpowiedzi wielokrotnego wyboru", "Słuchasz i rozpoznajesz znaczenie.")
                methodRow("write", "Pisząc", "Wpisujesz zdanie po niemiecku.")
                methodRow("both", "Połącz obie metody", "Raz wybierasz, raz piszesz.")
                NavigationLink {
                    WortSession(mode: .learn, topic: "Wszystko", limit: daily)
                } label: {
                    Text("Zaczynam").primaryButton()
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .navigationTitle("Sposób nauki")
        .containerBackground(for: .navigation) { Color.black }
    }

    private func methodRow(_ id: String, _ title: String, _ text: String) -> some View {
        Button { method = id } label: {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline).foregroundStyle(.white)
                    Text(text).font(.subheadline).foregroundStyle(Theme.text2)
                }
                Spacer()
                Image(systemName: method == id ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(method == id ? Theme.ok : Theme.text2)
            }
            .padding(14)
            .background(method == id ? Theme.ok.opacity(0.16) : Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(method == id ? Theme.ok : Color.white.opacity(0.08), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct WortDrill: View {
    @EnvironmentObject var store: LearningStore
    let topic: String
    let limit: Int
    @AppStorage("wortMethod") private var method = "choice"
    @State private var deck: [Vocab] = []
    @State private var index = 0
    @State private var picked: String?
    @State private var typed = ""
    @State private var note = ""
    @State private var choices: [String] = []
    @State private var showHint = false

    private var card: Vocab? { index < deck.count ? deck[index] : nil }
    private var writing: Bool {
        if method == "write" { return true }
        if method == "both" { return index % 2 == 1 }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let card {
                Text("\(index + 1) z \(deck.count)").font(.footnote).foregroundStyle(Theme.text2)
                Text(writing ? card.pl : card.de).font(.title.bold())
                if writing {
                    TextField("Po niemiecku", text: $typed)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    Button("Sprawdź") { gradeWrite(card) }
                        .primaryButton()
                        .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                } else {
                    ForEach(choices, id: \.self) { choice in
                        Button(choice) { gradeChoice(card, choice) }
                            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.white)
                            .background(fill(choice, card), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .disabled(picked != nil)
                    }
                }
                if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                if showHint { VocabHintCard(card: card) }
                if picked != nil || showHint {
                    Button("Dalej") { next() }.primaryButton()
                }
            } else if deck.isEmpty {
                Text("Brak słów w tej kategorii.").font(.title3.bold())
            } else {
                Text("Koniec serii").font(.largeTitle.bold())
            }
        }
        .onAppear(perform: load)
    }

    private func fill(_ choice: String, _ card: Vocab) -> Color {
        guard picked != nil else { return Color.white.opacity(0.08) }
        if choice == card.pl { return Theme.ok.opacity(0.85) }
        if choice == picked { return Theme.bad.opacity(0.75) }
        return Color.white.opacity(0.08)
    }

    private func load() {
        deck = VocabBook.today(store, limit: limit, topic: topic)
        prepare()
    }

    private func prepare() {
        guard index < deck.count else { return }
        let card = deck[index]
        let wrong = VocabBook.all(store).filter { $0.pl != card.pl }.shuffled().prefix(3).map(\.pl)
        choices = ([card.pl] + wrong).shuffled()
        picked = nil
        typed = ""
        note = ""
        showHint = false
    }

    private func gradeChoice(_ card: Vocab, _ choice: String) {
        guard picked == nil else { return }
        picked = choice
        let ok = choice == card.pl
        showHint = !ok
        note = ok ? "Dobrze." : "Poprawnie: \(card.pl)"
        remember(card, ok: ok)
    }

    private func gradeWrite(_ card: Vocab) {
        let ok = Normalizer.same(typed, card.de) || Normalizer.same(typed, card.ex)
        picked = ok ? card.de : typed
        showHint = !ok
        note = ok ? "Dobrze." : "Tak się pisze: \(card.de)"
        remember(card, ok: ok)
    }

    private func remember(_ card: Vocab, ok: Bool) {
        let word = Word(de: card.de, pl: card.pl, ex: card.ex, exPl: card.exPl, topic: card.topic)
        if ok {
            store.grade(word, .easy)
            note = "Dobrze. " + ReviewAlgo.when(store.stats[card.de] ?? WordStat())
            Haptic.good()
        } else {
            store.grade(word, .hard)
            let spot = min(deck.count, index + 3)
            deck.insert(card, at: spot)
            Haptic.bad()
        }
    }

    private func next() {
        index += 1
        prepare()
    }
}

struct VocabHintCard: View {
    let card: Vocab

    var body: some View {
        let hint = VocabHint.make(card)
        VStack(alignment: .leading, spacing: 10) {
            Text("Wskazówka").font(.headline)
            line("Dobrze", hint.right, hint.rightPL)
            line("Przeczenie", hint.neg, hint.negPL)
            line("Pytanie", hint.ask, hint.askPL)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func line(_ title: String, _ de: String, _ pl: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
            Text(de).font(.body.weight(.semibold))
            Text(pl).font(.subheadline).foregroundStyle(Theme.text2)
        }
    }
}

enum VocabHint {
    static func make(_ card: Vocab) -> (right: String, rightPL: String, neg: String, negPL: String, ask: String, askPL: String) {
        let right = card.ex.isEmpty ? card.de : card.ex
        let rightPL = card.exPl.isEmpty ? card.pl : card.exPl
        return (right, rightPL, negate(right), negatePL(rightPL), ask(right), askPL(rightPL))
    }

    private static let verb = Set(["ist", "sind", "bin", "bist", "seid", "war", "waren", "hat", "habe", "hast", "habt", "haben", "wird", "werde", "kann", "muss", "will", "soll", "darf", "geht", "gehe", "gehst", "kommt", "komme", "kommst", "macht", "mache", "sagt", "sage", "bleibt", "bleibe", "fährt", "fahre", "braucht", "brauche", "arbeitet", "arbeite", "nimmt", "nehme", "gibt", "gebe", "liegt", "steht", "kostet"])
    private static let pronoun = Set(["mir", "dir", "ihm", "ihr", "uns", "euch", "mich", "dich", "ihn", "sie"])

    private static func strip(_ sentence: String) -> String {
        var text = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        while let last = text.last, ".!?".contains(last) { text.removeLast() }
        return text.trimmingCharacters(in: .whitespaces)
    }

    private static func negate(_ sentence: String) -> String {
        let raw = strip(sentence)
        let lower = " \(raw.lowercased()) "
        if lower.contains(" nicht ") || lower.contains(" kein") { return raw + "." }
        var parts = raw.split(separator: " ").map(String.init)
        guard let index = parts.firstIndex(where: { verb.contains($0.lowercased()) }) else { return raw + " nicht." }
        let after = index + 1
        if after < parts.count, pronoun.contains(parts[after].lowercased()) {
            parts.insert("nicht", at: after + 1)
        } else {
            parts.insert("nicht", at: after)
        }
        return parts.joined(separator: " ") + "."
    }

    private static func ask(_ sentence: String) -> String {
        let raw = strip(sentence)
        var parts = raw.split(separator: " ").map(String.init)
        guard parts.count >= 2 else { return raw + "?" }
        let you = ["bin": "Bist", "habe": "Hast", "gehe": "Gehst", "komme": "Kommst", "muss": "Musst", "kann": "Kannst", "will": "Willst", "brauche": "Brauchst", "fahre": "Fährst", "arbeite": "Arbeitest", "mache": "Machst", "sage": "Sagst"]
        if parts[0].lowercased() == "ich", let flipped = you[parts[1].lowercased()] {
            let rest = parts.dropFirst(2).joined(separator: " ")
            return rest.isEmpty ? "\(flipped) du?" : "\(flipped) du \(rest)?"
        }
        guard let index = parts.firstIndex(where: { verb.contains($0.lowercased()) }), index > 0 else { return raw + "?" }
        let moved = parts.remove(at: index)
        let head = moved.prefix(1).uppercased() + moved.dropFirst()
        let articles = Set(["der", "die", "das", "ein", "eine", "einen", "dem", "den", "des"])
        let rest = parts.map { articles.contains($0.lowercased()) ? $0.lowercased() : $0 }.joined(separator: " ")
        return "\(head) \(rest)?"
    }

    private static func negatePL(_ sentence: String) -> String {
        let raw = strip(sentence)
        var parts = raw.split(separator: " ").map(String.init)
        let spots = Set(["jest", "są", "sa", "mam", "masz", "ma", "idę", "ide", "idzie"])
        if let index = parts.firstIndex(where: { spots.contains($0.lowercased()) }) {
            if index == 0 {
                let first = parts[0].prefix(1).lowercased() + parts[0].dropFirst()
                parts[0] = first
                return "Nie " + parts.joined(separator: " ") + "."
            }
            parts.insert("nie", at: index)
            return parts.joined(separator: " ") + "."
        }
        let first = raw.prefix(1).lowercased() + raw.dropFirst()
        return "Nie \(first)."
    }

    private static func askPL(_ sentence: String) -> String {
        let raw = strip(sentence)
        let first = raw.prefix(1).lowercased() + raw.dropFirst()
        return "Czy \(first)?"
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
