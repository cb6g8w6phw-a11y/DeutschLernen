import SwiftUI

struct ReadSentence: Identifiable, Hashable {
    let id: String
    let de: String
    let pl: String
}

struct ReadText: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let level: String
    let sentences: [ReadSentence]
    let words: [LineGloss]
    let question: String
    let options: [String]
    let answer: Int
    let replyPL: String
    let replyDE: String

    var german: String { sentences.map(\.de).joined(separator: " ") }
}

enum TextBook {
    static let categories = ["Codzienność", "Dojazd", "Sklep", "Mieszkanie", "Zdrowie", "Praca", "Urząd"]

    static let all: [ReadText] = [
        story("t001", "Niedziela u rodziców", "Codzienność", "A1", [
            ("Liebe Eltern, am Sonntag komme ich.", "Drodzy rodzice, w niedzielę przyjadę."),
            ("Der Zug fährt um zehn Uhr.", "Pociąg odjeżdża o dziesiątej."),
            ("Ich bin um zwölf bei euch.", "Będę u was o dwunastej."),
            ("Kocht bitte nichts extra.", "Nie gotujcie proszę nic dodatkowo."),
            ("Ich bringe Kuchen mit.", "Przywiozę ciasto."),
            ("Bis Sonntag!", "Do niedzieli!")
        ], [
            ("der Zug", "pociąg"),
            ("der Kuchen", "ciasto"),
            ("am Sonntag", "w niedzielę")
        ], "O której jest u rodziców?", ["O dwunastej", "O dziesiątej w pracy", "W poniedziałek rano"], 0, "Będę u was o dwunastej.", "Ich bin um zwölf bei euch."),
        story("t002", "Droga na zmianę", "Dojazd", "A1", [
            ("Heute beginnt meine Schicht um sechs.", "Dziś moja zmiana zaczyna się o szóstej."),
            ("Ich gehe um fünf aus dem Haus.", "Wychodzę z domu o piątej."),
            ("Der Bus kommt um zehn nach fünf.", "Autobus przyjeżdża pięć po piątej."),
            ("Die Haltestelle ist vor dem Bäcker.", "Przystanek jest przed piekarnią."),
            ("Ich brauche den Helm und den Schlüssel.", "Potrzebuję kasku i klucza."),
            ("Um halb sechs bin ich auf der Baustelle.", "O wpół do szóstej jestem na budowie.")
        ], [
            ("die Schicht", "zmiana"),
            ("der Helm", "kask"),
            ("der Schlüssel", "klucz"),
            ("die Haltestelle", "przystanek")
        ], "O której zaczyna się zmiana?", ["O szóstej", "O piątej", "W południe"], 0, "Moja zmiana zaczyna się o szóstej.", "Meine Schicht beginnt um sechs."),
        story("t003", "Zakupy przed pracą", "Sklep", "A1", [
            ("Ich kaufe Brot, Käse und Wasser.", "Kupuję chleb, ser i wodę."),
            ("Das Brot ist schon geschnitten.", "Chleb jest już pokrojony."),
            ("Der Käse kostet drei Euro.", "Ser kosztuje trzy euro."),
            ("Ich zahle mit Karte.", "Płacę kartą."),
            ("Der Bon kommt in die Tasche.", "Paragon ląduje do kieszeni."),
            ("Danach fahre ich zur Arbeit.", "Potem jadę do pracy.")
        ], [
            ("das Brot", "chleb"),
            ("der Käse", "ser"),
            ("die Karte", "karta"),
            ("der Bon", "paragon")
        ], "Czym płaci?", ["Kartą", "Tylko gotówką", "Kuponem z gazety"], 0, "Płacę kartą.", "Ich zahle mit Karte."),
        story("t004", "Klucz od piwnicy", "Mieszkanie", "A2", [
            ("Der Kellerschlüssel liegt nicht an der Tür.", "Klucz od piwnicy nie leży przy drzwiach."),
            ("Ich habe ihn gestern nach der Schicht in die Jacke gesteckt.", "Wczoraj po zmianie włożyłem go do kurtki."),
            ("In der Jacke ist er nicht.", "W kurtce go nie ma."),
            ("Im Flur steht ein Karton mit Werkzeug.", "W przedpokoju stoi karton z narzędziami."),
            ("Unter dem Karton liegt der Schlüssel.", "Pod kartonem leży klucz."),
            ("Ich hänge ihn an den Haken, nicht in die Hose.", "Wieszam go na haczyk, nie do spodni.")
        ], [
            ("der Kellerschlüssel", "klucz od piwnicy"),
            ("die Schicht", "zmiana"),
            ("der Karton", "karton"),
            ("der Haken", "haczyk")
        ], "Gdzie leżał klucz?", ["Pod kartonem w przedpokoju", "W drzwiach", "W autobusie"], 0, "Klucz leży pod kartonem.", "Der Schlüssel liegt unter dem Karton."),
        story("t005", "Zostaję w domu", "Zdrowie", "A2", [
            ("Ich bin krank und bleibe heute zu Hause.", "Jestem chory i dziś zostaję w domu."),
            ("Ich habe Fieber und Halsschmerzen.", "Mam gorączkę i ból gardła."),
            ("Zur Schicht komme ich nicht.", "Na zmianę nie przyjdę."),
            ("Ich rufe den Chef vor sechs an.", "Dzwonię do szefa przed szóstą."),
            ("Tabletten nehme ich nur so, wie auf der Packung steht.", "Tabletki biorę tylko tak, jak jest na opakowaniu."),
            ("Wenn es morgen nicht besser ist, gehe ich zum Arzt.", "Jeśli jutro nie będzie lepiej, idę do lekarza.")
        ], [
            ("das Fieber", "gorączka"),
            ("die Schicht", "zmiana"),
            ("der Chef", "szef"),
            ("die Packung", "opakowanie")
        ], "Co robi z tabletkami?", ["Bierze tylko tyle, ile jest na opakowaniu", "Bierze osiem naraz", "Czeka tydzień i nie dzwoni"], 0, "Zostaję dziś w domu i dzwonię do szefa.", "Ich bleibe heute zu Hause und rufe den Chef an."),
        story("t006", "Sobotnia zmiana", "Praca", "A2", [
            ("Am Samstag habe ich Schicht, von sieben bis fünfzehn Uhr.", "W sobotę mam zmianę, od siódmej do piętnastej."),
            ("Der Chef hat mich gestern gefragt.", "Szef zapytał mnie wczoraj."),
            ("Ich habe ja gesagt, weil ich den freien Tag schon hatte.", "Zgodziłem się, bo wolny dzień już miałem."),
            ("Ich schlafe heute früher.", "Dziś kładę się wcześniej."),
            ("Das Werkzeug lege ich abends schon in die Tasche.", "Narzędzia pakuję do torby już wieczorem."),
            ("Am Samstag bin ich um halb sieben auf der Baustelle.", "W sobotę jestem na budowie o wpół do siódmej.")
        ], [
            ("die Schicht", "zmiana"),
            ("der Chef", "szef"),
            ("das Werkzeug", "narzędzie"),
            ("die Baustelle", "budowa")
        ], "Kiedy jest ta zmiana?", ["W sobotę od siódmej do piętnastej", "W niedzielę rano", "Tylko dwie godziny"], 0, "W sobotę pracuję od siódmej do piętnastej.", "Am Samstag arbeite ich von sieben bis fünfzehn Uhr."),
        story("t007", "Mail o betonie", "Praca", "B1", [
            ("Guten Tag, der Beton für Wand drei ist noch nicht da.", "Dzień dobry, betonu na ścianę trzy jeszcze nie ma."),
            ("Wir können die Fuge heute nicht schließen.", "Nie możemy dziś zamknąć spoiny."),
            ("Ich habe beim Lieferanten nachgefragt.", "Dopytałem u dostawcy."),
            ("Er sagt, der Wagen kommt erst gegen vierzehn Uhr.", "Mówi, że samochód będzie dopiero około czternastej."),
            ("Bis dahin räumen wir die Fläche und sichern die Plane.", "Do tego czasu sprzątamy plac i mocujemy plandekę."),
            ("Bitte sagen Sie Bescheid, wenn wir trotzdem anfangen sollen.", "Proszę dać znać, jeśli mimo to mamy zaczynać.")
        ], [
            ("der Beton", "beton"),
            ("die Fuge", "spoina"),
            ("der Lieferant", "dostawca"),
            ("die Plane", "plandeka")
        ], "Kiedy ma być beton?", ["Około czternastej", "Jest już na miejscu", "Był wczoraj wieczorem"], 0, "Beton będzie dopiero około czternastej.", "Der Beton kommt erst gegen vierzehn Uhr."),
        story("t008", "Termin w urzędzie", "Urząd", "B1", [
            ("Ich brauche einen Termin bei der Ausländerbehörde.", "Potrzebuję terminu w urzędzie do spraw cudzoziemców."),
            ("Online ist erst im Mai ein Platz frei.", "W internecie wolne miejsce jest dopiero w maju."),
            ("Am Telefon sagt die Beamtin, ich soll die Unterlagen schon hochladen.", "Przez telefon urzędniczka mówi, żebym wgrał dokumenty już teraz."),
            ("Das sind der Pass, der Vertrag und die Gehaltsabrechnung.", "To paszport, umowa i odcinek wypłaty."),
            ("Den Termin bestätige ich schriftlich, nicht nur mündlich.", "Termin potwierdzam na piśmie, nie tylko ustnie."),
            ("Ohne Bestätigung gehe ich nicht umsonst hin.", "Bez potwierdzenia nie jadę na darmo.")
        ], [
            ("der Termin", "termin"),
            ("der Pass", "paszport"),
            ("der Vertrag", "umowa"),
            ("die Bestätigung", "potwierdzenie")
        ], "Co ma zrobić z dokumentami?", ["Wgrać je wcześniej", "Zanieść tylko paszport w dniu wizyty", "Czekać i nie dzwonić"], 0, "Wgrywam dokumenty i czekam na potwierdzenie.", "Ich lade die Unterlagen hoch und warte auf die Bestätigung."),
        story("t009", "Pismo o ogrzewaniu", "Mieszkanie", "B2", [
            ("Sehr geehrte Frau Keller, die Heizung im Bad wird seit Montag nicht warm.", "Szanowna pani Keller, ogrzewanie w łazience od poniedziałku nie grzeje."),
            ("Ich habe sie entlüftet, aber das Wasser bleibt kalt.", "Odpowietrzyłem je, ale woda zostaje zimna."),
            ("Die anderen Heizungen in der Wohnung funktionieren.", "Pozostałe grzejniki w mieszkaniu działają."),
            ("Ich bitte um eine Reparatur in dieser Woche, nach sechzehn Uhr, weil ich vorher auf der Baustelle bin.", "Proszę o naprawę w tym tygodniu, po szesnastej, bo wcześniej jestem na budowie."),
            ("Die Nebenkostenabrechnung vom letzten Jahr habe ich bereits überwiesen.", "Rozliczenie opłat za zeszły rok już przelałem."),
            ("Bitte schreiben Sie mir den Termin kurz per Mail.", "Proszę napisać mi termin krótko mailem.")
        ], [
            ("die Heizung", "ogrzewanie"),
            ("die Reparatur", "naprawa"),
            ("die Baustelle", "budowa"),
            ("die Nebenkostenabrechnung", "rozliczenie opłat")
        ], "Czego dotyczy prośba?", ["Naprawy ogrzewania w łazience", "Nowej umowy najmu", "Zwrotu kaucji"], 0, "Ogrzewanie w łazience nie grzeje i proszę o naprawę.", "Die Heizung im Bad wird nicht warm, ich bitte um eine Reparatur."),
        story("t010", "Brakujące nadgodziny", "Praca", "B2", [
            ("Im März habe ich zwölf Stunden mehr gearbeitet, als im Vertrag steht.", "W marcu przepracowałem dwanaście godzin więcej, niż jest w umowie."),
            ("Die Stunden stehen auf dem Stundenzettel, den der Meister unterschrieben hat.", "Godziny są na liście, którą podpisał majster."),
            ("Auf der Abrechnung vom April fehlen sie.", "Na rozliczeniu z kwietnia ich nie ma."),
            ("Ich möchte keinen Streit, nur die Korrektur vor der nächsten Lohnzahlung.", "Nie chcę kłótni, tylko poprawki przed następną wypłatą."),
            ("Wenn die Stunden in diesem Monat nicht erscheinen, lege ich den Zettel der Personalabteilung vor.", "Jeśli w tym miesiącu godziny się nie pojawią, zaniosę listę do kadr."),
            ("Bis Freitag reicht mir eine kurze Antwort.", "Do piątku wystarczy mi krótka odpowiedź.")
        ], [
            ("der Stundenzettel", "lista godzin"),
            ("die Abrechnung", "rozliczenie"),
            ("die Lohnzahlung", "wypłata"),
            ("die Personalabteilung", "kadry")
        ], "O co prosi?", ["O doliczenie dwunastu godzin przed następną wypłatą", "O nową umowę od maja", "O wolne bez wpisu"], 0, "Na rozliczeniu brakuje dwunastu godzin.", "Auf der Abrechnung fehlen zwölf Stunden.")
    ]

