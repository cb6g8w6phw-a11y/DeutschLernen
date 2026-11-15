import SwiftUI

// MARK: - Shadowing

struct ShadowView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var index = 0
    @State private var parts: [(word: String, ok: Bool)] = []
    @State private var heard = ""
    @State private var played = 0
    @State private var alive = true

    private let lines: [(de: String, pl: String)] = [
        ("Die Pause ist um neun.", "Przerwa jest o dziewiątej."),
        ("Der Bus hat Verspätung.", "Autobus ma opóźnienie."),
        ("Ich bin in zwanzig Minuten da.", "Będę za dwadzieścia minut."),
        ("Ich brauche eine Krankschreibung.", "Potrzebuję zwolnienia."),
        ("Kann ich mit Karte zahlen?", "Czy mogę zapłacić kartą?"),
        ("Pass auf, hier ist ein Kabel.", "Uważaj, tu jest kabel.")
    ]

    private var line: (de: String, pl: String) { lines[index % lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Najpierw zdanie, zaraz potem Ty. Ocena jest z tego, co mikrofon rozpoznał, słowo po słowie.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                Text("\(index + 1) z \(lines.count)").font(.footnote).foregroundStyle(Theme.text2)
                Text(line.pl).font(.headline)
                Text(played > 0 ? line.de : "Posłuchaj dwa razy. Tekst wejdzie po pierwszym odtworzeniu.")
                    .font(.title2.bold())
                if played > 0 {
                    Text("Słowo po słowie").font(.caption.weight(.semibold)).foregroundStyle(Theme.text2)
                    GlossRow(text: line.de)
                }
                Text(played < 2 ? "Odsłuchane \(played) z 2. Potem powtarzasz." : "Teraz powiedz to samo.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                HStack {
                    Button { Talk.de(line.de, rate: 0.36); played += 1 } label: { Label("Wolno", systemImage: "tortoise") }
                        .buttonStyle(.glass)
                    Button { Talk.de(line.de, rate: 0.48); played += 1 } label: { Label("Normalnie", systemImage: "speaker.wave.2") }
                        .buttonStyle(.glass)
                }
                if !parts.isEmpty {
                    SaidWords(parts: parts)
                    Text(scoreLine).foregroundStyle(missed.isEmpty ? Theme.ok : Theme.orange)
                    Text("Usłyszałem: \(heard)").font(.footnote).foregroundStyle(Theme.text2)
                }
                if !mic.note.isEmpty { Text(mic.note).font(.caption).foregroundStyle(.secondary) }
                if mic.listening { Text(mic.text.isEmpty ? "Mów od razu po zdaniu…" : mic.text) }
                if mic.note.contains("niepytany") || mic.note.contains("odmowa") || mic.note.contains("Brak zgody") {
                    Button("Pozwól na mikrofon") { mic.allowPrompt() }.buttonStyle(MatteGlassButton())
                }
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powtórz na głos", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MatteGlassButton())
                .disabled(played < 2)
                Button(index + 1 >= lines.count ? "Od początku" : "Następne zdanie") {
                    mic.stop()
                    parts = []
                    heard = ""
                    played = 0
                    index = index + 1 >= lines.count ? 0 : index + 1
                }
                .buttonStyle(.glass)
            }
            .padding(20)
        }
        .navigationTitle("Shadowing")
        .containerBackground(for: .navigation) { NightGlow() }
        .onChange(of: mic.listening) { was, now in
            guard alive, was, !now else { return }
            heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            parts = Heard.parts(target: line.de, heard: heard)
            let ok = !parts.isEmpty && missed.isEmpty
            store.noteSaid(ok: ok)
            let word = Word(de: line.de, pl: line.pl, ex: line.de, exPl: line.pl, topic: "Shadowing", level: "A1")
            if ok { store.grade(word, .easy, produced: true) } else { store.scheduleTomorrow(word) }
        }
        .onDisappear { alive = false; mic.stop(); Talk.stop() }
    }

    private var missed: [String] { parts.filter { !$0.ok }.map(\.word) }

    private var scoreLine: String {
        let total = parts.filter { Normalizer.clean($0.word).count > 1 }.count
        let ok = parts.filter { $0.ok && Normalizer.clean($0.word).count > 1 }.count
        if missed.isEmpty { return "Rozpoznane \(ok) z \(total). Całe zdanie przeszło." }
        return "Rozpoznane \(ok) z \(total). Do poprawy: \(missed.joined(separator: ", "))."
    }
}

// MARK: - Potoczny niemiecki

private struct StreetLine: Identifiable {
    var id: String { de }
    let de: String
    let pl: String
    let when: String
}

struct StreetView: View {
    @State private var index = 0
    @State private var typed = ""
    @State private var note = ""
    @FocusState private var writing: Bool

    private let lines: [StreetLine] = [
        StreetLine(de: "Na und?", pl: "No i co z tego?", when: "Gdy ktoś skończył i czekasz, co z tego wynika. Nie jest złośliwe."),
        StreetLine(de: "Passt schon.", pl: "Dobra, nie szkodzi.", when: "Gdy coś jest prawie dobrze i nie chcesz drążyć."),
        StreetLine(de: "Geht klar.", pl: "Jasne, zrobi się.", when: "Odpowiedź na polecenie szefa. Krócej niż „ja, mache ich”."),
        StreetLine(de: "Ich krieg das hin.", pl: "Dam radę.", when: "kriegen w mowie = dostanę / ogarnę. W piśmie częściej bekommen."),
        StreetLine(de: "Kein Thema.", pl: "Nie ma sprawy.", when: "Gdy ktoś dziękuje albo przeprasza za drobiazg."),
        StreetLine(de: "Mach langsam.", pl: "Zwolnij.", when: "Gdy ktoś mówi za szybko albo działa za ostro."),
        StreetLine(de: "Ich bin gleich da.", pl: "Zaraz jestem.", when: "SMS do szefa, gdy autobus staje."),
        StreetLine(de: "Wie bitte?", pl: "Słucham? / Proszę?", when: "Nie dosłyszałeś. Krócej niż całe „ich habe das nicht verstanden”.")
    ]

