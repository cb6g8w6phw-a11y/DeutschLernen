import SwiftUI

struct Scenario: Identifiable {
    let id: String
    let title: String
    let role: String
    let task: String
    let opener: String
}

enum Scenarios {
    static let all: [Scenario] = [
        Scenario(id: "lekarz", title: "Wizyta u lekarza", role: "lekarz",
                 task: "Od trzech dni boli cię gardło i ciężko oddychasz przez nos. Chcesz zwolnienie na jutrzejszą zmianę.",
                 opener: "Guten Tag. Was fehlt Ihnen denn?"),
        Scenario(id: "szef", title: "Spóźnienie do szefa", role: "szef zmiany",
                 task: "Spóźnisz się około 20 minut, bo autobus nie przyjechał. Powiedz to krótko i zapytaj, czy masz kogoś zastąpić.",
                 opener: "Wo bleiben Sie? Die Schicht hat schon angefangen."),
        Scenario(id: "magazyn", title: "Brak na palecie", role: "kolega z magazynu",
                 task: "Dwa kartony są uszkodzone i na liście brakuje jednej pozycji. Powiedz to i zapytaj, co wpisać.",
                 opener: "Na, stimmt die Palette? Ich brauche den Lieferschein."),
        Scenario(id: "sklep", title: "Wymiana w sklepie", role: "sprzedawca",
                 task: "Buty są za małe. Chcesz je wymienić i masz paragon.",
                 opener: "Kann ich Ihnen helfen?"),
        Scenario(id: "urzad", title: "Meldunek w urzędzie", role: "urzędnik",
                 task: "Chcesz się zameldować. Masz umowę najmu i dowód. Zapytaj, jakich dokumentów jeszcze brakuje.",
                 opener: "Bitte, was kann ich für Sie tun?"),
        Scenario(id: "audi", title: "Warsztat, Audi", role: "mechanik",
                 task: "Z przodu stuka zawieszenie. Chcesz wiedzieć, co to może być, ile kosztuje i kiedy auto będzie gotowe.",
                 opener: "Was macht das Auto? Seit wann ist das Geräusch da?"),
        Scenario(id: "budowa", title: "Rozmowa na budowie", role: "kierownik budowy",
                 task: "Brakuje materiału do dzisiejszej roboty. Zapytaj, czy czekać, czy wziąć się za inną pracę.",
                 opener: "Warum steht ihr rum? Das Material sollte da sein."),
        Scenario(id: "klima", title: "Odbiór montażu", role: "klient",
                 task: "Montaż klimatyzacji przesunie się o dwie godziny, bo brakuje części. Przeproś i zapytaj o dostęp do skrzynki elektrycznej.",
                 opener: "Ich warte schon. Wann fangen Sie an?"),
        Scenario(id: "wypadek", title: "Stłuczka na parkingu", role: "drugi kierowca",
                 task: "Lekko stuknęliście się na parkingu. Nikt nie jest ranny. Chcesz wymienić dane i zrobić zdjęcia.",
                 opener: "Haben Sie das nicht gesehen? Mein Stoßfänger ist kaputt."),
        Scenario(id: "mieszkanie", title: "Awaria u wynajmującego", role: "wynajmujący",
                 task: "Ogrzewanie nie działa od wczoraj. Poproś o naprawę jeszcze dziś.",
                 opener: "Ja, hallo? Was gibt es denn?")
    ]
}