    static func doneIDs() -> Set<String> { Set(UserDefaults.standard.stringArray(forKey: "textDone") ?? []) }

    static func markDone(_ id: String) {
        var list = UserDefaults.standard.stringArray(forKey: "textDone") ?? []
        if !list.contains(id) { list.append(id) }
        UserDefaults.standard.set(list, forKey: "textDone")
    }

    private static func story(_ id: String, _ title: String, _ category: String, _ level: String, _ lines: [(String, String)], _ words: [(String, String)], _ question: String, _ options: [String], _ answer: Int, _ replyPL: String, _ replyDE: String) -> ReadText {
        ReadText(
            id: id,
            title: title,
            category: category,
            level: level,
            sentences: lines.enumerated().map { ReadSentence(id: "\(id)-\($0.offset)", de: $0.element.0, pl: $0.element.1) },
            words: words.map { LineGloss(de: $0.0, pl: $0.1) },
            question: question,
            options: options,
            answer: answer,
            replyPL: replyPL,
            replyDE: replyDE
        )
    }
}

struct SaveWordButton: View {
    @EnvironmentObject var store: LearningStore
    let de: String
    let pl: String
    let ex: String
    let exPl: String
    let topic: String
    let level: String
    var onSaved: () -> Void = {}
    @State private var just = false

