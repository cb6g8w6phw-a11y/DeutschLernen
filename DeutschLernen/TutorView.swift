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

struct TalkLaunch: Hashable {
    var id: String
    var title: String
    var who: String
    var de: String
    var pl: String
    var say: String
}

struct TutorView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var turns: [Turn] = []
    @State private var loading = false
    @State private var chatError: String?
    @State private var hint = ""
    @State private var note = ""
    @State private var typed = ""
    @State private var showType = false
    @State private var greeted = false
    @State private var quiet: Task<Void, Never>?
    @State private var openPL: Set<UUID> = []
    @State private var tick = Date()
    @AppStorage("persona") private var persona = "Marek"
    @AppStorage("deVoice") private var deVoice = ""
    @ObservedObject private var speaker = Speaker.shared
    @State private var popped = false
    @State private var showVoices = false
    var launch: TalkLaunch? = nil

    private let people = ["Marek", "Lena", "Piotr", "Kierownik", "Sklep", "Telefon", "Lekarz", "Agencja"]
    private var blind: Bool { persona == "Telefon" || persona == "Agencja" }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            HStack(alignment: .top, spacing: 12) {
                                personCard
                                Spacer(minLength: 24)
                            }
                            if launch == nil { peopleRow }
                            ForEach(turns) { t in
                                bubble(t).id(t.id)
                            }
                            if !hint.isEmpty {
                                Text(hint)
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(Theme.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(14)
                                    .background(Theme.card2, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                            Button { Task { await suggest() } } label: {
                                Label("Co powiedzieć?", systemImage: "lightbulb.fill")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Theme.accent, in: Capsule())
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .disabled(loading || blind)
                            if let say = turns.last(where: { $0.role == "model" && !$0.say.isEmpty })?.say, !blind {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Twoje zadanie")
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundStyle(Theme.text2)
                                    Text("Powiedz: \(say)")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Theme.text)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Theme.card2, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                            }
                            if loading { LoadingDots().padding(.vertical, 6) }
                            if let chatError {
                                ErrorRetry(text: chatError) {
                                    self.chatError = nil
                                    Task { await retryLast() }
                                }
                            }
                            if !note.isEmpty {
                                Text(note).font(.footnote).foregroundStyle(Theme.text2)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: turns.count) { _, _ in
                        if let last = turns.last { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                controls
            }
            .overlay {
                if mic.wantsPrompt {
                    ZStack {
                        Color.black.opacity(0.55).ignoresSafeArea()
                        micAsk
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink("Pismo") { ChatView() }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text(launch?.title ?? persona).font(.system(size: 17, weight: .bold, design: .rounded))
                        Text("Scena, praca").font(.system(size: 12, design: .rounded)).foregroundStyle(Theme.text2)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Podsumuj") { Task { await summarize() } }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .disabled(loading || turns.count < 2)
                }
            }
            .onAppear {
                guard !greeted else { return }
                greeted = true
                turns = [opener]
                withAnimation(.spring(duration: 0.45)) { popped = true }
                Talk.de(speech(opener))
            }
            .onDisappear {
                tickTalk()
                mic.stop()
                Talk.stop()
            }
            .onChange(of: persona) { _, _ in
                if !turns.contains(where: { $0.role == "user" }) {
                    turns = [opener]
                    Talk.de(speech(opener))
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
            .sheet(isPresented: $showVoices) { voiceSheet }
        }
    }

    private var personCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let ui = UIImage(named: "Tutor") {
                        Image(uiImage: ui).resizable().scaledToFill()
                    } else {
                        Image(systemName: "person.crop.square.fill")
                            .resizable()
                            .padding(28)
                            .foregroundStyle(.white)
                            .background(Theme.accent)
                    }
                }
                .frame(width: 148, height: 188)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(speaker.speaking ? Theme.accent : Color.white.opacity(0.2), lineWidth: speaker.speaking ? 3 : 1))
                if speaker.speaking {
                    Text("mówi")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.55), in: Capsule())
                        .padding(8)
                }
            }
            .scaleEffect(popped ? (speaker.speaking ? 1.04 : 1) : 0.55)
            .opacity(popped ? 1 : 0)
            .animation(.spring(duration: 0.45), value: popped)
            .animation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true), value: speaker.speaking)
            Button { showVoices = true } label: {
                Label(voiceTitle, systemImage: "waveform")
                    .font(.caption.weight(.semibold))
                    .frame(minHeight: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.text2)
        }
    }

    private var voiceTitle: String {
        Talk.germanVoices().first { $0.identifier == deVoice }?.name ?? "Głos"
    }

    private var voiceSheet: some View {
        NavigationStack {
            List {
                Button {
                    deVoice = ""
                    showVoices = false
                    Talk.de("Hallo, ich bin da.")
                } label: {
                    HStack {
                        Text("Automatycznie, najlepszy dostępny")
                        Spacer()
                        if deVoice.isEmpty { Image(systemName: "checkmark") }
                    }
                }
                ForEach(Talk.germanVoices(), id: \.identifier) { voice in
                    Button {
                        deVoice = voice.identifier
                        showVoices = false
                        Talk.de("Hallo, so klinge ich.", voice: voice.identifier)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(voice.name)
                                Text(Talk.qualityName(voice)).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if deVoice == voice.identifier { Image(systemName: "checkmark") }
                        }
                    }
                }
                Text("Naturalny głos ściągasz na iPhonie: Ustawienia, Dostępność, Treść mówiona, Głosy, Niemiecki. Potem wróć tutaj i wybierz ten z dopiskiem naturalny.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Głos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { Button("Zamknij") { showVoices = false } }
        }
        .presentationDetents([.medium, .large])
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
        VStack(spacing: 18) {
            Text(mic.note.isEmpty ? "Słucham…" : mic.note)
                .font(.subheadline)
                .foregroundStyle(Ink.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            ZStack {
                Circle()
                    .stroke(Ink.accent.opacity(0.22), lineWidth: 18)
                    .frame(width: 230, height: 230)
                    .scaleEffect(1 + mic.level * 1.4)
                Circle()
                    .fill(Ink.accent)
                    .frame(width: 150, height: 150)
                Image(systemName: "waveform")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .animation(.easeOut(duration: 0.15), value: mic.level)
            Text(mic.text.isEmpty ? "Mów po niemiecku" : mic.text)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            Capsule()
                .fill(Ink.accent)
                .frame(width: max(12, 160 * mic.level * 8), height: 6)
            Spacer()
        }
        .padding(.top, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Ink.bg)
    }

    private func bubble(_ t: Turn) -> some View {
        HStack {
            if t.role == "user" { Spacer(minLength: 48) }
            if t.role == "model" { TutorAvatar(size: 36) }
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
                Text(t.german)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.text)
                HStack(spacing: 16) {
                    Button { Talk.de(speech(t)) } label: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .buttonStyle(.plain)
                    Button { Task { await reveal(t) } } label: {
                        Image(systemName: openPL.contains(t.id) ? "character.book.closed.fill" : "character.book.closed")
                    }
                    .buttonStyle(.plain)
                }
                .font(.body)
                .foregroundStyle(Theme.accent)
                if openPL.contains(t.id) {
                    Text(String(repeating: "· ", count: 16))
                        .font(.caption2)
                        .foregroundStyle(Theme.text2.opacity(0.7))
                        .lineLimit(1)
                    Text(t.polish.isEmpty ? "Tłumaczę…" : t.polish)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(Theme.text2)
                }
                if !t.err.isEmpty {
                    Text(t.err).font(.footnote).foregroundStyle(Ink.pine)
                }
                if !t.say.isEmpty, !blind, openPL.contains(t.id) {
                    Text("Powiedz: \(t.say)").font(.footnote.weight(.semibold))
                }
            }
            .padding(16)
            .background(t.role == "user" ? Theme.accent.opacity(0.35) : Theme.card2, in: UnevenRoundedRectangle(topLeadingRadius: 24, bottomLeadingRadius: t.role == "model" ? 8 : 24, bottomTrailingRadius: 24, topTrailingRadius: 24, style: .continuous))
            if t.role == "model" { Spacer(minLength: 36) }
        }
    }

    private var tutorFace: some View {
        TutorAvatar(size: 56)
    }

    private func reveal(_ t: Turn) async {
        if openPL.contains(t.id) {
            openPL.remove(t.id)
            return
        }
        openPL.insert(t.id)
        guard t.polish.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        do {
            let pl = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: t.german)],
                system: "Przetłumacz na polski. Oddaj tylko tłumaczenie, bez cudzysłowu i bez komentarza.")
            if let i = turns.firstIndex(where: { $0.id == t.id }) {
                turns[i].polish = pl.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            if let i = turns.firstIndex(where: { $0.id == t.id }) {
                turns[i].polish = "Nie udało się przetłumaczyć. Sprawdź klucz w Ustawieniach."
            }
        }
    }

    private var micAsk: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Czy włączyć mikrofon?").font(.title3.bold())
            Text(mic.note.isEmpty ? mic.permissionLine() : mic.note)
                .font(.body)
            Text("Na oknie iPhone'a może być napisane LiveContainer, nie Deutsch. Stuknij Pozwól. Jak okno się nie pojawi, decyzja jest już zapisana.")
                .font(.footnote)
                .foregroundStyle(Ink.muted)
            Button("Zapytaj iPhone'a") { mic.allowPrompt() }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
            Button("Nie teraz") { mic.wantsPrompt = false }
                .buttonStyle(.glass)
        }
        .padding(18)
        .liquidGlass(radius: 22)
        .padding(.horizontal, 20)
    }

    private var controls: some View {
        VStack(spacing: 8) {
            Text(mic.listening ? (mic.text.isEmpty ? "Słucham…" : mic.text) : (mic.note.isEmpty ? " " : mic.note))
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Theme.text2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
            HStack(spacing: 18) {
                Button { showType = true } label: {
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.text)
                Spacer(minLength: 0)
                Button { mic.toggle() } label: {
                    ZStack {
                        Circle()
                            .stroke(Theme.accent.opacity(0.28), lineWidth: 10)
                            .frame(width: 118, height: 118)
                        Circle()
                            .stroke(Theme.orange.opacity(0.22), lineWidth: 8)
                            .frame(width: 104, height: 104)
                        Circle()
                            .fill(Theme.gradient)
                            .frame(width: 96, height: 96)
                        Image(systemName: mic.listening ? "stop.fill" : "mic.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Theme.ink)
                    }
                    .frame(width: 120, height: 120)
                }
                .buttonStyle(.plain)
                .disabled(loading)
                Spacer(minLength: 0)
                NavigationLink { WordsView() } label: {
                    Image(systemName: "book.closed")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.text)
                        .frame(width: 44, height: 44)
                        .background(Circle().stroke(Theme.accent.opacity(0.45), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)
            Text(mic.listening ? "Stuknij, koniec" : "Stuknij i mów po niemiecku")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Theme.text2)
                .lineLimit(1)
            if !hint.isEmpty, !blind {
                Text(germanHints.first ?? "")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
                    .lineLimit(1)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity)
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
            chatError = "Nie udało się dostać odpowiedzi. Sprawdź sieć albo klucz."
        }
    }

    private func retryLast() async {
        guard let last = turns.last(where: { $0.role == "user" })?.german else { return }
        if turns.last?.role == "user" { turns.removeLast() }
        await send(last)
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
        if let launch {
            return Turn(role: "model", german: launch.de, polish: launch.pl, say: launch.say)
        }
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
        if let launch {
            who = launch.who
        } else {
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
        }
        return """
        \(who)
        Rozmówca jest Polakiem i chce mówić po niemiecku jak z żywym człowiekiem, poziom około B1, praca i codzienność.
        \(Learner.line)
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
