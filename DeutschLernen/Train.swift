import AVFoundation
import SwiftUI

enum CoachData {
    struct Line: Identifiable {
        var id: String { de }
        let de: String
        let pl: String
        let topic: String
    }

    struct ListenQ: Identifiable {
        var id: String { de }
        let de: String
        let pl: String
        let question: String
        let options: [String]
        let answer: Int
    }

    struct Prompt: Identifiable {
        var id: String { pl }
        let pl: String
        let de: String
    }

    static let listen: [ListenQ] = [
        ListenQ(de: "Kacper, hol bitte die Schaufel und komm zur Baustelle.", pl: "Kacper, przynieś proszę łopatę i przyjdź na budowę.", question: "Co masz zrobić?", options: ["Przynieść łopatę i przyjść na budowę", "Zostać w aucie", "Iść do lekarza"], answer: 0),
        ListenQ(de: "Wir fangen morgen um sechs Uhr an.", pl: "Jutro zaczynamy o szóstej.", question: "O której zaczynacie?", options: ["O ósmej", "O szóstej", "W południe"], answer: 1),
        ListenQ(de: "Mach das Loch achtzig Zentimeter tief.", pl: "Zrób dół na osiemdziesiąt centymetrów.", question: "Jak głęboki ma być dół?", options: ["40 cm", "80 cm", "2 metry"], answer: 1),
        ListenQ(de: "Pass auf, hier ist ein Kabel.", pl: "Uważaj, tu jest kabel.", question: "O co chodzi?", options: ["Uważaj, tu jest kabel", "Weź drabinę", "Idź na przerwę"], answer: 0),
        ListenQ(de: "Die Lieferung kommt erst um zehn.", pl: "Dostawa przyjedzie dopiero o dziesiątej.", question: "Kiedy jest dostawa?", options: ["O siódmej", "Już stoi", "Dopiero o dziesiątej"], answer: 2),
        ListenQ(de: "Kannst du den Transporter alleine beladen?", pl: "Czy możesz sam załadować busa?", question: "O co pyta?", options: ["Czy sam załadujesz busa", "Czy masz prawo jazdy na busa", "Czy bus jest zepsuty"], answer: 0),
        ListenQ(de: "Ich bin krank und komme heute nicht.", pl: "Jestem chory i dziś nie przyjdę.", question: "Co mówi pracownik?", options: ["Jest chory i dziś nie przyjdzie", "Spóźni się 10 minut", "Skończył robotę"], answer: 0),
        ListenQ(de: "Der Chef sagt, dass du morgen um sieben Uhr anfangen sollst.", pl: "Szef mówi, że masz jutro zacząć o siódmej.", question: "O której masz zacząć?", options: ["O 6:00", "O 7:00", "O 9:00"], answer: 1)
    ]

    static let build: [Line] = [
        Line(de: "die Schaufel", pl: "łopata", topic: "Narzędzia"),
        Line(de: "die Schubkarre", pl: "taczka", topic: "Narzędzia"),
        Line(de: "der Vorschlaghammer", pl: "młot", topic: "Narzędzia"),
        Line(de: "die Wasserwaage", pl: "poziomica", topic: "Narzędzia"),
        Line(de: "Grab ein Loch.", pl: "Wykop dół.", topic: "Dół i wymiary"),
        Line(de: "Mach das Loch 80 Zentimeter tief.", pl: "Zrób dół na 80 centymetrów.", topic: "Dół i wymiary"),
        Line(de: "Das ist zu breit.", pl: "To jest za szerokie.", topic: "Dół i wymiary"),
        Line(de: "Miss noch mal nach.", pl: "Zmierz jeszcze raz.", topic: "Dół i wymiary"),
        Line(de: "Pass auf!", pl: "Uważaj!", topic: "Bezpieczeństwo"),
        Line(de: "Zieh die Handschuhe an.", pl: "Załóż rękawice.", topic: "Bezpieczeństwo"),
        Line(de: "Hier ist der Helm Pflicht.", pl: "Tu kask jest obowiązkowy.", topic: "Bezpieczeństwo"),
        Line(de: "Geh da nicht lang.", pl: "Tamtędy nie idź.", topic: "Bezpieczeństwo"),
        Line(de: "Hol bitte die Schaufel.", pl: "Przynieś proszę łopatę.", topic: "Polecenia"),
        Line(de: "Wir fangen um sechs Uhr an.", pl: "Zaczynamy o szóstej.", topic: "Polecenia"),
        Line(de: "Mach erst die andere Seite.", pl: "Najpierw zrób drugą stronę.", topic: "Polecenia"),
        Line(de: "Sag Bescheid, wenn du fertig bist.", pl: "Daj znać, jak skończysz.", topic: "Polecenia"),
        Line(de: "der Beton", pl: "beton", topic: "Materiały"),
        Line(de: "der Kies", pl: "żwir", topic: "Materiały"),
        Line(de: "das Kabel", pl: "kabel", topic: "Materiały"),
        Line(de: "die Schraube", pl: "śruba", topic: "Materiały")
    ]