struct ScenesView: View {
    @EnvironmentObject var store: LearningStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Po kolei. Poprzednia scena musi mieć choć jedną gwiazdkę, żeby otworzyć następną.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundStyle(Theme.text2)
                    NavigationLink {
                        ChatView()
                    } label: {
                        row("Wolna rozmowa", "Piszesz, o czym chcesz. Bez scenariusza.", stars: nil, locked: false)
                    }
                    ForEach(Array(Scenarios.all.enumerated()), id: \.element.id) { index, s in
                        let open = store.sceneUnlocked(index)
                        if open {
                            NavigationLink {
                                SceneChatView(scenario: s)
                            } label: {
                                row(s.title, s.task, stars: store.stars(for: s.id), locked: false)
                            }
                        } else {
                            row(s.title, "Najpierw zalicz poprzednią scenę.", stars: 0, locked: true)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 24)
            }
            .navigationTitle("Sceny")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private func row(_ title: String, _ text: String, stars: Int?, locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.text)
                Spacer()
                if locked {
                    Image(systemName: "lock.fill").foregroundStyle(Theme.text2)
                } else if let stars {
                    Text(String(repeating: "★", count: stars) + String(repeating: "☆", count: 3 - stars))
                        .foregroundStyle(Theme.orange)
                }
            }
            Text(text)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Theme.text2)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .themedCard(radius: 20)
        .opacity(locked ? 0.45 : 1)
    }
}

struct SceneChatView: View {
    @EnvironmentObject var store: LearningStore
    let scenario: Scenario
    @StateObject private var mic = Mic()
    @State private var messages: [ChatMsg] = []
    @State private var input = ""
    @State private var loading = false
    @State private var started = false
    @State private var showStars = false
    @State private var earned = 1
    @State private var openPL: Set<UUID> = []
    @State private var popped = false
    @State private var showVoices = false
    @AppStorage("deVoice") private var deVoice = ""
    @ObservedObject private var speaker = Speaker.shared