    private var already: Bool {
        VocabBook.custom.contains { $0.de.lowercased() == de.lowercased() }
    }

    var body: some View {
        Button {
            guard !(already || just) else { return }
            VocabBook.saveMine(Vocab(de: de, pl: pl, plural: "", ex: ex, exPl: exPl, topic: topic, kind: "Zapisane", note: ""))
            store.pinForReview(Word(de: de, pl: pl, ex: ex, exPl: exPl, topic: topic, level: level))
            just = true
            onSaved()
        } label: {
            Label(already || just ? "W słowniku" : "Zapisz", systemImage: already || just ? "checkmark.circle.fill" : "plus.circle")
                .font(.caption.weight(.semibold))
        }
        .buttonStyle(.plain)
        .foregroundStyle(Theme.ok)
        .disabled(already || just)
    }
}

struct TextLibraryView: View {
    @State private var category = "Wszystko"
    @State private var level = "Wszystko"
    @State private var jump: String?

    private var shown: [ReadText] {
        TextBook.all.filter { text in
            (category == "Wszystko" || text.category == category) &&
            (level == "Wszystko" || text.level == level)
        }
    }

    var body: some View {
        List {
            Section {
                Text("Ukończone \(TextBook.doneIDs().count) z \(TextBook.all.count). Tekst jest ciągiem zdań, jak w podręczniku. Polskie tłumaczenie zostaje schowane, dopóki nie stukniesz zdania.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["Wszystko", "A1", "A2", "B1", "B2"], id: \.self) { name in
                            chip(name, on: level == name) { level = name }
                        }
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["Wszystko"] + TextBook.categories, id: \.self) { name in
                            chip(name, on: category == name) { category = name }
                        }
                    }
                }
            }
            Section("\(shown.count) tekstów") {
                ForEach(shown) { text in
                    NavigationLink {
                        TextStudyView(text: text)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(text.level).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                                Text(text.category).font(.caption).foregroundStyle(Theme.text2)
                                if TextBook.doneIDs().contains(text.id) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.ok)
                                }
                            }
                            Text(text.title).font(.headline)
                            Text("\(text.sentences.count) zdań").font(.caption).foregroundStyle(Theme.text2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Teksty i historie")
        .scrollContentBackground(.hidden)
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            if let id = UserDefaults.standard.string(forKey: "jumpText") {
                UserDefaults.standard.removeObject(forKey: "jumpText")
                jump = id
            }
        }
        .navigationDestination(isPresented: Binding(get: { jump != nil }, set: { if !$0 { jump = nil } })) {
            if let jump, let text = TextBook.all.first(where: { $0.id == jump }) {
                TextStudyView(text: text)
            }
        }
    }

    private func chip(_ name: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(name, action: action)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(on ? Theme.ink : .white)
            .background(on ? Theme.ok : Color.white.opacity(0.08), in: Capsule())
    }
}