    static let prompts: [Prompt] = [
        Prompt(pl: "Jutro mogę zacząć o szóstej.", de: "Ich kann morgen um sechs Uhr anfangen."),
        Prompt(pl: "Brakuje nam materiału.", de: "Uns fehlt Material."),
        Prompt(pl: "Zaraz będę.", de: "Ich bin gleich da."),
        Prompt(pl: "Nie rozumiem, proszę wolniej.", de: "Ich verstehe nicht, bitte langsamer."),
        Prompt(pl: "Gdzie mam to postawić?", de: "Wo soll ich das hinstellen?"),
        Prompt(pl: "Jestem chory i dziś nie przyjdę.", de: "Ich bin krank und komme heute nicht."),
        Prompt(pl: "Ile to kosztuje?", de: "Was kostet das?"),
        Prompt(pl: "Mogę jutro przyjść na rozmowę.", de: "Ich kann morgen zum Gespräch kommen.")
    ]

    static let say: [Prompt] = [
        Prompt(pl: "Pracuję dziś na budowie.", de: "Ich arbeite heute auf der Baustelle."),
        Prompt(pl: "Pracowałem sześć lat w Niemczech.", de: "Ich habe sechs Jahre in Deutschland gearbeitet."),
        Prompt(pl: "Proszę łopatę.", de: "Hol bitte die Schaufel."),
        Prompt(pl: "Uważaj, tu jest kabel.", de: "Pass auf, hier ist ein Kabel."),
        Prompt(pl: "Mogę zacząć o szóstej.", de: "Ich kann um sechs Uhr anfangen."),
        Prompt(pl: "Gdzie jest kierownik?", de: "Wo ist der Chef?")
    ]
}

