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
        ListenQ(de: "Kacper, hol bitte die Schaufel und komm zur Baustelle.", question: "Co masz zrobić?", options: ["Przynieść łopatę i przyjść na budowę", "Zostać w aucie", "Iść do lekarza"], answer: 0),
        ListenQ(de: "Wir fangen morgen um sechs Uhr an.", question: "O której zaczynacie?", options: ["O ósmej", "O szóstej", "W południe"], answer: 1),
        ListenQ(de: "Mach das Loch achtzig Zentimeter tief.", question: "Jak głęboki ma być dół?", options: ["40 cm", "80 cm", "2 metry"], answer: 1),
        ListenQ(de: "Pass auf, hier ist ein Kabel.", question: "O co chodzi?", options: ["Uważaj, tu jest kabel", "Weź drabinę", "Idź na przerwę"], answer: 0),
        ListenQ(de: "Die Lieferung kommt erst um zehn.", question: "Kiedy jest dostawa?", options: ["O siódmej", "Już stoi", "Dopiero o dziesiątej"], answer: 2),
        ListenQ(de: "Kannst du den Transporter alleine beladen?", question: "O co pyta?", options: ["Czy sam załadujesz busa", "Czy masz prawo jazdy na busa", "Czy bus jest zepsuty"], answer: 0),
        ListenQ(de: "Ich bin krank und komme heute nicht.", question: "Co mówi pracownik?", options: ["Jest chory i dziś nie przyjdzie", "Spóźni się 10 minut", "Skończył robotę"], answer: 0),
        ListenQ(de: "Der Chef sagt, dass du morgen um sieben Uhr anfangen sollst.", question: "O której masz zacząć?", options: ["O 6:00", "O 7:00", "O 9:00"], answer: 1)
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
                    Text("Dzień \(store.planDay) z 30")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Ink.brass)
                    Text(store.phaseTitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    goal
                    if let word = store.wordOfDay { wordCard(word) }
                    Text("Plan na dziś")
                        .font(.headline)
                    NavigationLink { QuizView(sessionSize: 10) } label: { row("Powtórki", "10 min · słówka, które już czas przypomnieć", "rectangle.stack") }
                    NavigationLink { TutorView() } label: { row("Rozmowa", "15 min · mówisz, dostajesz krótką poprawkę", "waveform") }
                    NavigationLink { ListenView() } label: { row("Słuchanie", "10 min · wolno, normalnie albo szybko", "ear") }
                    NavigationLink { PronounceView() } label: { row("Wymowa", "10 min · powtarzasz zdanie na głos", "mic") }
                    NavigationLink { SentenceView() } label: { row("Zdania", "10 min · tłumaczysz sam, bez ściągi", "text.badge.checkmark") }
                    NavigationLink { QuizView(sessionSize: 5) } label: { row("Test", "5 min · pięć słówek na koniec", "checkmark.circle") }
                    NavigationLink { BuildView() } label: { row("Budowa", "Narzędzia, wymiary, polecenia kierownika", "hammer") }
                }
                .padding()
            }
            .navigationTitle("Dziś")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var goal: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Do powtórki dzisiaj: \(store.dueToday)")
                .font(.headline)
            let done = min(store.reviewsToday, 20)
            ProgressView(value: Double(done), total: 20)
                .tint(Ink.brass)
            Text("Dzisiejszy cel: \(done)/20 słówek")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 20)
    }

    private func wordCard(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Zdanie na dziś").font(.caption).foregroundStyle(.secondary)
            Text(word.de).font(.title3.bold())
            Text(word.pl).foregroundStyle(.secondary)
            Button { Talk.de(word.ex) } label: {
                Label(word.ex, systemImage: "speaker.wave.2")
            }
            .buttonStyle(.plain)
            .font(.footnote)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 20)
    }

    private func row(_ title: String, _ text: String, _ icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).frame(width: 28).foregroundStyle(Ink.brass)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(text).font(.footnote).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
        }
        .padding(14)
        .liquidGlass(radius: 20)
    }
}

struct ListenView: View {
    @EnvironmentObject var store: LearningStore
    @State private var index = 0
    @State private var speed: Float = 0.46
    @State private var voice = ""
    @State private var picked: Int?
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
                Text(item.question).font(.title3.bold())
                ForEach(item.options.indices, id: \.self) { i in
                    Button { choose(i) } label: {
                        Text(item.options[i]).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.glass)
                    .tint(color(i))
                }
                if picked != nil {
                    Text(item.de).font(.body.italic())
                    Button("Następne") {
                        picked = nil
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
                WrappingWords(parts: parts)
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

struct WrappingWords: View {
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
