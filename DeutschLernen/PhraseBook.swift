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

    static func openLines() -> [HardLine] { all().filter { $0.hits < 2 } }

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
    let lines: [(pl: String, de: String)]
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
        VerbPack(verb: "machen", why: "Samego „machen” nie użyjesz. Uczysz się całego pytania i całej odpowiedzi.", lines: [
            ("Co mam zrobić?", "Was muss ich machen?"),
            ("Zrobię to później.", "Ich mache das später."),
            ("Robię to teraz.", "Ich mache das jetzt."),
            ("Co mam teraz zrobić?", "Was soll ich jetzt machen?"),
            ("Zaraz to zrobię.", "Ich mache das sofort.")
        ]),
        VerbPack(verb: "brauchen", why: "„brauchen” bez rzeczy nic nie znaczy w pracy. Mów, czego potrzebujesz.", lines: [
            ("Potrzebuję zwolnienia.", "Ich brauche eine Krankschreibung."),
            ("Czego do tego potrzebujesz?", "Was brauchst du dafür?"),
            ("Potrzebuję materiału.", "Ich brauche Material.")
        ]),
        VerbPack(verb: "kommen", why: "Nie „kommen”. Mów, o której przychodzisz albo czy jesteś na zmianie.", lines: [
            ("Przyjdę o dziewiątej.", "Ich komme um neun."),
            ("Jesteś dziś na poranną?", "Kommst du heute zur Frühschicht?")
        ]),
        VerbPack(verb: "sagen", why: "„sagen” samo nie załatwia sprawy. Mów, komu i kiedy dasz znać.", lines: [
            ("Daj znać, jak skończysz.", "Sag Bescheid, wenn du fertig bist."),
            ("Powiem szefowi.", "Ich sage dem Chef Bescheid.")
        ]),
        VerbPack(verb: "gehen", why: "Czasownik na końcu, gdy jest muss. Uczysz się całego zdania, nie samego gehen.", lines: [
            ("Muszę iść do lekarza.", "Ich muss zum Arzt gehen."),
            ("Idę do domu.", "Ich gehe nach Hause.")
        ])
    ]

    private var pack: VerbPack { packs[verb % packs.count] }
    private var current: (pl: String, de: String) { pack.lines[line % pack.lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(pack.verb).font(.largeTitle.bold())
                Text(pack.why).foregroundStyle(Theme.text2)
                Picker("Czasownik", selection: $verb) {
                    ForEach(packs.indices, id: \.self) { Text(packs[$0].verb).tag($0) }
                }
                .pickerStyle(.segmented)
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

    private var links: [(String, String)] {
        switch pack.verb {
        case "machen": return [("Pause machen", "zrobić przerwę"), ("Feierabend machen", "skończyć pracę")]
        case "brauchen": return [("Hilfe brauchen", "potrzebować pomocy"), ("Zeit brauchen", "potrzebować czasu")]
        case "kommen": return [("zu spät kommen", "spóźnić się"), ("klar kommen", "dać sobie radę")]
        case "sagen": return [("Bescheid sagen", "dać znać"), ("die Wahrheit sagen", "powiedzieć prawdę")]
        default: return [("nach Hause gehen", "iść do domu"), ("in Ordnung gehen", "być w porządku")]
        }
    }

    private var decoy: String {
        switch pack.verb {
        case "machen": return "iść do domu"
        case "brauchen": return "skończyć pracę"
        case "kommen": return "dać znać"
        case "sagen": return "zrobić przerwę"
        default: return "potrzebować pomocy"
        }
    }

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
        return map[word.lowercased()] ?? "…"
    }
}

struct NotebookView: View {
    @EnvironmentObject var store: LearningStore
    @State private var rows: [HardLine] = []
    @State private var typing: HardLine?
    @State private var typed = ""
    @State private var note = ""
    @FocusState private var writing: Bool

    private var openRows: [HardLine] { rows.filter { $0.hits < 2 } }
    private var done: Int { rows.filter { $0.hits >= 2 }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Zostaje, aż dwa razy napiszesz zdanie sam. Potem schodzi.")
                    .foregroundStyle(Theme.text2)
                Text("Otwarte: \(openRows.count). Opanowane: \(done).")
                    .font(.headline)
                if let item = typing {
                    Text(item.pl).font(.title3.bold())
                    Text("Pomyłki: \(item.misses). Dobre podejścia: \(item.hits) z 2.")
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
        let ok = Normalizer.same(typed, item.de)
        HardBook.mark(id: item.id, ok: ok)
        store.noteSkill("sentence", ok: ok)
        rows = HardBook.all()
        if ok {
            let hits = rows.first { $0.id == item.id }?.hits ?? 2
            note = hits >= 2 ? "Dwa razy dobrze. Schodzi z zeszytu." : "Raz. Zostaje, aż powtórzysz drugi raz."
            if hits >= 2 { typing = nil }
            Haptic.good()
        } else {
            note = "Jeszcze nie. Zostaje. Tak się pisze: \(item.de)"
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