    private var line: StreetLine { lines[index % lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("\(index + 1) z \(lines.count)").font(.footnote).foregroundStyle(Theme.text2)
                Text(line.when).foregroundStyle(Theme.text2)
                Text(line.pl).font(.title3.bold())
                Text(line.de).font(.system(size: 28, weight: .bold, design: .rounded))
                Button { Talk.de(line.de, rate: 0.46) } label: { Label("Tak to brzmi", systemImage: "speaker.wave.2") }
                    .buttonStyle(.glass)
                Text("Schowaj z pamięci i napisz sam.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                TextField("Po niemiecku", text: $typed)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($writing)
                Button("Sprawdź") {
                    if Normalizer.same(typed, line.de) {
                        note = "Tak tego użyjesz."
                    } else {
                        note = "Tak się pisze: \(line.de). Twoje: \(typed)."
                    }
                    writing = false
                }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
                Button("Następny zwrot") {
                    index = (index + 1) % lines.count
                    typed = ""
                    note = ""
                }
                .buttonStyle(.glass)
            }
            .padding(20)
        }
        .navigationTitle("Jak mówią")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { Talk.stop() }
    }
}

// MARK: - Trener błędów

private struct RepairItem: Identifiable {
    var id: String { right }
    let wrong: String
    let right: String
    let why: String
    let misses: Int
    let prompt: String
}

struct RepairView: View {
    @EnvironmentObject var store: LearningStore
    @State private var round: [RepairItem] = []
    @State private var index = 0
    @State private var typed = ""
    @State private var note = ""
    @State private var cleared: [String: Int] = [:]
    @State private var options: [String] = []
    @FocusState private var writing: Bool

