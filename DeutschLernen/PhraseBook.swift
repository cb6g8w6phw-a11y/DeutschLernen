import SwiftUI

struct HardLine: Codable, Identifiable, Hashable {
    var id: String
    var de: String
    var pl: String
    var misses: Int
    var hits: Int
}

enum HardBook {
    private static let key = "hardSentences"

    static func all() -> [HardLine] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let rows = try? JSONDecoder().decode([HardLine].self, from: data) else { return [] }
        return rows
    }

    static func openLines() -> [HardLine] { all().filter { $0.hits < 1 } }

    static func add(de: String, pl: String) {
        let clean = de.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.split(separator: " ").count >= 2 else { return }
        var rows = all()
        let id = Normalizer.clean(clean)
        if let index = rows.firstIndex(where: { $0.id == id }) {
            rows[index].misses += 1
            rows[index].hits = 0
        } else {
            rows.insert(HardLine(id: id, de: clean, pl: pl, misses: 1, hits: 0), at: 0)
        }
        if rows.count > 80 { rows = Array(rows.prefix(80)) }
        save(rows)
    }

    static func mark(id: String, ok: Bool) {
        var rows = all()
        guard let index = rows.firstIndex(where: { $0.id == id }) else { return }
        if ok {
            rows[index].hits += 1
        } else {
            rows[index].hits = 0
            rows[index].misses += 1
        }
        save(rows)
    }

    private static func save(_ rows: [HardLine]) {
        if let data = try? JSONEncoder().encode(rows) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

struct ExamSnap: Codable, Identifiable {
    var id: String { day }
    var day: String
    var listen: Int
    var grammar: Int
    var speak: Int
    var sentence: Int
}

enum ExamLog {
    private static let key = "examSnaps"

    static func all() -> [ExamSnap] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let rows = try? JSONDecoder().decode([ExamSnap].self, from: data) else { return [] }
        return rows
    }

    static func due() -> Bool {
        guard let last = all().last,
              let date = day(last.day) else { return true }
        let gap = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return gap >= 7
    }

    static func add(_ snap: ExamSnap) {
        var rows = all()
        rows.removeAll { $0.day == snap.day }
        rows.append(snap)
        if rows.count > 12 { rows = Array(rows.suffix(12)) }
        if let data = try? JSONEncoder().encode(rows) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func line(_ name: String, before: Int?, now: Int, total: Int) -> String {
        guard let before else { return "\(name): \(now)/\(total). Pierwszy pomiar." }
        if now > before { return "\(name): było \(before)/\(total), teraz \(now)/\(total). Lepiej." }
        if now < before { return "\(name): było \(before)/\(total), teraz \(now)/\(total). Nadal wymaga pracy." }
        return "\(name): dalej \(now)/\(total). Bez zmiany."
    }

    private static func day(_ text: String) -> Date? {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: text)
    }
}

private struct VerbPack: Identifiable {
    var id: String { verb }
    let verb: String
    let why: String
    let forms: String
    let lines: [(pl: String, de: String)]
    let links: [(String, String)]
    let decoy: String
}

struct PhraseView: View {
    @EnvironmentObject var store: LearningStore
    @State private var verb = 0
    @State private var line = 0
    @State private var show = true
    @State private var typed = ""
    @State private var note = ""
    @State private var bank: [String] = []
    @State private var quiz: Bool?
    @State private var ownDe = ""
    @State private var ownPl = ""
    @State private var own: [String] = UserDefaults.standard.stringArray(forKey: "ownWorkPhrases") ?? []
    @FocusState private var writing: Bool