struct TextStudyView: View {
    @EnvironmentObject var store: LearningStore
    let text: ReadText
    @State private var open: Set<String> = []
    @State private var picked: Int?
    @State private var typed = ""
    @State private var verdict = ""
    @State private var qOK: Bool?
    @State private var savedNow = 0
    @State private var started = Date()
    @State private var report: LessonResult?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                header
                page
                savedBlock
                wordList
                quiz
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .navigationTitle("Tekst")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { GermanVoice.shared.stop() }
        .sheet(item: $report) { row in
            LessonDoneView(result: row).environmentObject(store)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(text.level).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                Text(text.category).font(.caption).foregroundStyle(Theme.text2)
            }
            Text(text.title).font(.title2.bold())
            Text("Cały tekst jest po niemiecku. Stuknij jedno zdanie, żeby zobaczyć tylko jego tłumaczenie. Drugie stuknięcie je chowa.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Button {
                GermanVoice.shared.speak(text: text.german)
            } label: {
                Label("Odtwórz całą historię", systemImage: "speaker.wave.2.fill")
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(MatteGlassButton())
            LocalPlayBar()
        }
    }

    private var page: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(text.sentences) { sentence in
                sentenceRow(sentence)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var savedBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !savedHere.isEmpty {
                Text("Z twojego słownika w tym tekście").font(.headline)
                ForEach(savedHere, id: \.de) { card in
                    Text("\(card.de) — \(card.pl)").font(.subheadline)
                }
            }
        }
    }

    private var wordList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Słówka").font(.headline)
            ForEach(text.words) { word in
                HStack {
                    Text("\(word.de) — \(word.pl)").font(.subheadline)
                    Spacer()
                    SaveWordButton(de: word.de, pl: word.pl, ex: example(word.de), exPl: word.pl, topic: text.category, level: text.level) {
                        savedNow += 1
                    }
                }
            }
        }
    }

    private var quiz: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text.question).font(.title3.bold())
            ForEach(text.options.indices, id: \.self) { index in
                choice(index)
            }
            Text("Napisz po niemiecku:").font(.headline)
            Text(text.replyPL)
            TextField("Po niemiecku", text: $typed)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button("Sprawdź") { check() }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
            if !verdict.isEmpty {
                Text(verdict).foregroundStyle(Theme.text2)
            }
        }
    }

    private func choice(_ index: Int) -> some View {
        let fill: Color = {
            guard picked != nil else { return Color.white.opacity(0.08) }
            if index == text.answer { return Theme.ok.opacity(0.85) }
            if picked == index { return Theme.bad.opacity(0.85) }
            return Color.white.opacity(0.08)
        }()
        return Button(text.options[index]) {
            guard picked == nil else { return }
            picked = index
            let ok = index == text.answer
            qOK = ok
            store.noteListen(ok: ok)
        }
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .padding(.horizontal, 12)
        .foregroundStyle(.white)
        .background(fill, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var savedHere: [Vocab] {
        let blob = text.german.lowercased()
        return VocabBook.custom.filter { blob.contains(ProgressBook.lemma($0.de)) }
    }

    private func example(_ de: String) -> String {
        text.sentences.first { $0.de.lowercased().contains(ProgressBook.lemma(de)) }?.de ?? de
    }

    private func sentenceRow(_ sentence: ReadSentence) -> some View {
        let shown = open.contains(sentence.id)
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Button {
                    if shown { open.remove(sentence.id) } else { open.insert(sentence.id) }
                } label: {
                    Text(sentence.de)
                        .font(.body)
                        .foregroundStyle(shown ? Theme.ok : .white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                Button {
                    GermanVoice.shared.speak(text: sentence.de)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ok)
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 4)
            .background(shown ? Theme.ok.opacity(0.14) : Color.clear, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            if shown {
                Text(sentence.pl)
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                    .padding(.leading, 4)
                    .padding(.bottom, 4)
            }
        }
    }

    private func check() {
        let ok = Normalizer.same(typed, text.replyDE)
        verdict = ok ? "Dobrze. To zdanie jest z tego tekstu." : "Jeszcze nie. Wzorzec: \(text.replyDE)"
        if ok {
            TextBook.markDone(text.id)
            Haptic.good()
        } else {
            Haptic.bad()
        }
        guard report == nil else { return }
        var correct = 0
        var wrong = 0
        var misses: [String] = []
        if let qOK {
            if qOK { correct += 1 } else { wrong += 1; misses.append("Pytanie o całą historię") }
        }
        if ok { correct += 1 } else { wrong += 1; misses.append("Odpowiedź bez podpowiedzi") }
        let row = ProgressBook.make(
            kind: "text",
            title: text.title,
            level: text.level,
            sourceID: text.id,
            area: text.category,
            correct: correct,
            wrong: wrong,
            seconds: Int(Date().timeIntervalSince(started)),
            seenWords: text.words.count,
            remembered: savedNow,
            misses: misses,
            streak: store.streak
        )
        ProgressBook.add(row)
        report = row
    }
}