struct TodayView: View {
    @EnvironmentObject var store: LearningStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    hero
                    ThemePicker()
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        tile("Opanowane", "\(store.masteredCount)", "checkmark.circle")
                        tile("W nauce", "\(store.learningCount)", "book")
                        tile("Do powtórki", "\(store.dueToday)", "clock")
                        tile("Seria", "\(store.streak) dni", "flame")
                    }
                    goal
                    if let word = store.wordOfDay { wordCard(word) }
                    Text("Trening").font(.headline)
                    NavigationLink { QuizView(sessionSize: 10) } label: { row("Powtórki", "Słówka, które już czas przypomnieć", "rectangle.stack") }
                    NavigationLink { WordsView() } label: { row("Moje słówka", "Lista i fiszka", "text.book.closed") }
                    NavigationLink { TutorView() } label: { row("Rozmowa", "Mówisz, dostajesz krótką poprawkę", "waveform") }
                    NavigationLink { ListenView() } label: { row("Słuchanie", "Wolno, normalnie albo szybko", "ear") }
                    NavigationLink { PronounceView() } label: { row("Wymowa", "Powtarzasz zdanie na głos", "mic") }
                    NavigationLink { SentenceView() } label: { row("Zdania", "Tłumaczysz sam", "text.badge.checkmark") }
                    NavigationLink { BuildView() } label: { row("Budowa", "Narzędzia i polecenia", "hammer") }
                }
                .padding()
            }
            .navigationTitle("Dziś")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var hero: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Dzień \(store.planDay) z 30")
                    .font(.title2.bold())
                Text(store.phaseTitle)
                    .font(.footnote)
                    .foregroundStyle(Ink.muted)
            }
            Spacer()
            ring
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var ring: some View {
        let progress = Double(store.planDay) / 30
        return ZStack {
            Circle().stroke(Color.white.opacity(0.08), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Ink.accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.subheadline.bold())
        }
        .frame(width: 78, height: 78)
    }

    private func tile(_ title: String, _ value: String, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundStyle(Ink.accent)
            Text(value).font(.title3.bold())
            Text(title).font(.caption).foregroundStyle(Ink.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .liquidGlass(radius: 18)
    }

    private var goal: some View {
        let done = min(store.reviewsToday, 20)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Dzisiejszy cel").font(.headline)
                Spacer()
                Text("\(done)/20").foregroundStyle(Ink.accent).font(.headline)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08))
                    Capsule().fill(Ink.accent).frame(width: geo.size.width * CGFloat(done) / 20)
                }
            }
            .frame(height: 8)
            Text("Do powtórki dzisiaj: \(store.dueToday)")
                .font(.footnote)
                .foregroundStyle(Ink.muted)
        }
        .padding(16)
        .liquidGlass(radius: 20)
    }

    private func wordCard(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Zdanie na dziś").font(.caption).foregroundStyle(Ink.muted)
            Text(word.de).font(.title3.bold())
            Text(word.pl).foregroundStyle(Ink.muted)
            Button { Talk.de(word.ex) } label: {
                Label("Odtwórz", systemImage: "speaker.wave.2")
            }
            .buttonStyle(.plain)
            .foregroundStyle(Ink.accent)
            .font(.footnote)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 20)
    }

    private func row(_ title: String, _ text: String, _ icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 36, height: 36)
                .background(Ink.accent.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(Ink.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(text).font(.footnote).foregroundStyle(Ink.muted)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(Ink.muted)
        }
        .padding(14)
        .liquidGlass(radius: 18)
    }
}

struct ListenView: View {
    @EnvironmentObject var store: LearningStore
    @State private var index = 0
    @State private var speed: Float = 0.46
    @State private var voice = ""
    @State private var picked: Int?
    @State private var showPL = false
    @State private var saved = false
    @State private var voices: [(id: String, name: String)] = []