    var body: some View {
        VStack(spacing: 0) {
            Text(scenario.task)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        personCard
                        ForEach(messages) { m in
                            VStack(alignment: m.role == "user" ? .trailing : .leading, spacing: 6) {
                                Text(m.text)
                                    .padding(14)
                                    .liquidGlass(radius: 22, tint: m.role == "user" ? Ink.brass.opacity(0.45) : nil)
                                if m.role == "model" {
                                    HStack(spacing: 16) {
                                        Button { Talk.de(m.text) } label: {
                                            Image(systemName: "speaker.wave.2")
                                                .frame(width: 44, height: 44)
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(Theme.accent)
                                        Button { Task { await reveal(m) } } label: {
                                            Label(openPL.contains(m.id) ? "Ukryj" : "Tłumaczenie", systemImage: "character.book.closed")
                                                .font(.subheadline.weight(.semibold))
                                                .frame(minHeight: 44)
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(Theme.accent)
                                    }
                                    if openPL.contains(m.id) {
                                        Text(m.polish.isEmpty ? "Tłumaczę…" : m.polish)
                                            .font(.subheadline)
                                            .foregroundStyle(Theme.text2)
                                            .padding(12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .themedCard(radius: 16)
                                    }
                                    if !m.fix.isEmpty {
                                        Text(m.fix)
                                            .font(.footnote)
                                            .foregroundStyle(Theme.orange)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: m.role == "user" ? .trailing : .leading)
                            .id(m.id)
                        }
                        if loading { ProgressView().padding() }
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            HStack(spacing: 8) {
                TextField("Po niemiecku…", text: $input, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                Button { mic.toggle() } label: {
                    Image(systemName: mic.listening ? "stop.fill" : "mic.fill")
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.glass)
                Button { Task { await help() } } label: {
                    Image(systemName: "questionmark")
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.glass)
                .disabled(loading)
                Button { Task { await send() } } label: {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
                .disabled(loading || input.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(10)
            .liquidGlass(radius: 28, interactive: true)
            .padding(.horizontal)
            .padding(.bottom, 8)
            if !mic.text.isEmpty || !mic.note.isEmpty {
                Text(mic.note.isEmpty ? mic.text : mic.note)
                    .font(.footnote)
                    .padding(.horizontal)
                Text("Mikrofon słucha niemieckiego. Po polsku wpisz palcem, rozmowa i tak pójdzie dalej.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Button("Wstaw to, co usłyszałem") { input = mic.text; mic.stop() }
                    .buttonStyle(.glass)
                    .padding(.bottom, 6)
            }
        }
        .navigationTitle(scenario.title)
        .navigationBarTitleDisplayMode(.inline)
        .containerBackground(for: .navigation) { NightGlow() }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Zamknij") { Keyboard.hide() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Gwiazdki") { finishScene() }
            }
        }
        .onAppear {
            guard !started else { return }
            started = true
            messages = [ChatMsg(role: "model", text: scenario.opener)]
            withAnimation(.spring(duration: 0.45)) { popped = true }
            Talk.de(scenario.opener)
        }
        .onDisappear { mic.stop(); Talk.stop() }
        .onChange(of: mic.listening) { was, now in
            if was, !now, !mic.text.isEmpty { input = mic.text }
        }
        .sheet(isPresented: $showVoices) { sceneVoices }
        .alert("Scena zaliczona", isPresented: $showStars) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(earned) z 3 gwiazdek. Jedna gwiazdka otwiera następną scenę. Trzy gwiazdki to scena bez potknięć.")
        }
    }

    private func finishScene() {
        let mine = messages.filter { $0.role == "user" }.count
        let fixes = messages.filter { $0.role == "model" && $0.text.lowercased().contains("popraw") }.count
        let stars: Int
        if mine >= 3 && fixes == 0 { stars = 3 }
        else if mine >= 2 { stars = 2 }
        else { stars = 1 }
        store.awardStars(scenario.id, stars)
        earned = store.stars(for: scenario.id)
        showStars = true
    }

    private func systemPrompt() -> String {
        """
        Jesteś żywym człowiekiem i grasz rolę: \(scenario.role). To rozmowa, nie lekcja i nie tłumacz.
        Scena: \(scenario.title).
        Cel ucznia, nie zdradzaj gotowca: \(scenario.task).
        \(Learner.line)
        Jak uczeń napisze po polsku, zrozum o co chodzi i odpowiedz dalej po niemiecku. Nigdy nie oddawaj jego zdania jako swojej kwestii i nie tłumacz mu tego, co sam właśnie powiedział.
        Przykład. Uczeń: Na nodze mam zaczerwienienie od kleszcza.
        Źle: DE: Was genau ist an Ihrer Nase rot, und haben Sie einen Zeckenstich?
        Dobrze: DE: Ein Zeckenstich am Bein. Seit wann ist die Stelle rot? Haben Sie Fieber?
        PL: Ukąszenie kleszcza na nodze. Od kiedy to miejsce jest czerwone? Ma pan gorączkę?
        Zasady:
        - Jedna albo dwie krótkie kwestie jak w prawdziwej rozmowie. Na końcu jedno nowe pytanie, które wynika z tego, co usłyszałeś.
        - Nie powtarzaj poprzedniego pytania, jeśli uczeń już na nie odpowiedział.
        - Format, każda rzecz w osobnej linii, bez markdownu:
        DE: tylko twoja nowa kwestia po niemiecku
        PL: polskie tłumaczenie tej kwestii, nie zdania ucznia
        ERR: po polsku co było nie tak | poprawne zdanie
        ERR tylko gdy uczeń mówił po niemiecku i pomylił formę. Jak pisał po polsku, nie poprawiaj, tylko prowadź rozmowę.
        Postępy: \(store.progressSummary())
        """
    }

    private func send() async {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        input = ""
        Keyboard.hide()
        mic.stop()
        messages.append(ChatMsg(role: "user", text: text))
        loading = true
        defer { loading = false }
        do {
            let history = messages.map { message in
                GeminiMessage(role: message.role, text: message.role == "user" ? forModel(message.text) : message.text)
            }
            let reply = try await Gemini.send(messages: history, system: systemPrompt())
            let turn = splitReply(reply)
            messages.append(turn)
            let mine = messages.filter { $0.role == "user" }.count
            if mine >= 2 { store.markScene(scenario.id) }
            Talk.de(turn.text)
        } catch {
            messages.append(ChatMsg(role: "model", text: error.localizedDescription))
        }
    }

    private func help() async {
        loading = true
        defer { loading = false }
        let prompt = """
        Uczeń utknął w scenie „\(scenario.title)”. Zadanie: \(scenario.task).
        Ostatnia wypowiedź drugiej strony: \(messages.last(where: { $0.role == "model" })?.text ?? scenario.opener).
        Podaj 3 krótkie zdania po niemiecku, których może użyć. Pod każdym zdaniem tłumaczenie po polsku.
        Bez markdownu.
        """
        do {
            let reply = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś nauczycielem niemieckiego. Dajesz tylko 3 gotowe zdania.")
            messages.append(ChatMsg(role: "model", text: "Pomoc:\n\(reply)"))
        } catch {
            messages.append(ChatMsg(role: "model", text: error.localizedDescription))
        }
    }

    private func reveal(_ m: ChatMsg) async {
        if openPL.contains(m.id) {
            openPL.remove(m.id)
            return
        }
        openPL.insert(m.id)
        guard m.polish.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        do {
            let pl = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: m.text)],
                system: "Przetłumacz na polski. Oddaj tylko tłumaczenie, bez cudzysłowu i bez komentarza.")
            if let i = messages.firstIndex(where: { $0.id == m.id }) {
                messages[i].polish = pl.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            if let i = messages.firstIndex(where: { $0.id == m.id }) {
                messages[i].polish = "Nie udało się przetłumaczyć. Sprawdź klucz w Ustawieniach."
            }
        }
    }

    private func splitReply(_ raw: String) -> ChatMsg {
        var de = ""
        var pl = ""
        var fix = ""
        for line in raw.components(separatedBy: .newlines) {
            let t = line.trimmingCharacters(in: .whitespaces)
            guard !t.isEmpty else { continue }
            let up = t.uppercased()
            if up.hasPrefix("DE:") { de = join(de, String(t.dropFirst(3))) }
            else if up.hasPrefix("PL:") { pl = join(pl, String(t.dropFirst(3))) }
            else if up.hasPrefix("ERR:") { fix = String(t.dropFirst(4)).trimmingCharacters(in: .whitespaces) }
            else if up == "OK" { continue }
            else if t.range(of: "[ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]", options: .regularExpression) != nil { pl = join(pl, t) }
            else { de = join(de, t) }
        }
        if de.isEmpty { de = raw.trimmingCharacters(in: .whitespacesAndNewlines) }
        return ChatMsg(role: "model", text: de, polish: pl, fix: fix)
    }

    private func join(_ base: String, _ extra: String) -> String {
        let piece = extra.trimmingCharacters(in: .whitespaces)
        return base.isEmpty ? piece : base + " " + piece
    }

    private func firstGerman(_ text: String) -> String {
        text.split(separator: "\n").map(String.init).first { line in
            let t = line.trimmingCharacters(in: .whitespaces)
            return !t.isEmpty && !t.hasPrefix("OK") && !t.lowercased().contains("popraw")
        } ?? text
    }

    private func forModel(_ text: String) -> String {
        let polish = text.range(of: "[ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]", options: .regularExpression) != nil
        guard polish else { return text }
        return "Uczeń powiedział po polsku. Zrozum sens i prowadź rozmowę dalej. Nie tłumacz tego zdania i nie powtarzaj go. Treść: \(text)"
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
                            .padding(24)
                            .foregroundStyle(.white)
                            .background(Theme.accent)
                    }
                }
                .frame(width: 132, height: 168)
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
            .scaleEffect(popped ? 1 : 0.55)
            .opacity(popped ? 1 : 0)
            Button { showVoices = true } label: {
                Label(Talk.germanVoices().first { $0.identifier == deVoice }?.name ?? "Głos", systemImage: "waveform")
                    .font(.caption.weight(.semibold))
                    .frame(minHeight: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.text2)
            PaceButtons()
        }
    }

    private var sceneVoices: some View {
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
            }
            .navigationTitle("Głos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { Button("Zamknij") { showVoices = false } }
        }
        .presentationDetents([.medium, .large])
    }
}
