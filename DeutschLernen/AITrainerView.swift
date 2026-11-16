import SwiftUI

struct TrainScene: Identifiable, Hashable {
    let id: String
    let title: String
    let tags: String
    let who: String
    let de: String
    let pl: String
    let chips: [String]

    static let list: [TrainScene] = [
        TrainScene(
            id: "amt",
            title: "Anmeldung w Bürgeramt",
            tags: "Bürgeramt, Termin, Wohnungsgeberbestätigung",
            who: "Jesteś urzędnikiem w urzędzie meldunkowym. Uczeń chce się zameldować.",
            de: "Guten Tag! Willkommen im Bürgeramt. Sie möchten sich anmelden, richtig? Haben Sie heute einen Termin? Wenn ja, zeigen Sie mir bitte Ihren Ausweis und die Wohnungsgeberbestätigung.",
            pl: "Dzień dobry! Witamy w urzędzie meldunkowym. Chciałby się pan zameldować, zgadza się? Czy ma pan dziś umówioną wizytę? Jeśli tak, proszę pokazać dowód i potwierdzenie od wynajmującego.",
            chips: ["Ich habe einen Termin.", "Hier ist mein Ausweis.", "Ich habe die Bestätigung."]),
        TrainScene(
            id: "chef",
            title: "Rozmowa z szefem",
            tags: "Baustelle, Verspätung, Schicht",
            who: "Jesteś szefem na budowie. Mówisz krótko i konkretnie.",
            de: "Morgen. Du kommst spät. Was ist passiert?",
            pl: "Dzień dobry. Spóźniasz się. Co się stało?",
            chips: ["Der Bus kam nicht.", "Entschuldigung, ich bin da.", "Ich kann gleich anfangen."]),
        TrainScene(
            id: "arzt",
            title: "Wizyta u lekarza",
            tags: "Arzt, Hals, Krankschreibung",
            who: "Jesteś lekarzem. Pytasz o objawy i zwolnienie.",
            de: "Guten Tag. Was fehlt Ihnen denn?",
            pl: "Dzień dobry. Co panu dolega?",
            chips: ["Mir tut der Hals weh.", "Ich brauche eine Krankschreibung.", "Seit gestern."]),
        TrainScene(
            id: "laden",
            title: "W sklepie",
            tags: "Laden, Brot, Karte",
            who: "Jesteś sprzedawcą. Uczeń chce kupić chleb i zapłacić kartą.",
            de: "Guten Tag. Kann ich Ihnen helfen?",
            pl: "Dzień dobry. W czym mogę pomóc?",
            chips: ["Ich möchte ein Brot.", "Kann ich mit Karte zahlen?", "Haben Sie Milch?"]),
        TrainScene(
            id: "wohnung",
            title: "Awaria w mieszkaniu",
            tags: "Heizung, Vermieter, Wohnung",
            who: "Jesteś wynajmującym. Uczeń dzwoni, bo ogrzewanie nie działa.",
            de: "Ja, hallo? Was gibt es denn?",
            pl: "Tak, halo? O co chodzi?",
            chips: ["Die Heizung geht nicht.", "Die Wohnung ist kalt.", "Können Sie heute kommen?"])
    ]
}

struct TrainLine: Identifiable {
    let id = UUID()
    let mine: Bool
    var de: String
    var pl: String
}