    private var item: CoachData.ListenQ { CoachData.listen[index % CoachData.listen.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Posłuchaj polecenia. Potem odpowiedz, co z niego wynika. Nie musisz znać każdego słowa.")
                    .font(.footnote).foregroundStyle(.secondary)
                Picker("Tempo", selection: $speed) {
                    Text("Wolno").tag(Float(0.35))
                    Text("Normalnie").tag(Float(0.46))
                    Text("Szybko").tag(Float(0.56))
                }
                .pickerStyle(.segmented)
                if voices.count > 1 {
                    Picker("Głos", selection: $voice) {
                        Text("Domyślny").tag("")
                        ForEach(voices, id: \.id) { v in Text(v.name).tag(v.id) }
                    }
                }
                Button { Talk.de(item.de, rate: speed, voice: voice.isEmpty ? nil : voice) } label: {
                    Label("Odtwórz", systemImage: "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
                Button(showPL ? "Ukryj tłumaczenie" : "Tłumaczenie") { showPL.toggle() }
                    .buttonStyle(.glass)
                Text(item.question).font(.title3.bold())
                ForEach(item.options.indices, id: \.self) { i in
                    Button { choose(i) } label: {
                        Text(item.options[i]).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.glass)
                    .tint(color(i))
                }
                if picked != nil || showPL {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.de).font(.body.italic())
                        Text(item.pl)
                        Button {
                            store.pinForReview(Word(
                                de: item.de,
                                pl: item.pl,
                                ex: item.de,
                                exPl: item.pl,
                                topic: "Słuchanie",
                                level: "A2"
                            ))
                            saved = true
                        } label: {
                            Label(saved ? "Jest w powtórkach" : "Nie rozumiem — dodaj do powtórek", systemImage: saved ? "checkmark" : "plus.rectangle.on.rectangle")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.glass)
                        .disabled(saved)
                    }
                    .padding(12)
                    .liquidGlass(radius: 16)
                }
                if picked != nil {
                    Button("Następne") {
                        picked = nil
                        showPL = false
                        saved = false
                        index += 1
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                }
                if store.journal.listenTries > 0 {
                    Text("Trafione: \(store.journal.listenOk) z \(store.journal.listenTries)")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Słuchanie")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            voices = AVSpeechSynthesisVoice.speechVoices()
                .filter { $0.language.hasPrefix("de") }
                .map { ($0.identifier, $0.name) }
        }
        .onDisappear { Talk.stop() }
    }

    private func choose(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        store.noteListen(ok: i == item.answer)
    }

    private func color(_ i: Int) -> Color {
        guard let picked else { return Ink.brass }
        if i == item.answer { return Ink.pine }
        if i == picked { return Ink.clay }
        return .gray
    }
}

struct PronounceView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var index = 0
    @State private var parts: [(word: String, ok: Bool)] = []

    private var item: CoachData.Prompt { CoachData.say[index % CoachData.say.count] }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(item.pl).font(.headline)
            Text(item.de).font(.title2.bold())
            Button { Talk.de(item.de, rate: 0.42) } label: {
                Label("Posłuchaj", systemImage: "speaker.wave.2")
            }
            .buttonStyle(.glass)
            if !parts.isEmpty {
                SaidWords(parts: parts)
            }
            if !mic.note.isEmpty { Text(mic.note).font(.caption).foregroundStyle(.secondary) }
            if mic.listening { Text(mic.text.isEmpty ? "Słucham…" : mic.text).font(.footnote) }
            HStack {
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powiedz", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(mic.listening ? Ink.clay : Ink.brass)
                Button("Następne") {
                    mic.stop()
                    parts = []
                    index += 1
                }
                .buttonStyle(.glass)
            }
            Text("Zielone słowo było słyszalne. Czerwone popraw jeszcze raz, zwłaszcza końcówkę.")
                .font(.footnote).foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Wymowa")
        .containerBackground(for: .navigation) { NightGlow() }
        .onChange(of: mic.listening) { was, now in
            guard was, !now else { return }
            let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            parts = Heard.parts(target: item.de, heard: heard)
            store.noteSaid()
        }
        .onDisappear { mic.stop(); Talk.stop() }
    }
}

struct SaidWords: View {
    let parts: [(word: String, ok: Bool)]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(Array(parts.enumerated()), id: \.offset) { _, part in
                    Text(part.word)
                        .font(.headline)
                        .foregroundStyle(part.ok ? Ink.pine : Ink.clay)
                }
            }
        }
    }
}

struct BuildView: View {
    @EnvironmentObject var store: LearningStore
    @State private var topic = "Polecenia"
    @State private var added = ""

    private var topics: [String] {
        var seen: [String] = []
        for line in CoachData.build where !seen.contains(line.topic) { seen.append(line.topic) }
        return seen
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Krótkie polecenia z budowy. Stuknij, żeby usłyszeć. Potem powiedz je sam w Wymowie.")
                    .font(.footnote).foregroundStyle(.secondary)
                Picker("Dział", selection: $topic) {
                    ForEach(topics, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.segmented)
                ForEach(CoachData.build.filter { $0.topic == topic }) { line in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(line.de).font(.headline)
                        Text(line.pl).font(.footnote).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .liquidGlass(radius: 18)
                    .onTapGesture { Talk.de(line.de, rate: 0.42) }
                }
                Button("Dodaj ten dział do fiszek") { saveTopic() }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                if !added.isEmpty { Text(added).font(.footnote).foregroundStyle(.secondary) }
            }
            .padding()
        }
        .navigationTitle("Budowa")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { Talk.stop() }
    }

    private func saveTopic() {
        let words = CoachData.build.filter { $0.topic == topic }.map {
            Word(de: $0.de, pl: $0.pl, ex: $0.de, exPl: $0.pl, topic: "Budowa", level: "A2")
        }
        let n = store.addWords(words)
        added = n == 0 ? "Te zwroty już są w powtórkach." : "Doszło \(n). Wyjdą, kiedy przyjdzie ich kolej."
    }
}

struct SentenceView: View {
    @State private var index = 0
    @State private var typed = ""
    @State private var verdict = ""
    @State private var loading = false