    private var item: RepairItem? { index < round.count ? round[index] : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if round.isEmpty {
                    Text("Nie mam jeszcze Twoich błędów.")
                        .font(.title3.bold())
                    Text("Jak pomylisz słowo w nauce albo lekcji, wrócę tu tylko z tym. Nie wymyślam problemów, których nie było.")
                        .foregroundStyle(Theme.text2)
                } else if let item {
                    Text("Twoje błędy: \(item.misses) nietrafionych przy tym punkcie.")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    Text(item.why)
                        .foregroundStyle(Theme.text2)
                    if item.wrong != "—" && item.wrong != item.right {
                        Text("Tak napisałeś: \(item.wrong)").foregroundStyle(Theme.bad)
                    }
                    Text("To napisz po niemiecku")
                        .font(.headline)
                    Text(item.prompt)
                        .font(.title2.bold())
                    if !options.isEmpty {
                        Text("Nie znasz pisowni? Wybierz jedną.")
                            .font(.footnote)
                            .foregroundStyle(Theme.text2)
                        chips(item)
                    }
                    TextField("Po niemiecku", text: $typed)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($writing)
                    Button("Sprawdź") { check(item) }
                        .primaryButton()
                        .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                    if !note.isEmpty {
                        Text(note).foregroundStyle(Theme.text2)
                        Text(item.right).font(.title3.bold())
                        Button("Dalej") { advance() }.primaryButton()
                    }
                } else {
                    Text("Ta pula jest sprawdzona.")
                        .font(.title3.bold())
                    Text("Punkt znika dopiero po dwóch poprawnych razach. Inaczej zostaje.")
                        .foregroundStyle(Theme.text2)
                    Button("Zostałe błędy") { reload() }.primaryButton()
                }
            }
            .padding(20)
        }
        .navigationTitle("Trener błędów")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { if round.isEmpty { reload() } }
        .onChange(of: typed) { old, new in
            if old != new, !note.isEmpty { note = "" }
        }
    }

    private func reload() {
        cleared = loadClear()
        var out: [RepairItem] = []
        for slip in store.journal.mistakes where slip.hits < 2 && !slip.fix.isEmpty && (cleared[slip.fix] ?? 0) < 2 {
            out.append(RepairItem(wrong: slip.text, right: slip.fix, why: "Zapisany błąd z Twoich odpowiedzi.", misses: max(slip.hits, 1), prompt: ask(slip.fix)))
        }
        let weak = store.stats
            .filter { $0.value.wrong >= 2 && $0.value.wrong > $0.value.correct && $0.value.days.count < 3 }
            .sorted { $0.value.wrong > $1.value.wrong }
        for pair in weak.prefix(6) where (cleared[pair.key] ?? 0) < 2 {
            out.append(RepairItem(wrong: "—", right: pair.key, why: why(pair.key, pair.value), misses: pair.value.wrong, prompt: ask(pair.key)))
        }
        var seen = Set<String>()
        round = out.filter { seen.insert($0.right.lowercased()).inserted }
        index = 0
        typed = ""
        note = ""
        options = round.isEmpty ? [] : mix(for: round[0])
    }

    private func loadClear() -> [String: Int] {
        let raw = UserDefaults.standard.dictionary(forKey: "repairClear") ?? [:]
        var out: [String: Int] = [:]
        for (key, value) in raw {
            if let number = value as? Int {
                out[key] = number
            } else if let number = value as? NSNumber {
                out[key] = number.intValue
            }
        }
        return out
    }

    private func ask(_ de: String) -> String {
        let key = Normalizer.clean(de)
        if let line = HardBook.all().first(where: { Normalizer.clean($0.de) == key }), !line.pl.isEmpty {
            return line.pl
        }
        let found = (store.words + FreqBank.all).first {
            Normalizer.clean($0.de) == key || Normalizer.clean($0.ex) == key
        }
        if let found, !found.pl.isEmpty { return found.pl }
        if let found, !found.exPl.isEmpty { return found.exPl }
        let parts = de.split(separator: " ").map { String($0).trimmingCharacters(in: .punctuationCharacters) }.filter { !$0.isEmpty }
        let articles = ["der", "die", "das", "ein", "eine", "einen", "einem", "einer"]
        if let first = parts.first?.lowercased(), articles.contains(first), parts.count > 1 {
            return "Rzeczownik: \(parts.dropFirst().joined(separator: " ")). Dopisz der, die albo das."
        }
        if parts.count >= 2 {
            var shown = parts
            shown[parts.count >= 3 ? 1 : 0] = "_____"
            return "Uzupełnij i napisz całe zdanie: \(shown.joined(separator: " "))"
        }
        let start = de.prefix(1)
        return "Napisz to słowo po niemiecku. Zaczyna się od \(start)."
    }

    private func why(_ de: String, _ stat: WordStat) -> String {
        _ = stat
        let low = de.lowercased()
        if low.hasPrefix("der ") || low.hasPrefix("die ") || low.hasPrefix("das ") {
            return "Rodzajnik. Słowo liczy się z der, die albo das."
        }
        if low.contains("muss") || low.contains("kann") {
            return "Szyk. muss albo kann jest drugi, zwykły czasownik na końcu."
        }
        return "To słowo mylisz częściej, niż trafiasz."
    }

    private func check(_ item: RepairItem) {
        writing = false
        if Normalizer.same(typed, item.right) {
            var next = cleared
            next[item.right] = (next[item.right] ?? 0) + 1
            cleared = next
            UserDefaults.standard.set(next, forKey: "repairClear")
            let n = next[item.right] ?? 0
            note = n >= 2 ? "Dwa razy dobrze. Tego punktu już nie dokładam." : "Raz dobrze. Zostaje, aż zrobisz to drugi raz."
            store.noteSkill("grammar", ok: true)
        } else {
            note = "Jeszcze nie. Zostaje w puli."
            store.noteSkill("grammar", ok: false)
            store.scheduleTomorrow(Word(de: item.right, pl: item.why, ex: item.right, exPl: item.wrong, topic: "Błędy", level: "A2"))
        }
    }

    private func advance() {
        let current = round[index].right
        if (cleared[current] ?? 0) >= 2 {
            round.remove(at: index)
            if index >= round.count { index = 0 }
        } else if !round.isEmpty {
            index = (index + 1) % round.count
        }
        typed = ""
        note = ""
        options = index < round.count ? mix(for: round[index]) : []
    }

    private func chips(_ item: RepairItem) -> some View {
        let wide = options.contains { $0.count > 18 }
        return Group {
            if wide {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        chip(option, item: item, wide: true)
                    }
                }
            } else {
                WordFlow(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        chip(option, item: item, wide: false)
                    }
                }
            }
        }
    }

    private func chip(_ option: String, item: RepairItem, wide: Bool) -> some View {
        let picked = Normalizer.same(typed, option)
        let revealed = !note.isEmpty
        let correct = Normalizer.same(option, item.right)
        let on = picked || (revealed && correct)
        return Button {
            guard note.isEmpty else { return }
            typed = option
            writing = false
        } label: {
            Text(option)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(on ? Theme.ink : Theme.text)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .frame(maxWidth: wide ? .infinity : nil, alignment: .leading)
                .background(revealed && correct ? Theme.ok : (revealed && picked ? Theme.bad : (picked ? Theme.ok : Color.white.opacity(0.08))), in: Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.22), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func mix(for item: RepairItem) -> [String] {
        let right = item.right.trimmingCharacters(in: .whitespacesAndNewlines)
        let sentence = right.contains(" ")
        var pool = round.map(\.right)
        pool += store.journal.mistakes.map(\.fix)
        pool += store.words.flatMap { [$0.de, $0.ex] }
        pool += VocabBook.built.flatMap { [$0.de, $0.ex] }
        pool += FreqBank.all.prefix(500).map(\.de)
        var seen = Set<String>()
        var wrong: [String] = []
        for raw in pool.shuffled() {
            let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty || text == "—" || text.count < 3 { continue }
            if sentence != text.contains(" ") { continue }
            let key = Normalizer.clean(text)
            if key.isEmpty || key == Normalizer.clean(right) || !seen.insert(key).inserted { continue }
            wrong.append(text)
        }
        let near = wrong.filter { abs($0.count - right.count) <= max(4, right.count / 2) }
        let three = Array((near.count >= 3 ? near : wrong).prefix(3))
        return (three + [right]).shuffled()
    }
}

// MARK: - Praca

struct WorkHubView: View {
    @EnvironmentObject var store: LearningStore
    @State private var step = 0
    @State private var typed = ""
    @State private var picked: Int?
    @State private var note = ""
    @State private var bossI = 0
    @State private var commandI = 0
    @State private var safetyI = 0
    @State private var commandShown: [String] = []
    @State private var safetyShown: [String] = []
    @FocusState private var writing: Bool

    private var boss: BossLine { WorkHub.bosses[bossI] }
    private var command: ListenLine { WorkHub.commands[commandI] }
    private var safety: ListenLine { WorkHub.safety[safetyI] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Krok \(min(step + 1, 4)) z 4").font(.footnote).foregroundStyle(Theme.text2)
                switch step {
                case 0: bossStep
                case 1: commandStep
                case 2: safetyStep
                default: done
                }
                NavigationLink { BuildView() } label: {
                    Text("Narzędzia, materiały i polecenia z budowy").frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                NavigationLink { WorkCourseView() } label: {
                    Text("Kurs: polecenia, narzędzia, wymiary, bezpieczeństwo").frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                NavigationLink { SiteCourseView() } label: {
                    Text("Dialogi z budowy").frame(maxWidth: .infinity).padding(.vertical, 8)
                }
            }
            .padding(20)
        }
        .navigationTitle("W pracy")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            if commandShown.isEmpty { fresh(avoidSame: false) }
        }
        .onDisappear { Talk.stop() }
    }

    private var bossStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Możesz wylosować inną sytuację. Poprawna odpowiedź nie stoi zawsze na początku.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Text(boss.title).font(.headline)
            Text("„\(boss.de)”").font(.title3.bold())
            Button { Talk.de(boss.de, rate: 0.46) } label: { Label("Odsłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Text(boss.hint)
                .foregroundStyle(Theme.text2)
            TextField("Po niemiecku", text: $typed, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($writing)
            Button("Wyślij") {
                let said = Normalizer.clean(typed)
                let ok = boss.bits.contains { said.contains($0) }
                note = ok ? boss.good : boss.bad
                store.noteSkill("sentence", ok: ok)
                writing = false
            }
            .primaryButton()
            .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
            if !note.isEmpty {
                Text(note).foregroundStyle(Theme.text2)
                Button("Dalej, polecenie") { step = 1; note = ""; typed = "" }.primaryButton()
            }
            Button("Inna sytuacja") { fresh(avoidSame: true) }
                .buttonStyle(.glass)
        }
    }

    private var commandStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Słyszysz polecenie. Tekst dopiero po odpowiedzi.")
                .foregroundStyle(Theme.text2)
            Text("Przykład \(commandI + 1) z \(WorkHub.commands.count)")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Button { Talk.de(command.audio, rate: 0.5) } label: { Label("Polecenie", systemImage: "speaker.wave.2.fill") }
                .buttonStyle(MatteGlassButton())
            ForEach(commandShown.indices, id: \.self) { i in
                Button(commandShown[i]) {
                    guard picked == nil else { return }
                    picked = i
                    store.noteListen(ok: commandShown[i] == command.options[command.answer])
                }
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .padding(.horizontal, 12)
                .foregroundStyle(.white)
                .background(chip(i, commandShown, command), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if picked != nil {
                Text(command.audio).font(.headline)
                Text(command.pl).foregroundStyle(Theme.text2)
                Button("Bezpieczeństwo") { step = 2; picked = nil }.primaryButton()
            }
        }
    }

    private var safetyStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(safety.title).font(.headline)
            Text("Przykład \(safetyI + 1) z \(WorkHub.safety.count)")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Button { Talk.de(safety.audio, rate: 0.48) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Text(safety.ask).font(.headline)
            ForEach(safetyShown.indices, id: \.self) { i in
                Button(safetyShown[i]) {
                    guard picked == nil else { return }
                    picked = i
                    store.noteListen(ok: safetyShown[i] == safety.options[safety.answer])
                }
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .padding(.horizontal, 12)
                .foregroundStyle(.white)
                .background(chip(i, safetyShown, safety), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if picked != nil {
                Text(safety.pl).foregroundStyle(Theme.text2)
                Button("Koniec zmiany") { step = 3 }.primaryButton()
            }
        }
    }

    private var done: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ta zmiana zaliczona.").font(.title3.bold())
            Text("Następnym razem będzie inny szef, inne polecenie i inne ostrzeżenie.")
                .foregroundStyle(Theme.text2)
            Button("Inna sytuacja") {
                fresh(avoidSame: true)
                step = 0
            }
            .primaryButton()
            Text("Narzędzia i materiały są niżej, w dziale Budowa. To ta sama baza, nie druga lista.")
                .foregroundStyle(Theme.text2)
        }
    }

    private func chip(_ i: Int, _ shown: [String], _ line: ListenLine) -> Color {
        guard let picked, shown.indices.contains(i) else { return Theme.card }
        if shown[i] == line.options[line.answer] { return Theme.ok.opacity(0.8) }
        if i == picked { return Theme.bad.opacity(0.8) }
        return Theme.card
    }

    private func fresh(avoidSame: Bool) {
        bossI = next(WorkHub.bosses.count, avoid: avoidSame ? bossI : -1)
        commandI = next(WorkHub.commands.count, avoid: avoidSame ? commandI : -1)
        safetyI = next(WorkHub.safety.count, avoid: avoidSame ? safetyI : -1)
        commandShown = WorkHub.commands[commandI].options.shuffled()
        safetyShown = WorkHub.safety[safetyI].options.shuffled()
        typed = ""
        note = ""
        picked = nil
    }

    private func next(_ count: Int, avoid: Int) -> Int {
        guard count > 1 else { return 0 }
        var n = Int.random(in: 0..<count)
        if n == avoid { n = (n + 1) % count }
        return n
    }
}

