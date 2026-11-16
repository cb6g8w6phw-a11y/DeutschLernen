import SwiftUI

struct ChatMsg: Identifiable {
    let id = UUID()
    let role: String
    var text: String
    var polish: String = ""
    var fix: String = ""
}

struct ChatWord: Identifiable {
    var id: String { de }
    let de: String
    let pl: String
}

struct ChatTopic: Identifiable {
    var id: String { title }
    let title: String
    let prompt: String
}

struct ChatView: View {
    @EnvironmentObject var store: LearningStore
    @Environment(\.dismiss) private var dismiss
    @State private var messages: [ChatMsg] = []
    @State private var input = ""
    @State private var loading = false
    @State private var saved: Set<String> = []

    private let topics: [ChatTopic] = [
        ChatTopic(title: "Sklep", prompt: "Zacznij krótką rozmowę w sklepie. Chcę kupić chleb i zapłacić kartą."),
        ChatTopic(title: "Lekarz", prompt: "Zacznij rozmowę u lekarza. Boli mnie gardło i potrzebuję zwolnienia."),
        ChatTopic(title: "Szef", prompt: "Zacznij rozmowę z szefem. Spóźnię się, bo autobus nie przyjechał."),
        ChatTopic(title: "Dojazd", prompt: "Zacznij rozmowę na przystanku. Nie wiem, który autobus jechać."),
        ChatTopic(title: "Urząd", prompt: "Zacznij rozmowę w urzędzie. Muszę umówić termin i mam dowód."),
        ChatTopic(title: "Mieszkanie", prompt: "Zacznij rozmowę z wynajmującym. Ogrzewanie nie działa."),
        ChatTopic(title: "Sąsiad", prompt: "Zacznij grzeczną rozmowę z sąsiadem. Jest za głośno."),
        ChatTopic(title: "Budowa", prompt: "Zacznij rozmowę na budowie. Szef kazał przynieść drabinę.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Rozmowa bez limitu w aplikacji. Piszesz po polsku albo po niemiecku, Gemini odpowiada krótkim niemieckim zdaniem, tłumaczeniem i słówkami.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.text2)
                        if Secret.load("geminiKey").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            NavigationLink { SettingsView() } label: {
                                Text("Wklej darmowy klucz Gemini w ustawieniach. Karta nie jest potrzebna. Bez klucza czat spróbuje Groq.")
                                    .font(.footnote)
                                    .foregroundStyle(Theme.ink)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Theme.ok, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(topics) { topic in
                                    Button(topic.title) { Task { await send(topic.prompt) } }
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 12)
                                        .frame(minHeight: 44)
                                        .background(Color.white.opacity(0.08), in: Capsule())
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        ForEach(messages) { message in
                            bubble(message).id(message.id)
                        }
                        if loading {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Gemini układa odpowiedź…").font(.footnote).foregroundStyle(Theme.text2)
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 12)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            HStack(spacing: 8) {
                TextField("Po polsku albo po niemiecku", text: $input, axis: .vertical)
                    .lineLimit(1...4)
                    .textFieldStyle(.roundedBorder)
                Button { Task { await send(input) } } label: {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ink)
                .background(Theme.ok, in: Circle())
                .disabled(loading || input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .navigationTitle("Czat Gemini")
        .screenChrome()
        .containerBackground(for: .navigation) { Color.black }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Wróć") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Wyczyść") { messages = [] }
                    .disabled(messages.isEmpty)
            }
        }
    }

    @ViewBuilder
    private func bubble(_ message: ChatMsg) -> some View {
        let piece = message.role == "user" ? ChatPiece(german: message.text, polish: "", words: []) : ChatPiece.parse(message.text)
        VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 8) {
            if message.role == "user" {
                Text(message.text)
                    .padding(12)
                    .background(Theme.ok.opacity(0.22), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else if piece.german.isEmpty {
                Text(message.text)
                    .padding(12)
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text(piece.german).font(.body.weight(.semibold))
                    Button { Talk.de(piece.german, rate: 0.46) } label: {
                        Label("Odsłuchaj", systemImage: "speaker.wave.2")
                            .font(.caption.weight(.semibold))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.ok)
                    if !piece.polish.isEmpty {
                        Text(piece.polish).font(.subheadline).foregroundStyle(Theme.text2)
                    }
                    ForEach(piece.words) { word in
                        HStack {
                            Text(word.de).font(.subheadline.weight(.semibold))
                            Text(word.pl).font(.subheadline).foregroundStyle(Theme.text2)
                            Spacer()
                            Button(saved.contains(word.de) ? "Zapisane" : "Do słówek") {
                                keep(word.de, word.pl, piece.german, piece.polish)
                            }
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 10)
                            .frame(minHeight: 32)
                            .background(Theme.ok, in: Capsule())
                            .disabled(saved.contains(word.de))
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == "user" ? .trailing : .leading)
    }

    private func keep(_ de: String, _ pl: String, _ german: String, _ polish: String) {
        let card = Vocab(de: de, pl: pl, plural: "", ex: german, exPl: polish, topic: "Czat", kind: "Z czatu", note: "")
        VocabBook.saveMine(card)
        store.pinForReview(Word(de: de, pl: pl, ex: german.isEmpty ? de : german, exPl: polish.isEmpty ? pl : polish, topic: "Czat", level: "A1"))
        saved.insert(de)
    }

    private func send(_ raw: String) async {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !loading else { return }
        input = ""
        Keyboard.hide()
        messages.append(ChatMsg(role: "user", text: text))
        loading = true
        defer { loading = false }
        do {
            let history = messages.map { GeminiMessage(role: $0.role, text: $0.text) }
            let reply = try await Gemini.send(messages: history, system: systemPrompt(), route: .geminiFirst)
            messages.append(ChatMsg(role: "model", text: reply))
            store.noteSkill("speak", ok: true)
        } catch {
            messages.append(ChatMsg(role: "model", text: error.localizedDescription))
        }
    }

    private func systemPrompt() -> String {
        """
        Jesteś cierpliwym nauczycielem niemieckiego dla Polaka na poziomie A1. Uczy się do pracy na budowie i do życia codziennego: sklep, lekarz, szef, autobus, urząd, mieszkanie.
        Nie ma limitu długości rozmowy. Każda odpowiedź ma DOKŁADNIE trzy części, w tej kolejności, bez markdownu i bez gwiazdek.

        Po niemiecku:
        Dwa albo trzy krótkie zdania, poziom A1. Na końcu jedno krótkie pytanie. Zero polskich słów.

        Po polsku:
        Dokładne tłumaczenie całego tekstu z części niemieckiej. Jednym zdaniem popraw błąd użytkownika, jeśli był.

        Słówka:
        Dwa albo trzy słowa. Każde w osobnej linii: niemieckie słowo — polskie znaczenie.

        Jeśli użytkownik pisze po polsku, odpowiedz na tę sytuację po niemiecku, tak jak w prawdziwej rozmowie.
        Postęp ucznia:
        \(store.progressSummary())
        """
    }
}

struct ChatPiece {
    var german: String
    var polish: String
    var words: [ChatWord]

    static func parse(_ raw: String) -> ChatPiece {
        let text = raw.replacingOccurrences(of: "**", with: "").replacingOccurrences(of: "*", with: "")
        let german = section(text, start: "Po niemiecku:", ends: ["Po polsku:", "Słówka:"])
        let polish = section(text, start: "Po polsku:", ends: ["Słówka:", "Po niemiecku:"])
        let wordsRaw = section(text, start: "Słówka:", ends: [])
        let words = wordsRaw.split(separator: "\n").compactMap { line -> ChatWord? in
            let parts = line.split(separator: "—", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2, !parts[0].isEmpty { return ChatWord(de: parts[0], pl: parts[1]) }
            let dash = line.split(separator: "-", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            guard dash.count == 2, !dash[0].isEmpty else { return nil }
            return ChatWord(de: dash[0], pl: dash[1])
        }
        if german.isEmpty && polish.isEmpty {
            return ChatPiece(german: text.trimmingCharacters(in: .whitespacesAndNewlines), polish: "", words: [])
        }
        return ChatPiece(german: german, polish: polish, words: words)
    }

    private static func section(_ text: String, start: String, ends: [String]) -> String {
        guard let range = text.range(of: start) else { return "" }
        var rest = text[range.upperBound...]
        var cut = rest.endIndex
        for end in ends {
            if let found = rest.range(of: end) { cut = min(cut, found.lowerBound) }
        }
        rest = rest[..<cut]
        return rest.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