    private let packs: [VerbPack] = [
        VerbPack(verb: "kommen", why: "Przychodzić, przyjeżdżać, zdążyć. Nie zostawiaj samego „kommen”. Mów, kiedy i dokąd.", forms: "ich komme · du kommst · er kommt · wir kommen · ihr kommt · sie kommen", lines: [
            ("Kiedy przychodzisz do pracy?", "Wann kommst du zur Arbeit?"),
            ("Przyjdę za dziesięć minut.", "Ich komme in zehn Minuten."),
            ("Przyjdź proszę natychmiast.", "Komm bitte sofort!"),
            ("Przyjdę dzisiaj trochę później.", "Ich komme heute etwas später."),
            ("Jak dostaniesz się do domu?", "Wie kommst du nach Hause?"),
            ("Beton przyjdzie po przerwie.", "Der Beton kommt nach der Pause."),
            ("Daję sobie z tym radę.", "Ich komme damit klar."),
            ("Spóźniłem się przez autobus.", "Ich bin zu spät gekommen, weil der Bus Verspätung hatte.")
        ], links: [("zur Arbeit kommen", "przyjść do pracy"), ("klar kommen", "dać sobie radę"), ("zu spät kommen", "spóźnić się")], decoy: "skończyć pracę"),
        VerbPack(verb: "machen", why: "Robić, ale w stałych zwrotach: przerwę, fajrant, bałagan. Samo machen jest puste.", forms: "ich mache · du machst · er macht · wir machen", lines: [
            ("Co mam zrobić?", "Was muss ich machen?"),
            ("Zrobię to później.", "Ich mache das später."),
            ("Robię to teraz.", "Ich mache das jetzt."),
            ("Co mam teraz zrobić?", "Was soll ich jetzt machen?"),
            ("Zaraz to zrobię.", "Ich mache das sofort."),
            ("Robimy przerwę.", "Wir machen jetzt Pause."),
            ("Kończę na dziś.", "Ich mache Feierabend."),
            ("Nie rób tego sam.", "Mach das nicht allein.")
        ], links: [("Pause machen", "zrobić przerwę"), ("Feierabend machen", "skończyć pracę"), ("Sauber machen", "posprzątać")], decoy: "iść do domu"),
        VerbPack(verb: "gehen", why: "Iść. Przy muss, kann, will czasownik idzie na koniec.", forms: "ich gehe · du gehst · er geht · wir gehen", lines: [
            ("Idę do domu.", "Ich gehe nach Hause."),
            ("Muszę iść do lekarza.", "Ich muss zum Arzt gehen."),
            ("Idziemy na górę.", "Wir gehen nach oben."),
            ("To nie przejdzie.", "Das geht nicht."),
            ("Czy mogę wejść?", "Kann ich reingehen?"),
            ("Idź ostrożnie, tu jest kabel.", "Geh vorsichtig, hier liegt ein Kabel."),
            ("Wychodzę o szóstej.", "Ich gehe um sechs."),
            ("Idziemy na przerwę.", "Wir gehen in die Pause.")
        ], links: [("nach Hause gehen", "iść do domu"), ("das geht nicht", "to nie przejdzie"), ("zur Arbeit gehen", "iść do pracy")], decoy: "dać znać"),
        VerbPack(verb: "brauchen", why: "Potrzebować konkretnej rzeczy. Mów, czego brakuje.", forms: "ich brauche · du brauchst · er braucht · wir brauchen", lines: [
            ("Potrzebuję zwolnienia.", "Ich brauche eine Krankschreibung."),
            ("Czego do tego potrzebujesz?", "Was brauchst du dafür?"),
            ("Potrzebuję materiału.", "Ich brauche Material."),
            ("Potrzebuję pomocy przy palecie.", "Ich brauche Hilfe bei der Palette."),
            ("Nie potrzebuję już klucza.", "Ich brauche den Schlüssel nicht mehr."),
            ("Potrzebujemy więcej czasu.", "Wir brauchen mehr Zeit."),
            ("Potrzebujesz kasku na górze.", "Du brauchst oben den Helm."),
            ("Potrzebuję jutro wolne.", "Ich brauche morgen frei.")
        ], links: [("Hilfe brauchen", "potrzebować pomocy"), ("Zeit brauchen", "potrzebować czasu"), ("frei brauchen", "potrzebować wolnego")], decoy: "spóźnić się"),
        VerbPack(verb: "sagen", why: "Powiedzieć komuś konkret. Najczęstsze: Bescheid sagen, dać znać.", forms: "ich sage · du sagst · er sagt · wir sagen", lines: [
            ("Daj znać, jak skończysz.", "Sag Bescheid, wenn du fertig bist."),
            ("Powiem szefowi.", "Ich sage dem Chef Bescheid."),
            ("Powiedz to jeszcze raz wolniej.", "Sag das noch einmal langsamer."),
            ("Nie powiedziałem tego.", "Das habe ich nicht gesagt."),
            ("Powiedz mi, kiedy.", "Sag mir, wann."),
            ("On mówi, że beton idzie.", "Er sagt, der Beton kommt."),
            ("Powiemy to rano.", "Wir sagen das morgen früh."),
            ("Nie mów tego przy kliencie.", "Sag das nicht vor dem Kunden.")
        ], links: [("Bescheid sagen", "dać znać"), ("die Wahrheit sagen", "powiedzieć prawdę"), ("noch einmal sagen", "powiedzieć jeszcze raz")], decoy: "zrobić przerwę"),
        VerbPack(verb: "haben", why: "Mieć. Też w zwrotach: czas, ból, rację.", forms: "ich habe · du hast · er hat · wir haben", lines: [
            ("Nie mam czasu.", "Ich habe keine Zeit."),
            ("Masz klucz?", "Hast du den Schlüssel?"),
            ("Boli mnie głowa.", "Ich habe Kopfschmerzen."),
            ("Mamy problem z dostawą.", "Wir haben ein Problem mit der Lieferung."),
            ("On ma rację.", "Er hat recht."),
            ("Nie mam drobnych.", "Ich habe kein Kleingeld."),
            ("Masz dziś zmianę?", "Hast du heute Schicht?"),
            ("Mieliśmy to wczoraj.", "Das haben wir gestern gehabt.")
        ], links: [("recht haben", "mieć rację"), ("Zeit haben", "mieć czas"), ("Schicht haben", "mieć zmianę")], decoy: "przyjść do pracy"),
        VerbPack(verb: "sein", why: "Być. Gdzie jesteś, czy coś jest zepsute, czy jesteś w drodze.", forms: "ich bin · du bist · er ist · wir sind", lines: [
            ("Jestem w drodze.", "Ich bin unterwegs."),
            ("Jesteś już na placu?", "Bist du schon auf dem Platz?"),
            ("Grzejnik jest zepsuty.", "Die Heizung ist kaputt."),
            ("Jesteśmy na przerwie.", "Wir sind in der Pause."),
            ("To jest za ciężkie.", "Das ist zu schwer."),
            ("Byłem u lekarza.", "Ich bin beim Arzt gewesen."),
            ("Sklep jest w niedzielę zamknięty.", "Der Laden ist sonntags zu."),
            ("Jestem za dziesięć minut.", "Ich bin in zehn Minuten da.")
        ], links: [("unterwegs sein", "być w drodze"), ("kaputt sein", "być zepsutym"), ("zu sein", "być zamkniętym")], decoy: "potrzebować pomocy"),
        VerbPack(verb: "müssen", why: "Musieć. Nicht müssen znaczy nie muszę, nie nie wolno.", forms: "ich muss · du musst · er muss · wir müssen", lines: [
            ("Muszę iść do lekarza.", "Ich muss zum Arzt."),
            ("Nie musisz zostawać.", "Du musst nicht bleiben."),
            ("Musimy to poprawić.", "Wir müssen das korrigieren."),
            ("On musi zadzwonić do szefa.", "Er muss den Chef anrufen."),
            ("Czy muszę to podpisać?", "Muss ich das unterschreiben?"),
            ("Muszę jeszcze wypłacić pieniądze.", "Ich muss noch Geld abheben."),
            ("Nie musimy tego dziś kończyć.", "Wir müssen das heute nicht fertig machen."),
            ("Musisz założyć kask.", "Du musst den Helm aufsetzen.")
        ], links: [("nicht müssen", "nie musieć"), ("fertig machen müssen", "musieć skończyć"), ("anrufen müssen", "musieć zadzwonić")], decoy: "dać sobie radę"),
        VerbPack(verb: "können", why: "Móc, umieć. Pytanie o zgodę: Kann ich…?", forms: "ich kann · du kannst · er kann · wir können", lines: [
            ("Czy możesz mi pomóc?", "Kannst du mir helfen?"),
            ("Nie mogę tego dźwignąć sam.", "Ich kann das nicht allein heben."),
            ("Możemy to przełożyć?", "Können wir das verschieben?"),
            ("Może pan powtórzyć?", "Können Sie das wiederholen?"),
            ("Nie mogę jutro rano.", "Ich kann morgen früh nicht."),
            ("Umiem to zrobić.", "Ich kann das machen."),
            ("Nie możemy wejść na rusztowanie.", "Wir können nicht aufs Gerüst."),
            ("Czy mogę zapłacić kartą?", "Kann ich mit Karte zahlen?")
        ], links: [("helfen können", "móc pomóc"), ("verschieben können", "móc przełożyć"), ("mit Karte zahlen können", "móc zapłacić kartą")], decoy: "mieć rację"),
        VerbPack(verb: "fahren", why: "Jechać. Do domu, do pracy, następnym pociągiem.", forms: "ich fahre · du fährst · er fährt · wir fahren", lines: [
            ("Jadę do domu.", "Ich fahre nach Hause."),
            ("Jak jedziesz do pracy?", "Wie fährst du zur Arbeit?"),
            ("Autobus już odjechał.", "Der Bus ist schon gefahren."),
            ("Jedziemy następnym pociągiem.", "Wir fahren mit dem nächsten Zug."),
            ("Jedź ostrożnie, jest ślisko.", "Fahr vorsichtig, es ist glatt."),
            ("Jadę rowerem.", "Ich fahre mit dem Fahrrad."),
            ("Czy ten autobus jedzie na dworzec?", "Fährt dieser Bus zum Bahnhof?"),
            ("Pojechałem za daleko.", "Ich bin eine Station zu weit gefahren.")
        ], links: [("nach Hause fahren", "jechać do domu"), ("zu weit fahren", "pojechać za daleko"), ("mit dem Bus fahren", "jechać autobusem")], decoy: "zrobić przerwę"),
        VerbPack(verb: "arbeiten", why: "Pracować. Gdzie, do której, w sobotę czy nie.", forms: "ich arbeite · du arbeitest · er arbeitet · wir arbeiten", lines: [
            ("Pracuję do szóstej.", "Ich arbeite bis sechs."),
            ("Pracujesz w sobotę?", "Arbeitest du am Samstag?"),
            ("Pracujemy na dachu.", "Wir arbeiten auf dem Dach."),
            ("Dziś nie pracuję.", "Ich arbeite heute nicht."),
            ("On pracuje za wolno.", "Er arbeitet zu langsam."),
            ("Pracuję tu od pół roku.", "Ich arbeite hier seit einem halben Jahr."),
            ("Nie pracujcie przy wietrze na górze.", "Arbeitet oben nicht bei dem Wind."),
            ("Pracowałem wczoraj dziesięć godzin.", "Ich habe gestern zehn Stunden gearbeitet.")
        ], links: [("auf dem Dach arbeiten", "pracować na dachu"), ("bis sechs arbeiten", "pracować do szóstej"), ("am Samstag arbeiten", "pracować w sobotę")], decoy: "spóźnić się"),
        VerbPack(verb: "holen", why: "Przynosić, odbierać, iść po coś.", forms: "ich hole · du holst · er holt · wir holen", lines: [
            ("Przyniosę drabinę.", "Ich hole die Leiter."),
            ("Idziesz po kawę?", "Holst du den Kaffee?"),
            ("Odbieram paczkę o piątej.", "Ich hole das Paket um fünf ab."),
            ("Przynieś kask z auta.", "Hol den Helm aus dem Auto."),
            ("On przyniesie śruby.", "Er holt die Schrauben."),
            ("Możemy to odebrać jutro.", "Wir können das morgen abholen."),
            ("Idę po wodę.", "Ich hole Wasser."),
            ("Nie przynoś tego sam.", "Hol das nicht allein.")
        ], links: [("abholen", "odebrać"), ("Wasser holen", "iść po wodę"), ("aus dem Auto holen", "przynieść z auta")], decoy: "być w drodze"),
        VerbPack(verb: "warten", why: "Czekać. Na kogo, jak długo, gdzie.", forms: "ich warte · du wartest · er wartet · wir warten", lines: [
            ("Czekam na dole.", "Ich warte unten."),
            ("Czekaj chwilę.", "Warte kurz."),
            ("Autobus nie czeka.", "Der Bus wartet nicht."),
            ("Czekamy na beton.", "Wir warten auf den Beton."),
            ("Na kogo czekasz?", "Auf wen wartest du?"),
            ("Nie mogę dłużej czekać.", "Ich kann nicht länger warten."),
            ("Poczekaj przy wejściu.", "Warte am Eingang."),
            ("Czekaliśmy dwadzieścia minut.", "Wir haben zwanzig Minuten gewartet.")
        ], links: [("auf den Bus warten", "czekać na autobus"), ("kurz warten", "chwilę poczekać"), ("unten warten", "czekać na dole")], decoy: "mieć zmianę"),
        VerbPack(verb: "fragen", why: "Pytać konkretnie: kogo i o co.", forms: "ich frage · du fragst · er fragt · wir fragen", lines: [
            ("Zapytam szefa.", "Ich frage den Chef."),
            ("Pytasz jeszcze raz?", "Fragst du noch einmal?"),
            ("On pyta o termin.", "Er fragt nach dem Termin."),
            ("Możemy zapytać w kasie.", "Wir können an der Kasse fragen."),
            ("Nie pytaj mnie teraz.", "Frag mich jetzt nicht."),
            ("Zapytałem o cenę.", "Ich habe nach dem Preis gefragt."),
            ("Zapytaj, czy to jest w czynszu.", "Frag, ob das in der Miete ist."),
            ("Pytam, bo nie zrozumiałem.", "Ich frage, weil ich es nicht verstanden habe.")
        ], links: [("nach dem Preis fragen", "pytać o cenę"), ("den Chef fragen", "pytać szefa"), ("noch einmal fragen", "zapytać jeszcze raz")], decoy: "jechać do domu"),
        VerbPack(verb: "bleiben", why: "Zostać. Do której, czy dłużej, czy w domu.", forms: "ich bleibe · du bleibst · er bleibt · wir bleiben", lines: [
            ("Zostaję do szóstej.", "Ich bleibe bis sechs."),
            ("Zostajesz dłużej?", "Bleibst du länger?"),
            ("Zostajemy przy tym planie.", "Wir bleiben bei dem Plan."),
            ("Zostań na dole.", "Bleib unten."),
            ("On zostaje w sobotę.", "Er bleibt am Samstag."),
            ("Nie zostaję dziś dłużej.", "Ich bleibe heute nicht länger."),
            ("Zostało jeszcze trochę betonu.", "Es ist noch etwas Beton übrig geblieben."),
            ("Zostańmy przy jednej osobie na sobotę.", "Bleiben wir bei einer Person am Samstag.")
        ], links: [("länger bleiben", "zostać dłużej"), ("unten bleiben", "zostać na dole"), ("bei dem Plan bleiben", "zostać przy planie")], decoy: "przynieść z auta")
    ]