private struct BossLine {
    let title: String
    let de: String
    let hint: String
    let bits: [String]
    let good: String
    let bad: String
}

private struct ListenLine {
    let title: String
    let audio: String
    let ask: String
    let options: [String]
    let answer: Int
    let pl: String
}

private enum WorkHub {
    static let bosses: [BossLine] = [
        BossLine(title: "Szef pisze rano.", de: "Kacper, kommst du heute zur Frühschicht?", hint: "Odpowiedz krótko: czy jesteś i kiedy.", bits: ["ja", "komm", "bus", "minut", "spaet", "spat", "uhr", "sechs", "sieben"], good: "Wystarczy. Naturalnie: Ja. Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.", bad: "Za mało. Powiedz, że tak, i podaj czas. Wzorzec: Ja. Ich bin in zwanzig Minuten da."),
        BossLine(title: "Szef chce, żebyś został.", de: "Kannst du heute länger bleiben, bis sechs?", hint: "Powiedz, czy możesz zostać, i do której.", bits: ["ja", "kann", "bis", "uhr", "nein", "spaet", "sechs", "schicht"], good: "Dobrze. Na przykład: Ja, ich kann bis sechs bleiben.", bad: "Napisz, czy możesz. Wzorzec: Ja, ich kann bis sechs bleiben."),
        BossLine(title: "Ciężarówka już jest.", de: "Wo bist du? Der Lkw ist schon da.", hint: "Napisz, gdzie jesteś albo za ile będziesz.", bits: ["bin", "minut", "rampe", "unterwegs", "komm", "gleich", "tor"], good: "Dobrze. Na przykład: Ich bin unterwegs. In zehn Minuten bin ich an der Rampe.", bad: "Podaj miejsce albo czas. Wzorzec: Ich bin in zehn Minuten da."),
        BossLine(title: "Klucze do magazynu.", de: "Hast du die Schlüssel fürs Lager?", hint: "Powiedz, czy masz klucze, albo że je przyniesiesz.", bits: ["ja", "habe", "schluessel", "hol", "lieg", "nein", "bring"], good: "Dobrze. Na przykład: Ja, ich habe sie. Ich bringe sie mit.", bad: "Napisz o kluczach. Wzorzec: Ja, ich habe die Schlüssel."),
        BossLine(title: "Poranna odwołana.", de: "Die Frühschicht fällt aus. Kannst du zur Spätschicht kommen?", hint: "Powiedz, czy możesz przyjść na popołudnie.", bits: ["ja", "kann", "spat", "spaet", "nein", "komm", "schicht"], good: "Dobrze. Na przykład: Ja, ich kann zur Spätschicht kommen.", bad: "Odpowiedz o popołudniowej zmianie. Wzorzec: Ja, ich komme zur Spätschicht."),
        BossLine(title: "Kto wiezie transport.", de: "Bringst du heute den Transporter?", hint: "Powiedz, czy bierzesz auto, czy jedziesz busem.", bits: ["ja", "bring", "bus", "nein", "fahre", "fahr", "auto"], good: "Dobrze. Na przykład: Ja, ich bringe den Transporter.", bad: "Napisz o aucie albo o busie. Wzorzec: Ja, ich bringe den Transporter."),
        BossLine(title: "Szef nie wie, czy jesteś.", de: "Bist du krank oder kommst du?", hint: "Powiedz wprost: przychodzisz albo jesteś chory.", bits: ["krank", "komm", "bin", "ja", "nein"], good: "Dobrze. Na przykład: Ich komme. Ich bin nicht krank.", bad: "Napisz, czy przychodzisz. Wzorzec: Ich komme. Ich bin nicht krank."),
        BossLine(title: "O której startujesz.", de: "Um wie viel Uhr bist du auf der Baustelle?", hint: "Podaj godzinę.", bits: ["uhr", "sechs", "sieben", "acht", "funf", "halb", "um"], good: "Dobrze. Na przykład: Um sechs. Ich bin pünktlich da.", bad: "Podaj godzinę. Wzorzec: Um sechs."),
        BossLine(title: "Nowy kolega.", de: "Kannst du den neuen Kollegen vom Bahnhof abholen?", hint: "Powiedz, czy go odbierzesz.", bits: ["ja", "hol", "kann", "bahn", "nein", "komm"], good: "Dobrze. Na przykład: Ja, ich hole ihn vom Bahnhof ab.", bad: "Napisz, czy odbierasz kolegę. Wzorzec: Ja, ich hole ihn ab."),
        BossLine(title: "Czy masz narzędzia.", de: "Fehlt dir noch Werkzeug für heute?", hint: "Powiedz, czy czegoś brakuje.", bits: ["nein", "fehlt", "habe", "bohr", "alles", "ja", "brauche"], good: "Dobrze. Na przykład: Nein, ich habe alles.", bad: "Napisz, czy czegoś brakuje. Wzorzec: Nein, ich habe alles."),
        BossLine(title: "Start o piątej.", de: "Wir fangen heute früher an, um fünf. Schaffst du das?", hint: "Powiedz, czy zdążysz na piątą.", bits: ["ja", "schaff", "funf", "um", "nein", "kann", "fruh", "frueh"], good: "Dobrze. Na przykład: Ja, ich schaffe es. Um fünf bin ich da.", bad: "Odpowiedz o piątej. Wzorzec: Ja, um fünf bin ich da."),
        BossLine(title: "Szef cię szuka.", de: "Der Chef sucht dich. Bist du auf der Rampe?", hint: "Powiedz, gdzie jesteś.", bits: ["ja", "rampe", "bin", "nein", "komm", "container", "geruest"], good: "Dobrze. Na przykład: Ja, ich bin auf der Rampe.", bad: "Napisz, gdzie jesteś. Wzorzec: Ja, ich bin auf der Rampe.")
    ]

