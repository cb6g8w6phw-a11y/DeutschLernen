import SwiftUI

struct ChatMsg: Identifiable {
    let id = UUID()
    let role: String
    let text: String
}

struct ChatView: View {
    @EnvironmentObject var store: LearningStore
    @State private var messages: [ChatMsg] = []
    @State private var input = ""
    @State private var loading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            if messages.isEmpty {
                                Text("Napisz po niemiecku albo po polsku. Poprawię i dopasuję rozmowę do tego, co już umiesz. Na przykład: idę do lekarza, boli mnie nos.")
                                    .foregroundStyle(.secondary)
                                    .padding(16)
                                    .liquidGlass(radius: 22)
                            }
                            ForEach(messages) { m in
                                Text(Self.plain(m.text))
                                    .foregroundStyle(.primary)
                                    .padding(14)
                                    .liquidGlass(
                                        radius: 22,
                                        tint: m.role == "user" ? Ink.brass.opacity(0.45) : nil
                                    )
                                    .frame(maxWidth: .infinity, alignment: m.role == "user" ? .trailing : .leading)
                                    .id(m.id)
                            }
                            if loading {
                                Text("Łączę… jeśli klucz jest zły, za chwilę zobaczysz błąd.")
                                    .font(.footnote).foregroundStyle(.secondary)
                                ProgressView().padding()
                            }
                        }
                        .padding()
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: messages.count) { _, _ in
                        if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                HStack(spacing: 10) {
                    TextField("Wiadomość…", text: $input, axis: .vertical)
                        .lineLimit(1...4)
                        .submitLabel(.send)
                        .onSubmit { Task { await send() } }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                    Button { Keyboard.hide() } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.glass)
                    Button { Task { await send() } } label: {
                        Image(systemName: "paperplane.fill")
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                    .disabled(loading || input.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(10)
                .liquidGlass(radius: 28, interactive: true)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("Czat")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cofnij") { undo() }
                        .buttonStyle(.glass)
                        .disabled(messages.isEmpty || loading)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Wyczyść") { messages = [] }
                        .buttonStyle(.glass)
                        .disabled(messages.isEmpty)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Cofnij") { undo() }
                        .disabled(messages.isEmpty || loading)
                    Spacer()
                    Button("Zamknij") { Keyboard.hide() }
                }
            }
        }
    }

    private func systemPrompt() -> String {
        """
        Jesteś cierpliwym nauczycielem niemieckiego dla Polaka na poziomie A1/A2. Uczy się niemieckiego do codziennego życia i pracy w Niemczech.
        Każda odpowiedź ma DOKŁADNIE trzy części, w tej kolejności. Języków nie mieszaj.

        Po niemiecku:
        Cała odpowiedź tylko po niemiecku. Krótkie zdania, poziom A2. Na końcu jedno krótkie pytanie. Zero polskich słów, zero tłumaczeń w nawiasie, zero listy słówek.

        Po polsku:
        Dokładne tłumaczenie CAŁEGO tekstu z części „Po niemiecku”, tylko po polsku. Pytanie też przetłumacz. Ta część nigdy nie jest po niemiecku.

        Słówka:
        Dokładnie 2 albo 3 nowe, przydatne słowa. Każde w osobnej linii: niemieckie słowo — polskie znaczenie. Nic więcej.

        Zakazy:
        - Nie wstawiaj polskiego do części niemieckiej.
        - Nie pisz części „Po polsku” po niemiecku.
        - Nie używaj markdownu, gwiazdek ani pogrubień.
        - Jeśli użytkownik pisze po polsku, odpowiedz na treść po niemiecku, a pod spodem daj pełne polskie tłumaczenie tej odpowiedzi.
        - Jeśli użytkownik zrobi błąd po niemiecku, w części niemieckiej użyj poprawnej formy, a w części polskiej jednym zdaniem napisz, co było nie tak.

        Wzór:
        Po niemiecku:
        Du solltest einen Arzt aufsuchen. Der Arzt kann dir ein Medikament geben. Wie heißt dein Hausarzt?

        Po polsku:
        Powinieneś iść do lekarza. Lekarz może ci dać lek. Jak nazywa się twój lekarz rodzinny?

        Słówka:
        der Arzt — lekarz
        das Medikament — lek
        die Infektion — infekcja

        Dopasuj temat i trudność do postępów ucznia:
        \(store.progressSummary())
        """
    }

    private static func plain(_ text: String) -> String {
        text.replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "*", with: "")
    }

    private func send() async {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        input = ""
        Keyboard.hide()
        messages.append(ChatMsg(role: "user", text: text))
        loading = true
        defer { loading = false }
        do {
            let history = messages.map { GeminiMessage(role: $0.role, text: $0.text) }
            let reply = try await Gemini.send(messages: history, system: systemPrompt())
            messages.append(ChatMsg(role: "model", text: reply))
        } catch {
            messages.append(ChatMsg(role: "model", text: error.localizedDescription))
        }
    }

    private func undo() {
        guard !messages.isEmpty else { return }
        messages.removeLast()
        if messages.last?.role == "user" { messages.removeLast() }
    }
}