    private var pack: VerbPack { packs[verb % packs.count] }
    private var current: (pl: String, de: String) { pack.lines[line % pack.lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(pack.verb).font(.largeTitle.bold())
                Text(pack.why).foregroundStyle(Theme.text2)
                Text(pack.forms).font(.subheadline.weight(.semibold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(packs.indices, id: \.self) { i in
                            Button(packs[i].verb) { verb = i }
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .foregroundStyle(verb == i ? Theme.ink : .white)
                                .background { if verb == i { Capsule().fill(Theme.ok) } }
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        }
                    }
                }
                if show {
                    Text("Po polsku").font(.caption.weight(.semibold)).foregroundStyle(Theme.text2)
                    Text(current.pl).font(.title3.bold())
                    Text(current.de).font(.title2.bold())
                    Text("Słowo po słowie").font(.caption.weight(.semibold)).foregroundStyle(Theme.text2)
                    GlossRow(text: current.de)
                    Button { Talk.de(current.de, rate: 0.42) } label: { Label("Posłuchaj zwrotu", systemImage: "speaker.wave.2") }
                        .buttonStyle(.glass)
                    Button("Schowaj i ułóż zwrot") {
                        show = false
                        typed = ""
                        note = ""
                        bank = current.de.split(separator: " ").map(String.init).shuffled()
                        writing = true
                    }
                    .primaryButton()
                    Text("Też z \(pack.verb)").font(.headline)
                    ForEach(pack.lines.indices, id: \.self) { i in
                        if i != line % pack.lines.count {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pack.lines[i].de).font(.headline)
                                Text(pack.lines[i].pl).font(.subheadline).foregroundStyle(Theme.text2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .themedCard(radius: 14)
                        }
                    }
                    Text("Z czym to stoi").font(.headline)
                    ForEach(Array(links.enumerated()), id: \.offset) { _, pair in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pair.0).font(.headline)
                            Text(pair.1).foregroundStyle(Theme.text2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .themedCard(radius: 14)
                    }
                    Text("Szybki sprawdzian").font(.headline)
                    Text(links[0].0).font(.title3.bold())
                    Button(links[0].1) { quiz = true }
                        .buttonStyle(.glass)
                    Button(decoy) { quiz = false }
                        .buttonStyle(.glass)
                    if let quiz {
                        Text(quiz ? "Dobrze. \(links[0].0) = \(links[0].1)." : "Nie. \(links[0].0) znaczy: \(links[0].1).")
                            .foregroundStyle(quiz ? Theme.ok : Theme.bad)
                    }
                    Text("Twój zwrot z pracy").font(.headline)
                    TextField("Po niemiecku", text: $ownDe)
                        .textFieldStyle(.roundedBorder)
                    TextField("Po polsku", text: $ownPl)
                        .textFieldStyle(.roundedBorder)
                    Button("Zapisz zwrot") { saveOwn() }
                        .buttonStyle(.glass)
                        .disabled(ownDe.trimmingCharacters(in: .whitespaces).isEmpty || ownPl.trimmingCharacters(in: .whitespaces).isEmpty)
                    ForEach(own, id: \.self) { row in
                        let bits = row.split(separator: "|", maxSplits: 1).map(String.init)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(bits.first ?? "").font(.headline)
                            Text(bits.count > 1 ? bits[1] : "").foregroundStyle(Theme.text2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    Text(current.pl).font(.title3.bold())
                    Text("Ułóż z kafelków albo napisz sam.").font(.footnote).foregroundStyle(Theme.text2)
                    HStack {
                        Text(typed.isEmpty ? "Tu ułoży się zwrot" : typed)
                            .font(.headline)
                            .foregroundStyle(typed.isEmpty ? Theme.text2 : .white)
                        Spacer()
                        if !typed.isEmpty {
                            Button("Cofnij") {
                                let parts = typed.split(separator: " ").map(String.init)
                                if let last = parts.last {
                                    typed = parts.dropLast().joined(separator: " ")
                                    bank.append(last)
                                }
                            }
                            .font(.caption.weight(.semibold))
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .themedCard(radius: 14)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 8)], spacing: 8) {
                        ForEach(bank.indices, id: \.self) { i in
                            Button(bank[i]) {
                                let word = bank.remove(at: i)
                                typed = (typed + " " + word).trimmingCharacters(in: .whitespaces)
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        }
                    }
                    TextField("albo napisz sam", text: $typed, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($writing)
                    Button("Sprawdź") { check() }
                        .primaryButton()
                        .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                }
            }
            .padding(20)
        }
        .navigationTitle("Zwroty")
        .containerBackground(for: .navigation) { NightGlow() }
        .onChange(of: verb) { _, _ in reset() }
        .onAppear { own = UserDefaults.standard.stringArray(forKey: "ownWorkPhrases") ?? [] }
        .onDisappear { Talk.stop() }
    }

    private func check() {
        writing = false
        if Normalizer.same(typed, current.de) {
            note = "Cały zwrot, nie samo słowo. Idzie dalej."
            store.noteSkill("sentence", ok: true)
            Haptic.good()
            line += 1
            if line >= pack.lines.count {
                line = 0
                verb = (verb + 1) % packs.count
            }
            show = true
            typed = ""
        } else {
            HardBook.add(de: current.de, pl: current.pl)
            note = "Nie weszło. Zwrot jest w zeszycie, aż napiszesz go dwa razy. Tak się pisze: \(current.de)"
            store.noteSkill("sentence", ok: false)
            Haptic.bad()
        }
    }

    private func reset() {
        line = 0
        show = true
        typed = ""
        note = ""
        bank = []
        quiz = nil
    }

    private var links: [(String, String)] { pack.links }

    private var decoy: String { pack.decoy }

    private func saveOwn() {
        let row = "\(ownDe.trimmingCharacters(in: .whitespaces))|\(ownPl.trimmingCharacters(in: .whitespaces))"
        own.insert(row, at: 0)
        if own.count > 20 { own = Array(own.prefix(20)) }
        UserDefaults.standard.set(own, forKey: "ownWorkPhrases")
        ownDe = ""
        ownPl = ""
    }
}

struct GlossRow: View {
    let text: String

    var body: some View {
        let parts = text.split(separator: " ").map { String($0).trimmingCharacters(in: .punctuationCharacters) }.filter { !$0.isEmpty }
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
            ForEach(Array(parts.enumerated()), id: \.offset) { _, word in
                VStack(alignment: .leading, spacing: 2) {
                    Text(word).font(.headline)
                    Text(Gloss.meaning(word)).font(.caption).foregroundStyle(Theme.text2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.12), lineWidth: 1))
            }
        }
    }
}