    static let commands: [ListenLine] = [
        ListenLine(title: "Łopata", audio: "Hol bitte die Schaufel und komm zur Baustelle.", ask: "Co masz zrobić?", options: ["Przynieś łopatę i przyjdź na budowę", "Zostań w aucie", "Idź na przerwę"], answer: 0, pl: "Przynieś łopatę i przyjdź na budowę."),
        ListenLine(title: "Drabina", audio: "Stell die Leiter an die linke Wand.", ask: "Gdzie drabina?", options: ["Pod lewą ścianę", "Na dach", "Do biura"], answer: 0, pl: "Postaw drabinę pod lewą ścianą."),
        ListenLine(title: "Wiertarka", audio: "Bring die Bohrmaschine zum Gerüst, nicht in den Keller.", ask: "Gdzie wiertarka?", options: ["Na rusztowanie, nie do piwnicy", "Do piwnicy", "Do domu"], answer: 0, pl: "Zanieś wiertarkę na rusztowanie, nie do piwnicy."),
        ListenLine(title: "Gruz", audio: "Räum den Gang frei. Der Schutt muss weg.", ask: "Co z przejściem?", options: ["Opróżnić, gruz ma zniknąć", "Zostać jak jest", "Postawić tam paletę"], answer: 0, pl: "Opróżnij przejście. Gruz ma zniknąć."),
        ListenLine(title: "Beton", audio: "Nicht mehr gießen. Der Beton ist schon zu fest.", ask: "Co z betonem?", options: ["Nie lać, jest już za twardy", "Lać dalej", "Zostawić na jutro w wiadrze otwartym"], answer: 0, pl: "Nie lać więcej. Beton jest już za twardy."),
        ListenLine(title: "Miara", audio: "Miss die Öffnung noch einmal, bevor du schneidest.", ask: "Co najpierw?", options: ["Zmierzyć otwór, potem ciąć", "Ciąć od razu", "Malować"], answer: 0, pl: "Zmierz otwór jeszcze raz, zanim przetniesz."),
        ListenLine(title: "Folia", audio: "Deck die Möbel ab, bevor du streichst.", ask: "Co przed malowaniem?", options: ["Zakryć meble", "Wyniesć meble na deszcz", "Nic nie robić"], answer: 0, pl: "Zakryj meble, zanim będziesz malować."),
        ListenLine(title: "Brama", audio: "Der Lkw steht an Tor zwei. Bitte entladen.", ask: "Co zrobić?", options: ["Rozładować przy bramie dwa", "Czekać przy bramie cztery", "Odesłać ciężarówkę"], answer: 0, pl: "Ciężarówka stoi przy bramie dwa. Rozładuj."),
        ListenLine(title: "Klucz", audio: "Zieh die Schrauben fest, aber nicht zu fest.", ask: "Jak dokręcić?", options: ["Mocno, ale nie za mocno", "W ogóle nie dokręcać", "Urwać śruby"], answer: 0, pl: "Dokręć śruby, ale nie za mocno."),
        ListenLine(title: "Woda", audio: "Hol Wasser. Der Kleber ist zu trocken.", ask: "Po co woda?", options: ["Klej jest za suchy", "Do picia na przerwę", "Do mycia auta"], answer: 0, pl: "Przynieś wodę. Klej jest za suchy."),
        ListenLine(title: "Koniec", audio: "Kehr die Rampe, bevor du gehst.", ask: "Co przed wyjściem?", options: ["Zamieść rampę", "Zostawić rampę", "Zamknąć tylko biuro"], answer: 0, pl: "Zamieć rampę, zanim wyjdziesz."),
        ListenLine(title: "Kolega", audio: "Sag dem Markus Bescheid. Er wartet unten.", ask: "Co zrobić?", options: ["Dać znać Markusowi, czeka na dole", "Iść na górę sam", "Nic nie mówić"], answer: 0, pl: "Daj znać Markusowi. Czeka na dole.")
    ]

