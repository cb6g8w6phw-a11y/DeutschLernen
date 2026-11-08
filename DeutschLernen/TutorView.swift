import SwiftUI

private struct Turn: Identifiable {
    let id = UUID()
    let role: String
    var german: String
    var polish: String
    var say: String = ""
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
    @AppStorage("persona") private var persona = "Marek"

    private let purple = Color(red: 0.48, green: 0.32, blue: 0.92)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            avatar
                            ForEach(turns) { t in
                                bubble(t).id(t.id)
                            }
                            if loading { ProgressView().padding() }
                            if !note.isEmpty {
                                Text(note).font(.footnote).foregroundStyle(.secondary).padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: turns.count) { _, _ in
                        if let last = turns.last { proxy.scrollTo(last.id, anchor: .bottom) }
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
            .onDisappear { mic.stop(); Talk.stop() }
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

    private var avatar: some View {
        VStack(spacing: 8) {
            if let img = UIImage(named: "Tutor") {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            Text("\(persona) gada z tobą jak człowiek. Mówisz, on odpowiada na głos. Jak zamilkniesz, zdanie samo idzie. Pod spodem jest sens po polsku.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Picker("Kto", selection: $persona) {
                Text("Marek").tag("Marek")
                Text("Lena").tag("Lena")
                Text("Piotr").tag("Piotr")
            }
            .pickerStyle(.segmented)
        }
    }

    private func bubble(_ t: Turn) -> some View {
        VStack(alignment: t.role == "user" ? .trailing : .leading, spacing: 6) {
            Text(t.german)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(t.role == "user" ? purple : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .frame(maxWidth: .infinity, alignment: t.role == "user" ? .trailing : .leading)
            if t.role == "model" {
                VStack(alignment: .leading, spacing: 8) {
                    if !t.polish.isEmpty { Text(t.polish).foregroundStyle(.secondary) }
                    if !t.say.isEmpty { Text("Powiedz teraz: „\(t.say)”").fontWeight(.semibold) }
                    HStack {
                        Button { Talk.de(speech(t)) } label: { Image(systemName: "speaker.wave.2") }
                            .buttonStyle(.plain)
                    }
                }
                .font(.subheadline)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var controls: some View {
        VStack(spacing: 8) {
            if !hint.isEmpty {
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
            HStack(spacing: 16) {
                Button { showType = true } label: {
                    Image(systemName: "plus")
                        .frame(width: 52, height: 52)
                        .background(Color.white.opacity(0.08), in: Circle())
                }
                .buttonStyle(.plain)
                Button { mic.toggle() } label: {
                    Image(systemName: mic.listening ? "stop.fill" : "mic.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 72)
                        .background(purple, in: Circle())
                }
                .buttonStyle(.plain)
                .disabled(loading)
                Button { Task { await suggest() } } label: {
                    Label("Co powiedzieć?", systemImage: "lightbulb.fill")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(purple.opacity(0.85), in: Capsule())
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(loading)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    private func speech(_ t: Turn) -> String {
        t.say.isEmpty ? t.german : "\(t.german) Sag jetzt: \(t.say)"
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
            turns.append(turn)
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
        return Turn(role: "model", german: de, polish: pl, say: say)
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
                if up.hasPrefix("DE:") || up.hasPrefix("PL:") || up.hasPrefix("SAY:") { break }
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
        default:
            who = "Masz na imię Marek. Pracujesz na budowie i przy montażu w Niemczech. Gadasz jak kolega na zmianie, nie jak nauczyciel."
        }
        return """
        \(who)
        Rozmówca jest Polakiem i chce mówić po niemiecku jak z żywym człowiekiem, poziom około B1, praca i codzienność.
        Zasady:
        - Odpowiadaj tak, jakbyś stał obok niego. Jedno albo dwa krótkie zdania. Potem pytanie.
        - Nie wykładaj gramatyki i nie pisz list.
        - Jak powie coś krzywo, w PL daj jedną krótką poprawkę po polsku. Jak jest dobrze, w PL przetłumacz tylko to, co sam powiedziałeś.
        - SAY to jedno naturalne zdanie, które on może teraz powiedzieć.
        Format, dokładnie trzy linie, bez markdownu:
        DE: po niemiecku
        PL: po polsku
        SAY: zdanie dla niego
        Postępy: \(store.progressSummary())
        """
    }
}