enum Gloss {
    static func meaning(_ word: String) -> String {
        let map = [
            "was": "co", "muss": "muszę", "ich": "ja", "machen": "robić", "mache": "robię",
            "das": "to", "später": "później", "jetzt": "teraz", "brauche": "potrzebuję",
            "eine": "jedną", "brauchst": "potrzebujesz", "du": "ty", "dafür": "do tego",
            "material": "materiał", "krankschreibung": "zwolnienie", "komme": "przyjdę",
            "um": "o", "neun": "dziewiątej", "kommst": "przychodzisz", "heute": "dziś",
            "zur": "na", "frühschicht": "poranną zmianę", "sag": "powiedz", "bescheid": "znać",
            "wenn": "kiedy", "fertig": "gotowy", "bist": "jesteś", "sage": "powiem",
            "dem": "temu", "chef": "szefowi", "zum": "do", "arzt": "lekarza", "gehen": "iść",
            "gehe": "idę", "nach": "do", "hause": "domu", "soll": "mam", "sofort": "zaraz",
            "die": "ta", "der": "ten", "pause": "przerwa", "ist": "jest", "bus": "autobus",
            "hat": "ma", "verspätung": "opóźnienie", "bin": "jestem", "zwanzig": "dwadzieścia",
            "minuten": "minut", "da": "tu", "kann": "mogę", "mit": "z", "karte": "kartą",
            "zahlen": "płacić", "pass": "uważaj", "auf": "na", "hier": "tu", "ein": "jeden",
            "kabel": "kabel"
        ]
        return map[word.lowercased()] ?? "nie mam osobnego skrótu"
    }
}