    static let safety: [ListenLine] = [
        ListenLine(title: "Majster, zanim wejdziesz na górę.", audio: "Ohne Helm darfst du nicht hoch.", ask: "Czego nie wolno?", options: ["Iść na górę bez kasku", "Pić wody", "Rozmawiać"], answer: 0, pl: "Ohne Helm darfst du nicht hoch. Bez kasku nie wchodzisz."),
        ListenLine(title: "Przy szlifierce.", audio: "Ohne Brille keine Flex.", ask: "Czego brakuje?", options: ["Okularów", "Kawy", "Telefonu"], answer: 0, pl: "Bez okularów nie ma szlifierki."),
        ListenLine(title: "Kabel na ziemi.", audio: "Pass auf, hier liegt ein offenes Kabel.", ask: "Na co uważać?", options: ["Na odsłonięty kabel", "Na mokrą kurtkę w aucie", "Na przerwę"], answer: 0, pl: "Uważaj, tu leży odsłonięty kabel."),
        ListenLine(title: "Wózek.", audio: "Fahr nicht mit dem Stapler, wenn die Batterie rot ist.", ask: "Kiedy nie jechać?", options: ["Gdy bateria jest czerwona", "Gdy bateria jest zielona", "Gdy jest przerwa i bateria jest pełna"], answer: 0, pl: "Nie jedź wózkiem, gdy bateria jest czerwona."),
        ListenLine(title: "Pod ładunkiem.", audio: "Stell dich nicht unter die Last.", ask: "Gdzie nie stać?", options: ["Pod ładunkiem", "Obok bariery", "W szatni"], answer: 0, pl: "Nie stawaj pod ładunkiem."),
        ListenLine(title: "Mokra podłoga.", audio: "Der Boden ist nass. Nicht mit der Maschine darüber.", ask: "Czego nie robić?", options: ["Nie jechać maszyną po mokrym", "Nie rozmawiać", "Nie pić"], answer: 0, pl: "Podłoga jest mokra. Nie jedź po niej maszyną."),
        ListenLine(title: "Piła.", audio: "Zieh den Stecker, bevor du das Blatt wechselst.", ask: "Co przed wymianą tarczy?", options: ["Wyciągnąć wtyczkę", "Zostawić piłę włączoną", "Polać wodą"], answer: 0, pl: "Wyciągnij wtyczkę, zanim wymienisz tarczę."),
        ListenLine(title: "Buty.", audio: "Ohne Sicherheitsschuhe kommst du nicht aufs Gelände.", ask: "Bez czego nie wejdziesz?", options: ["Bez butów roboczych", "Bez czapki", "Bez telefonu"], answer: 0, pl: "Bez butów roboczych nie wejdziesz na teren."),
        ListenLine(title: "Bariera.", audio: "Hinter die Absperrung darf niemand.", ask: "Kto może za barierę?", options: ["Nikt", "Każdy", "Goście"], answer: 0, pl: "Za barierę nie może nikt."),
        ListenLine(title: "Gorąca tarcza.", audio: "Fass das Sägeblatt nicht an. Es ist noch heiß.", ask: "Czego nie dotykać?", options: ["Tarczy, jest gorąca", "Kasku", "Rękawic na stole"], answer: 0, pl: "Nie dotykaj tarczy. Jest jeszcze gorąca."),
        ListenLine(title: "Gaśnica.", audio: "Merk dir: der Feuerlöscher hängt neben der Tür.", ask: "Gdzie gaśnica?", options: ["Obok drzwi", "W prywatnym aucie", "Na dachu"], answer: 0, pl: "Gaśnica wisi obok drzwi."),
        ListenLine(title: "Rusztowanie.", audio: "Das Gerüst wackelt. Geh da nicht hoch.", ask: "Czego nie robić?", options: ["Nie wchodzić, rusztowanie się kiwa", "Wejść szybko", "Skakać"], answer: 0, pl: "Rusztowanie się kiwa. Nie wchodź tam.")
    ]
}