    private var item: CoachData.Prompt { CoachData.prompts[index % CoachData.prompts.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Powiedz to po niemiecku. Najpierw sam, potem porównanie.")
                    .font(.footnote).foregroundStyle(.secondary)
                Text(item.pl).font(.title2.bold())
                TextField("Twoje zdanie po niemiecku", text: $typed, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)
                Button("Sprawdź") { check() }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                    .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                if !verdict.isEmpty {
                    Text(verdict).font(.body)
                    Text("Naturalnie: \(item.de)").font(.headline)
                    Button { Talk.de(item.de) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                        .buttonStyle(.glass)
                }
                Button(loading ? "Czekam…" : "Oceń przez AI") { Task { await ask() } }
                    .buttonStyle(.glass)
                    .disabled(loading || typed.trimmingCharacters(in: .whitespaces).isEmpty)
                Button("Następne zdanie") {
                    index += 1
                    typed = ""
                    verdict = ""
                }
                .buttonStyle(.glass)
            }
            .padding()
        }
        .navigationTitle("Zdania")
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .onDisappear { Talk.stop() }
    }

    private func check() {
        let ok = Normalizer.same(typed, item.de) || Normalizer.clean(typed).contains(Normalizer.clean(item.de))
        verdict = ok ? "Dobrze. Tak się tego używa." : "Blisko albo inaczej. Porównaj z wersją poniżej i powiedz ją na głos."
    }

    private func ask() async {
        loading = true
        defer { loading = false }
        let prompt = """
        Uczeń miał powiedzieć po niemiecku zdanie: \(item.pl)
        Napisał: \(typed)
        Wzorzec: \(item.de)
        Daj najlepszą naturalną wersję i jedno zdanie po polsku, co poprawić.
        Format:
        DE: zdanie
        PL: wyjaśnienie
        """
        do {
            verdict = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś nauczycielem niemieckiego dla Polaka z budowy. Krótko.")
        } catch {
            verdict = error.localizedDescription
        }
    }
}

struct ClipView: View {
    @EnvironmentObject var store: LearningStore
    @State private var text = ""
    @State private var note = ""
    @State private var loading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Wklej transkrypcję z YouTube albo kawałek rozmowy. Wyciągnę z tego słówka do powtórek.")
                    .font(.footnote).foregroundStyle(.secondary)
                TextField("Tekst po niemiecku", text: $text, axis: .vertical)
                    .lineLimit(6...14)
                    .textFieldStyle(.roundedBorder)
                Button(loading ? "Czytam…" : "Wyciągnij słówka") { Task { await pull() } }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                    .disabled(loading || text.trimmingCharacters(in: .whitespacesAndNewlines).count < 12)
                if !note.isEmpty { Text(note).font(.footnote) }
            }
            .padding()
        }
        .navigationTitle("Z filmu")
        .scrollDismissesKeyboard(.interactively)
        .containerBackground(for: .navigation) { NightGlow() }
    }

    private func pull() async {
        loading = true
        note = ""
        defer { loading = false }
        let prompt = """
        Tekst:
        \(text.prefix(4000))
        Wyciągnij do 8 przydatnych zwrotów z tego tekstu, poziom A2, praca albo codzienność.
        Pomiń dzień dobry, dziękuję i liczby.
        JSON {"items":[{"de":"","pl":"","ex":"","exPl":"","topic":"Z filmu"}]}. Nic poza JSON.
        """
        do {
            let raw = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Odpowiadasz wyłącznie JSON-em.",
                json: true)
            let items = try WordJSON.decode(raw)
            let added = store.addWords(items.map {
                Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: "Z filmu", level: "A2")
            })
            note = added == 0 ? "Nic nowego. Te zwroty już masz." : "Doszło \(added) do powtórek."
        } catch {
            note = error.localizedDescription
        }
    }
}

struct WordsView: View {
    @EnvironmentObject var store: LearningStore
    @State private var query = ""
    @State private var band = "Wszystkie"
    @State private var deck = false

