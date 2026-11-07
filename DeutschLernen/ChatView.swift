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
                                Text(m.text)
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
        Jesteś cierpliwym nauczycielem niemieckiego dla Polaka na poziomie A1/A2, który uczy się niemieckiego do codziennego życia i pracy w Niemczech.
        Zasady:
        - Odpowiadaj prostym niemieckim (krótkie zdania, poziom A2), a pod spodem dodaj krótkie wyjaśnienie po polsku.
        - Jeśli użytkownik zrobi błąd, pokaż poprawną wersję i wyjaśnij w 1–2 zdaniach po polsku dlaczego.
        - Nie tłumacz bardzo prostych słów (powitania itp.). Wprowadzaj 2–3 nowe, przydatne słowa na odpowiedź.
        - Prowadź rozmowę dalej krótkim pytaniem po niemiecku.
        - Nie używaj markdownu ani gwiazdek.
        - Dopasuj temat i trudność do postępów ucznia:
        \(store.progressSummary())
        """
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
