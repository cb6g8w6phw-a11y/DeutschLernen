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
                        ForEach(messages) { m in
                            VStack(alignment: m.role == "user" ? .trailing : .leading, spacing: 6) {
                                Text(m.text)
                                    .padding(14)
                                    .liquidGlass(radius: 22, tint: m.role == "user" ? Ink.brass.opacity(0.45) : nil)
                                if m.role == "model" {
                                    Button { Talk.de(m.text) } label: {
                                        Image(systemName: "speaker.wave.2")
                                    }
                                    .buttonStyle(.glass)
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
        }
        .onDisappear { mic.stop(); Talk.stop() }
        .onChange(of: mic.text) { _, new in
            if mic.listening, !new.isEmpty { input = new }
        }
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
        Jesteś Niemcem i grasz rolę: \(scenario.role).
        Scena: \(scenario.title).
        Zadanie ucznia (nie zdradzaj mu gotowej odpowiedzi, dopóki nie poprosi o pomoc): \(scenario.task).
        \(Learner.line)
        Zasady:
        - Odpowiadaj krótko po niemiecku, poziom A2, maksymalnie 3 zdania.
        - Pod spodem jedna linia po polsku: korekta błędu ucznia albo „OK”.
        - Prowadź rozmowę dalej jednym pytaniem.
        - Nie używaj markdownu ani gwiazdek.
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
            let history = messages.map { GeminiMessage(role: $0.role, text: $0.text) }
            let reply = try await Gemini.send(messages: history, system: systemPrompt())
            messages.append(ChatMsg(role: "model", text: reply))
            let mine = messages.filter { $0.role == "user" }.count
            if mine >= 2 { store.markScene(scenario.id) }
            Talk.de(firstGerman(reply))
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

    private func firstGerman(_ text: String) -> String {
        text.split(separator: "\n").map(String.init).first { line in
            let t = line.trimmingCharacters(in: .whitespaces)
            return !t.isEmpty && !t.hasPrefix("OK") && !t.lowercased().contains("popraw")
        } ?? text
    }
}
