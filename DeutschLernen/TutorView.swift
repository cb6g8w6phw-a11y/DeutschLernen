import SwiftUI

private struct Turn: Identifiable {
    let id = UUID()
    let role: String
    var german: String
    var polish: String
    var say: String = ""
    var err: String = ""
    var flag: String = ""
}

struct TutorView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var turns: [Turn] = []
    @State private var loading = false
    @State private var hint = ""
    @State private var note = ""
    @State private var typed = ""
    @State private var showType = false
    @State private var greeted = false
    @State private var quiet: Task<Void, Never>?
    @State private var tick = Date()
    @AppStorage("persona") private var persona = "Marek"

    private let people = ["Marek", "Lena", "Piotr", "Kierownik", "Sklep", "Telefon", "Lekarz", "Agencja"]
    private var blind: Bool { persona == "Telefon" || persona == "Agencja" }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if mic.listening {
                    listenStage
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                peopleRow
                                ForEach(turns) { t in
                                    bubble(t).id(t.id)
                                }
                                if loading { ProgressView().padding() }
                                if !note.isEmpty {
                                    Text(note).font(.footnote).foregroundStyle(Ink.muted).padding(.horizontal)
                                }
                            }
                            .padding()
                        }
                        .scrollDismissesKeyboard(.interactively)
                        .onChange(of: turns.count) { _, _ in
                            if let last = turns.last { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                controls
            }
            .navigationTitle(persona)
            .navigationBarTitleDisplayMode(.inline)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink("Pismo") { ChatView() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Podsumuj") { Task { await summarize() } }
                        .disabled(loading || turns.count < 2)
                }
            }
            .onAppear {
                guard !greeted else { return }
                greeted = true
                turns = [opener]
            }
            .onDisappear {
                tickTalk()
                mic.stop()
                Talk.stop()
            }
            .onChange(of: persona) { _, _ in
                if !turns.contains(where: { $0.role == "user" }) {
                    turns = [opener]
                }
            }
            .onChange(of: mic.listening) { was, now in
                if was, !now { flushMic() }
            }
            .onChange(of: mic.text) { _, new in
                quiet?.cancel()
                let spoken = new.trimmingCharacters(in: .whitespacesAndNewlines)
                guard mic.listening, spoken.count > 1 else { return }
                quiet = Task {
                    try? await Task.sleep(nanoseconds: 1_200_000_000)
                    guard !Task.isCancelled, mic.listening, mic.text == new else { return }
                    mic.stop()
                }
            }
            .sheet(isPresented: $showType) {
                NavigationStack {
                    VStack(spacing: 12) {
                        TextField("Po niemiecku albo po polsku", text: $typed, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .liquidGlass(radius: 18)
                        Button("Wyślij") {
                            let t = typed
                            typed = ""
                            showType = false
                            Task { await send(t) }
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Ink.brass)
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Napisz")
                    .toolbar { Button("Zamknij") { showType = false } }
                }
                .presentationDetents([.medium])
            }
        }
    }

    private var peopleRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(people, id: \.self) { name in
                    Button(name) { persona = name }
                        .font(.subheadline.weight(persona == name ? .bold : .regular))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(persona == name ? Ink.accent : Ink.card, in: Capsule())
                        .foregroundStyle(persona == name ? Color.black : Color.white)
                }
            }
        }
    }

    private var listenStage: some View {
        VStack(spacing: 22) {
            Text("Słucham…")
                .font(.subheadline)
                .foregroundStyle(Ink.muted)
            ZStack {
                Circle()
                    .stroke(Ink.accent.opacity(0.18), lineWidth: 22)
                    .frame(width: 250, height: 250)
                Circle()
                    .stroke(Ink.accent.opacity(0.35), lineWidth: 10)
                    .frame(width: 210, height: 210)
                Circle()
                    .fill(Ink.accent)
                    .frame(width: 168, height: 168)
                Image(systemName: "waveform")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(.black)
            }
            Text(mic.text.isEmpty ? "Mów po niemiecku" : mic.text)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            if !mic.note.isEmpty {
                Text(mic.note).font(.caption).foregroundStyle(Ink.muted).multilineTextAlignment(.center).padding(.horizontal)
            }
            Spacer()
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func bubble(_ t: Turn) -> some View {
        HStack {
            if t.role == "user" { Spacer(minLength: 48) }
            VStack(alignment: .leading, spacing: 6) {
                if t.role == "model" {
                    HStack(spacing: 6) {
                        Text(persona).font(.caption).foregroundStyle(Ink.muted)
                        if t.flag == "fix" {
                            Image(systemName: "checkmark")
                            Text("Poprawka")
                        } else if t.flag == "ok" {
                            Image(systemName: "checkmark")
                            Text("Dobrze")
                        }
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(t.flag == "fix" ? Ink.pine : Ink.accent)
                }
                Text(t.german).font(.body)
                if !t.polish.isEmpty {
                    Text(t.polish).font(.footnote).foregroundStyle(Ink.muted)
                }
                if !t.err.isEmpty {
                    Text(t.err).font(.footnote).foregroundStyle(Ink.pine)
                }
                if !t.say.isEmpty, !blind {
                    Text("Powiedz: \(t.say)").font(.footnote.weight(.semibold))
                }
                if t.role == "model" {
                    Button { Talk.de(speech(t)) } label: {
                        Image(systemName: "speaker.wave.2").foregroundStyle(Ink.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
            .background(t.role == "user" ? Ink.accent.opacity(0.22) : Ink.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(alignment: .leading) {
                if t.role == "model" {
                    Capsule()
                        .fill(t.flag == "fix" ? Ink.pine : Ink.accent)
                        .frame(width: 3)
                        .padding(.vertical, 12)
                }
            }
            if t.role == "model" { Spacer(minLength: 48) }
        }
    }

    private var controls: some View {
        VStack(spacing: 8) {
            if !hint.isEmpty, !blind {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Możesz powiedzieć").font(.caption).foregroundStyle(.secondary)
                    ForEach(germanHints, id: \.self) { line in
                        Button(line) { Task { await send(line) } }
                            .buttonStyle(.glass)
                    }
                }
            }
            if !mic.note.isEmpty { Text(mic.note).font(.caption).foregroundStyle(.secondary) }
            if mic.listening {
                Text(mic.text.isEmpty ? "Słucham…" : mic.text).font(.footnote)
            }
            if !blind {
                Button("Nie znam odpowiedzi") { Task { await send("Nie znam odpowiedzi. Daj jedną podpowiedź po polsku i krótkie zdanie, które mam teraz powiedzieć.") } }
                    .buttonStyle(.glass)
                    .disabled(loading)
            }
            HStack(spacing: 16) {
                Button { showType = true } label: {
                    Image(systemName: "plus")
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.06), in: Circle())
                }
                .buttonStyle(.plain)
                WaveBars(on: mic.listening)
                    .frame(maxWidth: .infinity)
                Button { mic.toggle() } label: {
                    Image(systemName: mic.listening ? "stop.fill" : "mic.fill")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .frame(width: 58, height: 58)
                        .background(Ink.accent, in: Circle())
                }
                .buttonStyle(.plain)
                .disabled(loading)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Circle().fill(mic.listening ? Ink.pine : Ink.muted).frame(width: 6, height: 6)
                        Text(mic.listening ? "Na żywo" : "Mikrofon")
                            .font(.caption2)
                            .foregroundStyle(mic.listening ? Ink.pine : Ink.muted)
                    }
                    Text(mic.listening ? "Stuknij, koniec" : "Stuknij i mów")
                        .font(.caption)
                }
                if !blind {
                    Button { Task { await suggest() } } label: {
                        Image(systemName: "lightbulb")
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.06), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(loading)
                }
            }
            .padding(12)
            .liquidGlass(radius: 28)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    private func speech(_ t: Turn) -> String {
        if blind || t.say.isEmpty { return t.german }
        return "\(t.german) Sag jetzt: \(t.say)"
    }

    private func flushMic() {
        let text = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        mic.text = ""
        Task { await send(text) }
    }

    private func send(_ raw: String) async {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !loading else { return }
        Keyboard.hide()
        turns.append(Turn(role: "user", german: text, polish: ""))
        if isEnd(text) {
            await summarize()
            return
        }
        loading = true
        defer { loading = false }
        let history = turns.map { GeminiMessage(role: $0.role, text: $0.role == "user" ? $0.german : packed($0)) }
        do {
            let reply = try await Gemini.send(messages: history, system: systemPrompt())
            let turn = parse(reply)
            if !turn.err.isEmpty { store.addMistake(turn.err) }
            turns.append(turn)
            tickTalk()
            Talk.de(speech(turn))
        } catch {
            turns.append(Turn(role: "model", german: error.localizedDescription, polish: ""))
        }
    }

    private func suggest() async {
        loading = true
        defer { loading = false }
        let last = turns.last(where: { $0.role == "model" })?.german ?? ""
        let prompt = """
        Uczeń utknął. Ostatnia kwestia nauczyciela: \(last)
        Podaj 3 krótkie zdania po niemiecku (B1, praca albo codzienność), którymi może odpowiedzieć.
        Pod każdym zdaniem jedna linia po polsku. Bez markdownu.
        """
        do {
            hint = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Podajesz tylko 3 gotowe zdania i tłumaczenia.")
        } catch {
            hint = error.localizedDescription
        }
    }

    private func summarize() async {
        loading = true
        note = "Wyciągam zwroty z rozmowy…"
        defer { loading = false }
        let log = turns.map { t in
            t.role == "user" ? "Uczeń: \(t.german)" : "Nauczyciel: \(t.german) | \(t.polish)"
        }.joined(separator: "\n")
        let prompt = """
        To jest cała rozmowa:
        \(log)
        Wyciągnij od 5 do 10 najważniejszych zwrotów.
        Zwróć JSON {"items":[{"de":"","pl":"","ex":"","exPl":"","topic":"Z rozmowy"}]}. Nic poza JSON.
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Odpowiadasz wyłącznie JSON-em.",
                json: true)
            let items = try WordJSON.decode(text)
            let words = items.prefix(10).map {
                Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: "Z rozmowy", level: "A2")
            }
            let added = store.addWords(Array(words))
            store.markScene(persona)
            let list = words.map { "\($0.de) – \($0.pl)" }.joined(separator: "\n")
            note = "Do Nauki doszło \(added). Razem w bazie: \(store.words.count)."
            turns.append(Turn(
                role: "model",
                german: "Koniec sesji. Te zwroty są już w fiszkach.",
                polish: list))
        } catch {
            note = error.localizedDescription
        }
    }

    private func isEnd(_ text: String) -> Bool {
        let t = text.lowercased()
        return t.contains("koniec sesj") || t.contains("podsumuj rozmow")
    }

    private func packed(_ t: Turn) -> String {
        "DE: \(t.german)\nPL: \(t.polish)\nSAY: \(t.say)"
    }

    private func parse(_ text: String) -> Turn {
        let de = field(text, "DE")
        let pl = field(text, "PL")
        let say = field(text, "SAY")
        if de.isEmpty {
            return Turn(role: "model", german: text.trimmingCharacters(in: .whitespacesAndNewlines), polish: "")
        }
        let err = field(text, "ERR")
        let flag = err.isEmpty ? "ok" : "fix"
        return Turn(role: "model", german: de, polish: pl, say: say, err: err, flag: flag)
    }

    private func field(_ text: String, _ name: String) -> String {
        var hit = false
        var lines: [String] = []
        for raw in text.components(separatedBy: .newlines) {
            let t = raw.trimmingCharacters(in: .whitespaces)
            if t.uppercased().hasPrefix(name + ":") {
                hit = true
                lines = [String(t.dropFirst(name.count + 1)).trimmingCharacters(in: .whitespaces)]
                continue
            }
            if hit {
                let up = t.uppercased()
                if up.hasPrefix("DE:") || up.hasPrefix("PL:") || up.hasPrefix("SAY:") || up.hasPrefix("ERR:") { break }
                if !t.isEmpty { lines.append(t) }
            }
        }
        return lines.joined(separator: " ")
    }

    private var germanHints: [String] {
        hint.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { line in
                line.count > 2 && !line.contains(where: { "ąęśćźżńłóĄĘŚĆŹŻŃŁÓ".contains($0) })
            }
    }

    private var opener: Turn {
        switch persona {
        case "Lena":
            return Turn(role: "model", german: "Na, wie war dein Tag bisher?", polish: "No i jak ci minął dzień do tej pory?", say: "Ganz okay, ich komme gerade von der Arbeit.")
        case "Piotr":
            return Turn(role: "model", german: "Was ist mit dem Auto? Hörst du ein Geräusch?", polish: "Co z autem? Słyszysz jakiś dźwięk?", say: "Vorne klopft es, wenn ich über ein Schlagloch fahre.")
        case "Kierownik":
            return Turn(role: "model", german: "Kacper, wann kannst du morgen mit der Arbeit anfangen?", polish: "Kacper, kiedy możesz jutro zacząć pracę?", say: "Ich kann morgen um sechs Uhr anfangen.")
        case "Sklep":
            return Turn(role: "model", german: "Kann ich Ihnen helfen?", polish: "W czym mogę pomóc?", say: "Ich möchte das umtauschen. Ich habe den Bon.")
        case "Telefon":
            return Turn(role: "model", german: "Hallo? Spreche ich mit Kacper? Hier ist der Vermieter.", polish: "Halo? Czy to Kacper? Tu wynajmujący.", say: "Ja, hier ist Kacper. Die Heizung geht nicht.")
        case "Lekarz":
            return Turn(role: "model", german: "Guten Tag. Was fehlt Ihnen denn?", polish: "Dzień dobry. Co panu dolega?", say: "Mir tut der Hals weh und ich brauche eine Krankschreibung.")
        case "Agencja":
            return Turn(role: "model", german: "Guten Tag, hier ist die Zeitarbeitsfirma. Können Sie morgen anfangen?", polish: "Dzień dobry, tu agencja pracy. Może pan jutro zacząć?", say: "Ja, ich kann morgen um sechs Uhr anfangen.")
        default:
            return Turn(role: "model", german: "Na, was machst du heute auf der Baustelle?", polish: "No i co dzisiaj robisz na budowie?", say: "Ich montiere heute die Klimaanlage.")
        }
    }

    private func systemPrompt() -> String {
        let who: String
        switch persona {
        case "Lena":
            who = "Masz na imię Lena. Jesteś koleżanką z codziennego życia w Niemczech: urząd, sklep, mieszkanie, lekarz. Mówisz spokojnie i konkretnie."
        case "Piotr":
            who = "Masz na imię Piotr. Jesteś mechanikiem w warsztacie. Mówisz krótko, po ludzku, o aucie, częściach i terminie."
        case "Kierownik":
            who = "Jesteś kierownikiem budowy. Wydajesz krótkie, jasne polecenia. Mówisz prostym niemieckim, poziom A2."
        case "Sklep":
            who = "Jesteś sprzedawcą w sklepie w Niemczech. Mówisz uprzejmie i krótko."
        case "Telefon":
            who = "Dzwonisz do ucznia. To rozmowa telefoniczna bez podpowiedzi na ekranie, które zdradzałyby odpowiedź wcześniej. Mówisz jak prawdziwy rozmówca: wynajmujący, kierownik albo urząd."
        case "Lekarz":
            who = "Jesteś lekarzem. Pytasz krótko o objawy i o to, czy potrzebuje zwolnienia."
        case "Agencja":
            who = "Dzwonisz z agencji pracy. Pytasz o termin, doświadczenie i czy może zacząć jutro."
        default:
            who = "Masz na imię Marek. Pracujesz na budowie i przy montażu w Niemczech. Gadasz jak kolega na zmianie, nie jak nauczyciel."
        }
        return """
        \(who)
        Rozmówca jest Polakiem i chce mówić po niemiecku jak z żywym człowiekiem, poziom około B1, praca i codzienność.
        Zasady:
        - Odpowiadaj tak, jakbyś stał obok niego. Jedno albo dwa krótkie zdania. Potem pytanie.
        - Nie wykładaj gramatyki i nie pisz list.
        - Jak powie coś krzywo, w PL daj jedną krótką poprawkę po polsku i dodaj linię ERR. Jak jest dobrze, w PL przetłumacz tylko to, co sam powiedziałeś, i NIE dodawaj ERR.
        - Jak napisze po polsku, że nie zna odpowiedzi, daj jedną podpowiedź w PL i jedno krótkie zdanie w SAY. Nie wykładaj.
        - SAY to jedno naturalne zdanie, które on może teraz powiedzieć.
        Format, bez markdownu:
        DE: po niemiecku
        PL: po polsku
        SAY: zdanie dla niego
        ERR: krótki błąd po polsku | poprawne zdanie
        ERR tylko wtedy, gdy uczeń powiedział coś źle.
        Postępy: \(store.progressSummary())
        """
    }

    private func tickTalk() {
        let seconds = Int(Date().timeIntervalSince(tick))
        tick = Date()
        if seconds > 2 { store.addTalk(seconds) }
    }
}

struct WaveBars: View {
    var on: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.08, paused: !on)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            HStack(alignment: .center, spacing: 3) {
                ForEach(0..<8, id: \.self) { index in
                    Capsule()
                        .fill(Ink.accent.opacity(on ? 0.95 : 0.28))
                        .frame(width: 4, height: on ? 8 + 18 * abs(sin(time * 5 + Double(index) * 0.7)) : 8)
                }
            }
            .frame(height: 28)
        }
    }
}
