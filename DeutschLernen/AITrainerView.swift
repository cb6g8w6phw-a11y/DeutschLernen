import SwiftUI

struct TrainScene: Identifiable, Hashable {
    let id: String
    let title: String
    let group: String
    let level: String
    let minutes: Int
    let icon: String
    let tags: String
    let who: String
    let de: String
    let pl: String
    let chips: [String]

    static let filters = ["Wszystkie", "Urzędy (Amt)", "Mieszkanie", "Praca", "Zdrowie", "Zakupy", "Komunikacja"]

    static let list: [TrainScene] = [
        TrainScene(
            id: "amt", title: "Anmeldung w Bürgeramt", group: "Urzędy (Amt)", level: "A2/B1", minutes: 5, icon: "building.columns",
            tags: "Bürgeramt, Termin, Wohnungsgeberbestätigung",
            who: "Jesteś urzędnikiem w urzędzie meldunkowym. Uczeń chce się zameldować.",
            de: "Guten Tag! Willkommen im Bürgeramt. Sie möchten sich anmelden, richtig? Haben Sie heute einen Termin?",
            pl: "Dzień dobry! Witamy w urzędzie meldunkowym. Chce się pan zameldować, zgadza się? Czy ma pan dziś umówioną wizytę?",
            chips: ["Ich habe einen Termin.", "Hier ist mein Ausweis.", "Ich habe die Bestätigung."]),
        TrainScene(
            id: "blick", title: "Oglądanie mieszkania (Besichtigung)", group: "Mieszkanie", level: "B1", minutes: 6, icon: "house",
            tags: "Besichtigung, Miete, Kaution",
            who: "Jesteś wynajmującym i oprowadzasz ucznia po mieszkaniu.",
            de: "Guten Tag. Das ist die Wohnung. Die Küche ist hier, das Bad ist rechts. Haben Sie Fragen zur Miete?",
            pl: "Dzień dobry. To jest mieszkanie. Kuchnia jest tutaj, łazienka po prawej. Ma pan pytania o czynsz?",
            chips: ["Wie hoch ist die Miete?", "Ist die Heizung neu?", "Wann kann ich einziehen?"]),
        TrainScene(
            id: "arzt", title: "Wizyta u lekarza (Hausarzt)", group: "Zdrowie", level: "A2", minutes: 4, icon: "cross.case",
            tags: "Hausarzt, Hals, Krankschreibung",
            who: "Jesteś lekarzem rodzinnym. Pytasz o objawy.",
            de: "Guten Tag. Was fehlt Ihnen denn?",
            pl: "Dzień dobry. Co panu dolega?",
            chips: ["Mir tut der Hals weh.", "Ich brauche eine Krankschreibung.", "Seit gestern."]),
        TrainScene(
            id: "job", title: "Rozmowa w pracy i Krankmeldung", group: "Praca", level: "B1/B2", minutes: 5, icon: "briefcase",
            tags: "Arbeit, Krankmeldung, Schicht",
            who: "Jesteś szefem. Uczeń jest chory i musi zgłosić nieobecność.",
            de: "Guten Morgen. Du bist heute nicht auf der Baustelle. Was ist los?",
            pl: "Dzień dobry. Nie ma cię dziś na budowie. Co się dzieje?",
            chips: ["Ich bin krank.", "Ich schicke die Krankmeldung.", "Ich kann morgen nicht kommen."]),
        TrainScene(
            id: "pfand", title: "Zakupy, Pfand i reklamacja", group: "Zakupy", level: "A2", minutes: 4, icon: "bag",
            tags: "Pfand, Bon, Reklamation",
            who: "Jesteś kasjerem. Uczeń chce oddać kaucję za butelki albo zareklamować towar.",
            de: "Guten Tag. Möchten Sie den Pfand abgeben oder etwas umtauschen?",
            pl: "Dzień dobry. Chce pan oddać butelki na kaucję czy coś wymienić?",
            chips: ["Ich möchte den Pfand abgeben.", "Das Brot ist schlecht.", "Hier ist der Bon."]),
        TrainScene(
            id: "bahn", title: "Deutsche Bahn i opóźnienie pociągu", group: "Komunikacja", level: "B1", minutes: 4, icon: "tram",
            tags: "Bahn, Verspätung, Gleis",
            who: "Jesteś pracownikiem kolei. Pociąg ucznia jest opóźniony.",
            de: "Der Zug nach Hamburg hat zwanzig Minuten Verspätung. Kann ich Ihnen helfen?",
            pl: "Pociąg do Hamburga ma dwadzieścia minut opóźnienia. Mogę w czymś pomóc?",
            chips: ["Von welchem Gleis fährt er?", "Muss ich ein neues Ticket kaufen?", "Wo ist der nächste Zug?"]),
        TrainScene(
            id: "chef", title: "Spóźnienie na budowę", group: "Praca", level: "A2", minutes: 4, icon: "hammer",
            tags: "Baustelle, Bus, Chef",
            who: "Jesteś szefem na budowie. Uczeń się spóźnia, bo nie było autobusu.",
            de: "Du kommst spät. Was ist passiert?",
            pl: "Spóźniasz się. Co się stało?",
            chips: ["Der Bus kam nicht.", "Entschuldigung, ich bin da.", "Ich kann gleich anfangen."]),
        TrainScene(
            id: "heizung", title: "Ogrzewanie nie działa", group: "Mieszkanie", level: "A2", minutes: 4, icon: "thermometer.medium",
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
    @State private var filter = "Wszystkie"

    private var shown: [TrainScene] {
        if filter == "Wszystkie" { return TrainScene.list }
        return TrainScene.list.filter { $0.group == filter }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Realne sytuacje · Poziom A2–B2")
                        .font(.subheadline)
                        .foregroundStyle(Theme.text2)
                    Text("Życie w Niemczech")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(TrainScene.filters, id: \.self) { name in
                                Button(name) { filter = name }
                                    .font(.subheadline.weight(.semibold))
                                    .padding(.horizontal, 14)
                                    .frame(minHeight: 36)
                                    .background(filter == name ? Theme.ok : Color.white.opacity(0.08), in: Capsule())
                                    .foregroundStyle(filter == name ? Color.black : Color.white)
                            }
                        }
                    }
                    VStack(spacing: 0) {
                        ForEach(shown) { item in
                            NavigationLink {
                                TrainerChat(scene: item)
                            } label: {
                                sceneRow(item)
                            }
                            .buttonStyle(.plain)
                            if item.id != shown.last?.id {
                                Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 72)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
                .padding(16)
                .padding(.bottom, 28)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func sceneRow(_ item: TrainScene) -> some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.ok)
                .frame(width: 44, height: 44)
                .background(Theme.ok.opacity(0.14), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                Text("\(item.group) · \(item.level) · \(item.minutes) min")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct TrainerChat: View {
    @EnvironmentObject var store: LearningStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var mic = Mic()
    let scene: TrainScene
    @State private var lines: [TrainLine] = []
    @State private var chips: [String] = []
    @State private var input = ""
    @State private var loading = false
    @State private var showPL = true
    @State private var errorText = ""
    @State private var started = false

    var body: some View {
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            mic.arm("de-DE")
            guard !started else { return }
            started = true
            begin()
        }
        .onChange(of: mic.listening) { was, now in
            if was && !now { flushMic() }
        }
        .onDisappear {
            mic.stop()
            Talk.stop()
        }
    }

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.ok)
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
        .padding(.top, 8)
    }

    private var banner: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Role-Play: \(scene.title)").font(.subheadline.weight(.bold))
                Text(scene.tags).font(.caption).foregroundStyle(Theme.text2)
            }
            Spacer()
            Button("Zakończ") { begin() }
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

    private func begin() {
        errorText = ""
        chips = scene.chips
        lines = [TrainLine(mine: false, de: scene.de, pl: scene.pl)]
        Talk.de(scene.de, rate: 0.46)
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
