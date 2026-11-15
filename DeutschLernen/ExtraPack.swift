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
    }
}

// MARK: - Praca

struct WorkHubView: View {
    @EnvironmentObject var store: LearningStore
    @State private var step = 0
    @State private var typed = ""
    @State private var picked: Int?
    @State private var note = ""
    @FocusState private var writing: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Krok \(min(step + 1, 4)) z 4").font(.footnote).foregroundStyle(Theme.text2)
                switch step {
                case 0: boss
                case 1: command
                case 2: safety
                default: done
                }
                NavigationLink { BuildView() } label: {
                    Text("Narzędzia, materiały i polecenia z budowy").frame(maxWidth: .infinity).padding(.vertical, 8)
                }
            }
            .padding(20)
        }
        .navigationTitle("W pracy")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { Talk.stop() }
    }

    private var boss: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Szef pisze rano.").font(.headline)
            Text("„Kacper, kommst du heute zur Frühschicht?”").font(.title3.bold())
            Button { Talk.de("Kacper, kommst du heute zur Frühschicht?", rate: 0.46) } label: { Label("Odsłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Text("Odpowiedz krótko: czy jesteś i kiedy.")
                .foregroundStyle(Theme.text2)
            TextField("Po niemiecku", text: $typed, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($writing)
            Button("Wyślij") {
                let said = Normalizer.clean(typed)
                let ok = said.contains("ja") || said.contains("komme") || said.contains("bus") || said.contains("minute")
                note = ok
                    ? "Wystarczy. Naturalnie: Ja. Der Bus hat Verspätung. Ich bin in zwanzig Minuten da."
                    : "Za mało. Powiedz, że tak, i podaj czas. Wzorzec: Ja. Ich bin in zwanzig Minuten da."
                store.noteSkill("sentence", ok: ok)
                writing = false
            }
            .primaryButton()
            .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
            if !note.isEmpty {
                Text(note).foregroundStyle(Theme.text2)
                Button("Dalej, polecenie") { step = 1; note = ""; typed = "" }.primaryButton()
            }
        }
    }

    private var command: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Słyszysz polecenie. Tekst dopiero po odpowiedzi.")
                .foregroundStyle(Theme.text2)
            Button { Talk.de("Hol bitte die Schaufel und komm zur Baustelle.", rate: 0.5) } label: { Label("Polecenie", systemImage: "speaker.wave.2.fill") }
                .buttonStyle(MatteGlassButton())
            ForEach(Array(["Przynieś łopatę i przyjdź na budowę", "Zostań w aucie", "Idź na przerwę"].enumerated()), id: \.offset) { i, title in
                Button(title) {
                    guard picked == nil else { return }
                    picked = i
                    store.noteListen(ok: i == 0)
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .foregroundStyle(.white)
                .background(i == 0 && picked != nil ? Theme.ok.opacity(0.8) : (picked == i ? Theme.bad.opacity(0.8) : Theme.card), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if picked != nil {
                Text("Hol bitte die Schaufel und komm zur Baustelle.").font(.headline)
                Button("Bezpieczeństwo") { step = 2; picked = nil }.primaryButton()
            }
        }
    }

    private var safety: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Majster, zanim wejdziesz na górę.").font(.headline)
            Button { Talk.de("Ohne Helm darfst du nicht hoch.", rate: 0.48) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Text("Czego nie wolno?").font(.headline)
            ForEach(Array(["Iść na górę bez kasku", "Pić wody", "Rozmawiać"].enumerated()), id: \.offset) { i, title in
                Button(title) {
                    guard picked == nil else { return }
                    picked = i
                    store.noteListen(ok: i == 0)
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .foregroundStyle(.white)
                .background(i == 0 && picked != nil ? Theme.ok.opacity(0.8) : (picked == i ? Theme.bad.opacity(0.8) : Theme.card), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if picked != nil {
                Text("Ohne Helm darfst du nicht hoch. Bez kasku nie wchodzisz.").foregroundStyle(Theme.text2)
                Button("Koniec zmiany") { step = 3 }.primaryButton()
            }
        }
    }

    private var done: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ta zmiana zaliczona.").font(.title3.bold())
            Text("Narzędzia i materiały są niżej, w dziale Budowa. To ta sama baza, nie druga lista.")
                .foregroundStyle(Theme.text2)
        }
    }
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