struct AITrainerView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var scene = TrainScene.list[0]
    @State private var lines: [TrainLine] = []
    @State private var chips: [String] = []
    @State private var input = ""
    @State private var loading = false
    @State private var showPL = true
    @State private var pickScene = false
    @State private var errorText = ""
    @State private var started = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            banner
                            ForEach(lines) { line in
                                bubble(line).id(line.id)
                            }
                            if loading { ProgressView().tint(Theme.ok) }
                            if !errorText.isEmpty {
                                Text(errorText).font(.footnote).foregroundStyle(Theme.text2)
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 8)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: lines.count) { _, _ in
                        if let last = lines.last { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                chipRow
                composer
            }
            .background(Color.black)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $pickScene) { sceneList }
            .onAppear {
                mic.arm("de-DE")
                guard !started else { return }
                started = true
                begin(scene)
            }
            .onChange(of: mic.listening) { was, now in
                if was && !now { flushMic() }
            }
            .onDisappear {
                mic.stop()
                Talk.stop()
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button { pickScene = true } label: {
                Label("Scenki", systemImage: "rectangle.3.group")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.ok)
            Spacer()
            Text("AI Trener").font(.headline)
            Spacer()
            Button { showPL.toggle() } label: {
                Text(showPL ? "PL" : "DE")
                    .font(.subheadline.weight(.bold))
                    .padding(.horizontal, 12)
                    .frame(minHeight: 36)
                    .background(Theme.ok.opacity(0.2), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.ok)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var banner: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Role-Play: \(scene.title)").font(.subheadline.weight(.bold))
                Text(scene.tags).font(.caption).foregroundStyle(Theme.text2)
            }
            Spacer()
            Button("Zakończ") { begin(scene) }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.ok)
        }
    }

    private func bubble(_ line: TrainLine) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(line.de).font(.body)
            if showPL, !line.pl.isEmpty, !line.mine {
                Divider().overlay(Color.white.opacity(0.12))
                Text(line.pl).font(.subheadline).foregroundStyle(Theme.text2)
            }
            if !line.mine {
                Button { Talk.de(line.de, rate: 0.46) } label: {
                    Label("Posłuchaj", systemImage: "speaker.wave.2")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ok)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(line.mine ? 0.1 : 0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    Button(chip) { Task { await send(chip) } }
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 40)
                        .background(Color.white.opacity(0.08), in: Capsule())
                        .foregroundStyle(.white)
                        .disabled(loading)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }

    private var composer: some View {
        HStack(spacing: 8) {
            Button { mic.toggle() } label: {
                Image(systemName: mic.listening ? "stop.fill" : "mic.fill")
                    .font(.title3)
                    .frame(width: 48, height: 48)
                    .background(mic.listening ? Color.red.opacity(0.85) : Theme.ok, in: Circle())
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            TextField(mic.listening ? "Słucham…" : "Napisz albo mów po niemiecku", text: $input, axis: .vertical)
                .lineLimit(1...3)
                .textFieldStyle(.roundedBorder)
            Button { Task { await send(input) } } label: {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .frame(width: 44, height: 44)
                    .background(Theme.ok, in: Circle())
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            .disabled(loading || input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var sceneList: some View {
        NavigationStack {
            List(TrainScene.list) { item in
                Button {
                    scene = item
                    begin(item)
                    pickScene = false
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title).foregroundStyle(.white)
                        Text(item.tags).font(.caption).foregroundStyle(Theme.text2)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Scenki")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zamknij") { pickScene = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func begin(_ item: TrainScene) {
        errorText = ""
        chips = item.chips
        lines = [TrainLine(mine: false, de: item.de, pl: item.pl)]
        Talk.de(item.de, rate: 0.46)
    }

    private func flushMic() {
        let said = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
        mic.text = ""
        guard !said.isEmpty else { return }
        Task { await send(said) }
    }

    private func send(_ raw: String) async {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !loading else { return }
        input = ""
        Keyboard.hide()
        if mic.listening { mic.stop() }
        lines.append(TrainLine(mine: true, de: text, pl: ""))
        loading = true
        errorText = ""
        defer { loading = false }
        let history = lines.map { GeminiMessage(role: $0.mine ? "user" : "model", text: $0.de) }
        do {
            let reply = try await Gemini.send(messages: history, system: prompt(), route: .geminiFirst)
            let parsed = Self.split(reply)
            lines.append(TrainLine(mine: false, de: parsed.de, pl: parsed.pl))
            if !parsed.chips.isEmpty { chips = parsed.chips }
            store.noteSkill("speak", ok: true)
            Talk.de(parsed.de, rate: 0.46)
        } catch {
            errorText = error.localizedDescription
        }
    }

    private func prompt() -> String {
        """
        \(scene.who)
        Uczeń jest Polakiem, poziom A1. Rozmawiaj tylko w tej scence. Nie zmieniaj miejsca.
        Odpowiedz dokładnie w tym formacie, bez markdownu:
        DE: dwa krótkie zdania po niemiecku i jedno pytanie.
        PL: dokładne polskie tłumaczenie części DE.
        A: krótkie niemieckie zdanie, którym uczeń może odpowiedzieć
        B: drugie takie zdanie
        C: trzecie takie zdanie
        Jak uczeń zrobi błąd, w PL dopisz jednym zdaniem poprawkę.
        Postęp: \(store.progressSummary())
        """
    }

    private static func split(_ raw: String) -> (de: String, pl: String, chips: [String]) {
        let text = raw.replacingOccurrences(of: "*", with: "")
        func grab(_ name: String) -> String {
            guard let start = text.range(of: name) else { return "" }
            let rest = text[start.upperBound...]
            let stops = ["DE:", "PL:", "A:", "B:", "C:"].filter { $0 != name }
            var cut = rest.endIndex
            for stop in stops {
                if let found = rest.range(of: stop) { cut = min(cut, found.lowerBound) }
            }
            return rest[..<cut].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let de = grab("DE:")
        let pl = grab("PL:")
        let chips = [grab("A:"), grab("B:"), grab("C:")].filter { !$0.isEmpty }
        if de.isEmpty {
            return (text.trimmingCharacters(in: .whitespacesAndNewlines), "", [])
        }
        return (de, pl, chips)
    }
}