struct NotebookView: View {
    @EnvironmentObject var store: LearningStore
    @State private var rows: [HardLine] = []
    @State private var typing: HardLine?
    @State private var typed = ""
    @State private var note = ""
    @FocusState private var writing: Bool

    private var openRows: [HardLine] { rows.filter { $0.hits < 1 } }
    private var done: Int { rows.filter { $0.hits >= 1 }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Jedno poprawne zdanie zalicza je od razu. Potem wraca po przerwie, ale jeszcze nie jest opanowane.")
                    .foregroundStyle(Theme.text2)
                Text("Otwarte: \(openRows.count). Opanowane: \(done).")
                    .font(.headline)
                if let item = typing {
                    Text(item.pl).font(.title3.bold())
                    Text("Pomyłki: \(item.misses). Dobre podejścia: \(item.hits).")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    TextField("Całe zdanie", text: $typed, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .focused($writing)
                    Button("Sprawdź") { grade(item) }
                        .primaryButton()
                        .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                    Button("Wróć do listy") { typing = nil; note = "" }
                        .ghostButton()
                } else if openRows.isEmpty {
                    Text("Zeszyt jest pusty. Jak pomylisz całe zdanie w zwrotach, nauce albo lekcji, wpadnie tutaj.")
                } else {
                    ForEach(openRows) { item in
                        Button {
                            typing = item
                            typed = ""
                            note = ""
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.pl).font(.headline).foregroundStyle(Theme.text)
                                Text("\(item.misses) razy nie weszło").font(.caption).foregroundStyle(Theme.text2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .themedCard(radius: 16)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Zeszyt")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { rows = HardBook.all() }
    }

    private func grade(_ item: HardLine) {
        writing = false
        let verdict = AnswerCheck.judge(typed, item.de)
        let ok = verdict != .wrong
        HardBook.mark(id: item.id, ok: ok)
        store.noteSkill("sentence", ok: ok)
        rows = HardBook.all()
        if ok {
            note = verdict == .typo ? AnswerCheck.almost(item.de) : "Zaliczone. Wróci po przerwie, jeszcze nie jest opanowane."
            typing = nil
            Haptic.good()
        } else {
            note = AnswerCheck.miss(item.de)
            Haptic.bad()
        }
        typed = ""
    }
}

struct ExamView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var step = 0
    @State private var listen = 0
    @State private var grammar = 0
    @State private var speak = 0
    @State private var sentence = 0
    @State private var picked: Int?
    @State private var typed = ""
    @State private var heard = ""
    @State private var parts: [(word: String, ok: Bool)] = []
    @State private var report: [String] = []
    @State private var deck: [FixItem] = []
    @State private var alive = true
    @FocusState private var writing: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if !report.isEmpty {
                    Text("Wynik egzaminu").font(.title2.bold())
                    ForEach(report, id: \.self) { line in
                        Text(line).padding(12).frame(maxWidth: .infinity, alignment: .leading).themedCard(radius: 16)
                    }
                    Text(ExamLog.due() ? "Za 7 dni porównam znowu." : "Następne porównanie za 7 dni.")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                } else {
                    Text("Krok \(step + 1) z 6").font(.footnote).foregroundStyle(Theme.text2)
                    Text(ExamLog.due() ? "Minęło 7 dni albo to pierwszy pomiar." : "Możesz sprawdzić wcześniej. Porównanie i tak jest z ostatniego zapisu.")
                        .foregroundStyle(Theme.text2)
                    content
                }
            }
            .padding(20)
        }
        .navigationTitle("Egzamin")
        .containerBackground(for: .navigation) { NightGlow() }
        .onChange(of: mic.listening) { was, now in
            guard alive, step == 4, was, !now else { return }
            heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            parts = Heard.parts(target: piece(4).right, heard: heard)
        }
        .onAppear {
            if deck.isEmpty { deck = MistakeReview.nextEight(store: store) }
        }
        .onDisappear { alive = false; mic.stop(); Talk.stop() }
    }

