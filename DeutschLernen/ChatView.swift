import SwiftUI

struct ChatMsg: Identifiable {
    let id = UUID()
    let role: String   // "user" / "model"
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
                        LazyVStack(alignment: .leading, spacing: 10) {
                            if messages.isEmpty {
                                Text("Napisz coś po niemiecku (albo po polsku). Poprawię błędy i dopasuję rozmowę do twoich postępów. Np.: „Chcę umówić wizytę u lekarza.”")
                                    .foregroundStyle(.secondary).padding()
                            }
                            ForEach(messages) { m in
                                Text(m.text)
                                    .padding(10)
                                    .background(m.role == "user" ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.15),
                                                in: RoundedRectangle(cornerRadius: 12))
                                    .frame(maxWidth: .infinity, alignment: m.role == "user" ? .trailing : .leading)
                                    .id(m.id)
                            }
                            if loading { ProgressView().padding() }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                HStack {
                    TextField("Wiadomość…", text: $input, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)
                    Button { Task { await send() } } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(loading || input.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Czat AI")
            .toolbar {
                Button("Wyczyść") { messages = [] }
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
        - Dopasuj temat i trudność do postępów ucznia:
        \(store.progressSummary())
        """
    }

    private func send() async {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        input = ""
        messages.append(ChatMsg(role: "user", text: text))
        loading = true
        defer { loading = false }
        do {
            let history = messages.map { GeminiMessage(role: $0.role, text: $0.text) }
            let reply = try await Gemini.send(messages: history, system: systemPrompt())
            messages.append(ChatMsg(role: "model", text: reply))
        } catch {
            messages.append(ChatMsg(role: "model", text: "⚠️ \(error.localizedDescription)"))
        }
    }
}