// MARK: - Plan dnia

struct DayPlanView: View {
    @EnvironmentObject var store: LearningStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Plan z Twoich liczb, nie z szablonu.")
                    .font(.title3.bold())
                Text(summary).foregroundStyle(Theme.text2)
                ForEach(tasks, id: \.title) { task in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title).font(.headline)
                        Text(task.detail).font(.subheadline).foregroundStyle(Theme.text2)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .themedCard()
                }
                Text("Opanowane (trzy dni z rzędu) nie wchodzi do planu. Dziś takich słów: \(mastered).")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
            .padding(20)
        }
        .navigationTitle("Plan dnia")
        .containerBackground(for: .navigation) { NightGlow() }
    }

    private var rows: [(String, Int, Int)] {
        let j = store.journal
        return [
            ("Słuchanie", j.skillListenOK, j.skillListenBad),
            ("Gramatyka", j.skillGrammarOK, j.skillGrammarBad),
            ("Zdania", j.skillSentenceOK, j.skillSentenceBad),
            ("Mówienie", j.skillSpeakOK, j.skillSpeakBad),
            ("Słownictwo", j.skillVocabOK, j.skillVocabBad)
        ]
    }

    private var weakest: String? {
        rows.filter { $0.1 + $0.2 > 0 }.min { lhs, rhs in
            Double(lhs.1) / Double(lhs.1 + lhs.2) < Double(rhs.1) / Double(rhs.1 + rhs.2)
        }?.0
    }

    private var weakWords: [String] {
        store.stats
            .filter { $0.value.wrong > $0.value.correct && $0.value.days.count < 3 }
            .sorted { $0.value.wrong > $1.value.wrong }
            .prefix(5)
            .map(\.key)
    }

    private var mastered: Int { store.stats.values.filter { $0.days.count >= 3 }.count }

    private var summary: String {
        let answered = rows.reduce(0) { $0 + $1.1 + $1.2 }
        if answered < 3 { return "Za mało odpowiedzi, żeby wskazać słaby punkt. Najpierw jedna lekcja i pięć słów." }
        return "Najsłabsze teraz: \(weakest ?? "brak"). Resztę odpuszczam, dopóki to nie siądzie."
    }

    private var tasks: [(title: String, detail: String)] {
        var list: [(String, String)] = []
        if let weakest {
            list.append(("1. \(weakest)", "Tu masz najgorszy stosunek dobrych do złych. Zacznij od tego kafla na dole."))
        } else {
            list.append(("1. Lekcja", "Jeszcze nie ma z czego liczyć. Otwórz Zacznij lekcję."))
        }
        if weakWords.isEmpty {
            list.append(("2. Nowe słowa", "Nie masz zaległych pomyłek. Weź jedną nową kategorię w Nauka, nie powtórkę."))
        } else {
            list.append(("2. Tylko te słowa", weakWords.joined(separator: ", ")))
        }
        list.append(("3. Jedno zdanie na głos", "Shadowing albo ratunek. Liczy się to, co rozpoznaje mikrofon."))
        return list
    }
}