    @ViewBuilder private var content: some View {
        switch step {
        case 0: pairStep(piece(0), "Słuchanie. Odtwórz i wybierz dobre zdanie.", "listen", play: true)
        case 1: pairStep(piece(1), "Słuchanie. Drugie zdanie, też z twoich błędów.", "listen", play: true)
        case 2: pairStep(piece(2), "Gramatyka. Które zdanie jest dobre?", "grammar", play: false)
        case 3: pairStep(piece(3), "Gramatyka. Najczęstsza pomyłka.", "grammar", play: false)
        case 4: speakStep
        default: sentenceStep
        }
    }

    private func piece(_ index: Int) -> FixItem {
        if deck.indices.contains(index) { return deck[index] }
        let fallback = MistakeReview.nextEight(store: store)
        if fallback.indices.contains(index) { return fallback[index] }
        return FixItem(id: "fallback", wrong: "Ich weiß ihn.", right: "Ich kenne ihn.", why: "Osobę: kennen.")
    }

    private func pairStep(_ item: FixItem, _ title: String, _ skill: String, play: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            if play {
                Button { Talk.de(item.right, rate: 0.46) } label: { Label("Odtwórz dobre", systemImage: "speaker.wave.2.fill") }
                    .buttonStyle(.glass)
            }
            Button(item.wrong) { guard picked == nil else { return }; picked = 0 }
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundStyle(Theme.text)
                .background(fill(0, answer: 1), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            Button(item.right) { guard picked == nil else { return }; picked = 1 }
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundStyle(Theme.text)
                .background(fill(1, answer: 1), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            if picked != nil {
                Text(item.why).foregroundStyle(Theme.text2)
                Button("Dalej") { commit(answer: 1, skill: skill) }.primaryButton()
            }
        }
    }

    private func listenStep(_ de: String, _ question: String, _ options: [String], _ answer: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Słuchanie. Najpierw samo ucho.").font(.headline)
            Button { Talk.de(de, rate: 0.46) } label: { Label("Odtwórz", systemImage: "speaker.wave.2.fill") }
                .buttonStyle(MatteGlassButton())
            Text(question).font(.headline)
            choiceList(options, answer: answer)
            if picked != nil {
                Button("Dalej") { commit(answer: answer, skill: "listen") }.primaryButton()
            }
        }
    }