    private var filtered: [Word] {
        store.words.filter { word in
            let bandOK: Bool
            switch band {
            case "A1": bandOK = word.level == "A1"
            case "A2": bandOK = word.level == "A2"
            case "Powtórka": bandOK = (store.stats[word.de]?.due ?? .distantFuture) <= Date()
            default: bandOK = true
            }
            let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
            let textOK = q.isEmpty || word.de.localizedCaseInsensitiveContains(q) || word.pl.localizedCaseInsensitiveContains(q)
            return bandOK && textOK
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Szukaj słowa", text: $query)
                .textFieldStyle(.roundedBorder)
            Picker("Filtr", selection: $band) {
                Text("Wszystkie").tag("Wszystkie")
                Text("A1").tag("A1")
                Text("A2").tag("A2")
                Text("Powtórka").tag("Powtórka")
            }
            .pickerStyle(.segmented)
            HStack {
                Text("\(filtered.count) słówek").font(.footnote).foregroundStyle(Ink.muted)
                Spacer()
                Button("Fiszki") { deck = true }
                    .buttonStyle(.plain)
                    .foregroundStyle(Ink.accent)
                    .disabled(filtered.isEmpty)
            }
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filtered) { word in
                        HStack(spacing: 12) {
                            Button { Talk.de(word.de) } label: {
                                Image(systemName: "speaker.wave.2.fill").foregroundStyle(Ink.accent)
                            }
                            .buttonStyle(.plain)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(word.de).font(.headline)
                                Text(word.pl).font(.footnote).foregroundStyle(Ink.muted)
                            }
                            Spacer()
                            Image(systemName: (store.stats[word.de]?.box ?? 0) >= 4 ? "star.fill" : "star")
                                .foregroundStyle(Ink.accent.opacity((store.stats[word.de]?.box ?? 0) >= 4 ? 1 : 0.35))
                        }
                        .padding(12)
                        .liquidGlass(radius: 16)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Słówka")
        .containerBackground(for: .navigation) { NightGlow() }
        .fullScreenCover(isPresented: $deck) {
            FlashDeck(words: filtered)
        }
    }
}

struct FlashDeck: View {
    @EnvironmentObject var store: LearningStore
    @Environment(\.dismiss) private var dismiss
    let words: [Word]
    @State private var index = 0
    @State private var revealed = false

    private var word: Word? { words.isEmpty ? nil : words[index % words.count] }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button { dismiss() } label: { Image(systemName: "xmark") }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(min(index + 1, max(words.count, 1))) / \(words.count)")
                    .foregroundStyle(Ink.muted)
            }
            GeometryReader { geo in
                Capsule().fill(Color.white.opacity(0.08))
                    .overlay(alignment: .leading) {
                        Capsule().fill(Ink.accent)
                            .frame(width: words.isEmpty ? 0 : geo.size.width * CGFloat(index + 1) / CGFloat(words.count))
                    }
            }
            .frame(height: 4)
            Spacer()
            if let word {
                VStack(spacing: 12) {
                    Text(word.level).font(.caption).foregroundStyle(Ink.accent)
                    Text(word.de).font(.system(size: 36, weight: .bold)).multilineTextAlignment(.center)
                    Text(revealed ? word.pl : "Stuknij, żeby odwrócić")
                        .font(revealed ? .title3 : .footnote)
                        .foregroundStyle(revealed ? .white : Ink.muted)
                        .multilineTextAlignment(.center)
                }
                .padding(28)
                .frame(maxWidth: .infinity, minHeight: 280)
                .liquidGlass(radius: 28)
                .onTapGesture { revealed.toggle() }
            }
            Spacer()
            HStack(spacing: 28) {
                Button { grade(.hard) } label: {
                    Image(systemName: "xmark").font(.title2).frame(width: 64, height: 64)
                        .background(Ink.clay, in: Circle())
                }
                .buttonStyle(.plain)
                Button { if let word { Talk.de(word.de) } } label: {
                    Image(systemName: "speaker.wave.2").font(.title3).frame(width: 56, height: 56)
                        .background(Ink.card, in: Circle())
                }
                .buttonStyle(.plain)
                Button { grade(.easy) } label: {
                    Image(systemName: "checkmark").font(.title2).frame(width: 64, height: 64)
                        .background(Ink.pine, in: Circle())
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(.white)
        }
        .padding()
        .background(Ink.bg.ignoresSafeArea())
    }

    private func grade(_ g: Grade) {
        guard let word else { return }
        store.grade(word, g)
        revealed = false
        if index + 1 >= words.count { dismiss() } else { index += 1 }
    }
}