// MARK: - Offline

struct OfflineView: View {
    @EnvironmentObject var store: LearningStore
    @State private var saved: [String] = []

    private let pack = CoachData.listen.prefix(8).map { $0.de.replacingOccurrences(of: "\n", with: " ") }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Lekcje, słownik i dialogi są już w aplikacji. Nie ściągam ich drugi raz.")
                    .foregroundStyle(Theme.text2)
                Text("Słów w telefonie: \(store.catalog(level: "all").count)")
                    .font(.title3.bold())
                Text("Dialogów do słuchania: \(CoachData.listen.count). Rozmowa z AI potrzebuje sieci. Reszta nie.")
                    .foregroundStyle(Theme.text2)
                Button(saved.isEmpty ? "Przypnij 8 dialogów offline" : "Dialogi przypięte") {
                    saved = Array(pack)
                    UserDefaults.standard.set(saved, forKey: "offlineDialogues")
                }
                .primaryButton()
                .disabled(!saved.isEmpty)
                ForEach(saved, id: \.self) { line in
                    Button { Talk.de(line, rate: 0.42) } label: {
                        Text(line)
                            .font(.subheadline)
                            .foregroundStyle(Theme.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .themedCard()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .navigationTitle("Offline")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { saved = UserDefaults.standard.stringArray(forKey: "offlineDialogues") ?? [] }
        .onDisappear { Talk.stop() }
    }
}

// MARK: - Ratunek

struct RescueView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var index = 0
    @State private var parts: [(word: String, ok: Bool)] = []
    @State private var heard = ""
    @State private var fastPlayed = false
    @State private var rescued = false
    @State private var alive = true

    private let lines: [(de: String, pl: String, why: String)] = [
        ("Können Sie das bitte wiederholen?", "Może pan to powtórzyć?", "Gdy zdanie przeleciało za szybko."),
        ("Können Sie bitte langsamer sprechen?", "Może pan mówić wolniej?", "Lepiej niż udawać, że rozumiesz."),
        ("Das habe ich nicht verstanden.", "Nie zrozumiałem tego.", "Mówisz wprost, bez wstydu."),
        ("Wie bitte?", "Słucham?", "Najkrótsze, gdy nie dosłyszałeś.")
    ]

    private var line: (de: String, pl: String, why: String) { lines[index % lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(line.why).foregroundStyle(Theme.text2)
                Text(line.pl).font(.title3.bold())
                Text(line.de).font(.title2.bold())
                Button { Talk.de(line.de, rate: 0.36) } label: { Label("Powoli", systemImage: "tortoise") }
                    .buttonStyle(.glass)
                if !parts.isEmpty {
                    SaidWords(parts: parts)
                    Text(heard.isEmpty ? "" : "Usłyszałem: \(heard)").font(.footnote).foregroundStyle(Theme.text2)
                }
                if mic.listening { Text(mic.text.isEmpty ? "Mów…" : mic.text) }
                if mic.note.contains("niepytany") || mic.note.contains("odmowa") || mic.note.contains("Brak zgody") {
                    Button("Pozwól na mikrofon") { mic.allowPrompt() }.buttonStyle(MatteGlassButton())
                }
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powiedz to", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MatteGlassButton())
                Button("Następny zwrot") {
                    index = (index + 1) % lines.count
                    parts = []
                    heard = ""
                }
                .buttonStyle(.glass)
                Divider().padding(.vertical, 6)
                Text("Symulacja. Niemiec mówi szybko. Twoja robota to przerwać, nie zgadywać.")
                    .font(.headline)
                Button { Talk.de("Die Lieferung kommt erst um zehn an Tor drei, nicht an Tor eins.", rate: 0.56); fastPlayed = true } label: {
                    Label("Szybkie zdanie", systemImage: "forward.fill")
                }
                .buttonStyle(.glass)
                if fastPlayed {
                    Button("Mówię, że nie rozumiem") { mic.toggle() }
                        .buttonStyle(.glass)
                    if rescued {
                        Text("Dobrze. Użyłeś zwrotu ratunkowego, zamiast udawać.").foregroundStyle(Theme.ok)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Nie rozumiem")
        .containerBackground(for: .navigation) { NightGlow() }
        .onChange(of: mic.listening) { was, now in
            guard alive, was, !now else { return }
            heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            if fastPlayed {
                let clean = Normalizer.clean(heard)
                rescued = clean.contains("wiederholen") || clean.contains("langsamer") || clean.contains("verstanden") || clean.contains("wie bitte")
                store.noteSaid(ok: rescued)
            } else {
                parts = Heard.parts(target: line.de, heard: heard)
                store.noteSaid(ok: parts.allSatisfy(\.ok))
            }
        }
        .onDisappear { alive = false; mic.stop(); Talk.stop() }
    }
}