    private func grammarStep(_ prompt: String, _ options: [String], _ answer: Int, _ why: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gramatyka.").font(.headline)
            Text(prompt).font(.title3.bold())
            choiceList(options, answer: answer)
            if picked != nil {
                Text(why).foregroundStyle(Theme.text2)
                Button("Dalej") { commit(answer: answer, skill: "grammar") }.primaryButton()
            }
        }
    }

    private var speakStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mówienie. Powiedz poprawne zdanie.").font(.headline)
            Text(piece(4).right).font(.title3.bold())
            Text(piece(4).why).foregroundStyle(Theme.text2)
            if !parts.isEmpty {
                SaidWords(parts: parts)
                Text(heard.isEmpty ? "" : "Usłyszałem: \(heard)").font(.footnote).foregroundStyle(Theme.text2)
            }
            if mic.listening { Text(mic.text.isEmpty ? "Słucham…" : mic.text) }
            if mic.note.contains("niepytany") || mic.note.contains("odmowa") || mic.note.contains("Brak zgody") {
                Button("Pozwól na mikrofon") { mic.allowPrompt() }.buttonStyle(MatteGlassButton())
            }
            Button { mic.toggle() } label: { Label(mic.listening ? "Stop" : "Powiedz", systemImage: "mic.fill") }
                .buttonStyle(MatteGlassButton())
            Button("Zalicz mówienie") {
                let ok = !parts.isEmpty && parts.allSatisfy(\.ok)
                if ok { speak = 1 }
                if !ok { HardBook.add(de: piece(4).right, pl: piece(4).why) }
                store.noteSaid(ok: ok)
                step += 1
            }
            .primaryButton()
            .disabled(parts.isEmpty)
        }
    }

    private var sentenceStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Napisz dobre zdanie.").font(.headline)
            Text(piece(5).why).font(.title3.bold())
            Text("Zła wersja: \(piece(5).wrong)").font(.footnote).foregroundStyle(Theme.text2)
            TextField("Całe zdanie", text: $typed)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($writing)
            Button("Zakończ egzamin") { finishSentence() }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    private func choiceList(_ options: [String], answer: Int) -> some View {
        ForEach(options.indices, id: \.self) { index in
            Button(options[index]) {
                guard picked == nil else { return }
                picked = index
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .foregroundStyle(.white)
            .background(fill(index, answer: answer), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func commit(answer: Int, skill: String) {
        let ok = picked == answer
        if skill == "listen" {
            if ok { listen += 1 }
            store.noteListen(ok: ok)
        } else {
            if ok { grammar += 1 }
            store.noteSkill("grammar", ok: ok)
        }
        picked = nil
        step += 1
    }

    private func fill(_ index: Int, answer: Int) -> Color {
        guard let picked else { return Theme.card }
        if index == answer { return Theme.ok.opacity(0.85) }
        if index == picked { return Theme.bad.opacity(0.85) }
        return Theme.card
    }

    private func finishSentence() {
        writing = false
        let target = piece(5).right
        let ok = Normalizer.same(typed, target)
        if ok { sentence = 1 } else { HardBook.add(de: target, pl: piece(5).why) }
        store.noteSkill("sentence", ok: ok)
        let snap = ExamSnap(day: LearningStore.dayKey(), listen: listen, grammar: grammar, speak: speak, sentence: sentence)
        let previous = ExamLog.all().last
        ExamLog.add(snap)
        report = [
            ExamLog.line("Słuchanie", before: previous?.listen, now: listen, total: 2),
            ExamLog.line("Gramatyka", before: previous?.grammar, now: grammar, total: 2),
            ExamLog.line("Mówienie", before: previous?.speak, now: speak, total: 1),
            ExamLog.line("Zdania", before: previous?.sentence, now: sentence, total: 1)
        ]
    }
}
