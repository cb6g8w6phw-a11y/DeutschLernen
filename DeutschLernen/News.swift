import SwiftUI

struct NewsItem: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
    var source: String
    var link: String
}

enum NewsFeed {
    static func load() async throws -> [NewsItem] {
        let sources = [
            ("DW", "https://rss.dw.com/xml/rss-de-welt"),
            ("Tagesschau", "https://www.tagesschau.de/xml/rss2/")
        ]
        var all: [NewsItem] = []
        var lastError: Error?
        for (name, url) in sources {
            do {
                all += try await fetch(name, url)
            } catch {
                lastError = error
            }
        }
        var seen = Set<String>()
        let unique = all.filter { seen.insert(Normalizer.clean($0.title)).inserted }
        if unique.isEmpty, let lastError { throw lastError }
        return Array(unique.prefix(24))
    }

    private static func fetch(_ source: String, _ url: String) async throws -> [NewsItem] {
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 20
        request.setValue("DeutschLernen/4.8", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let parser = RSSParser(source: source)
        let xml = XMLParser(data: data)
        xml.delegate = parser
        guard xml.parse() else { throw xml.parserError ?? URLError(.cannotParseResponse) }
        return parser.items
    }

    static func polish(_ german: String) async throws -> (title: String, text: String) {
        let reply = try await Gemini.send(
            messages: [GeminiMessage(role: "user", text: german)],
            system: "Przetłumacz ten niemiecki news na prosty polski, tak żeby Polak na poziomie A2 zrozumiał. Odpowiedz dokładnie w dwóch akapitach. Pierwsza linia zaczyna się od TYTUŁ: a druga od TEKST:. Bez komentarza."
        )
        var title = ""
        var text = ""
        for line in reply.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("TYTUŁ:") { title = String(trimmed.dropFirst(6)).trimmingCharacters(in: .whitespaces) }
            else if trimmed.hasPrefix("TEKST:") { text = String(trimmed.dropFirst(6)).trimmingCharacters(in: .whitespaces) }
            else if !text.isEmpty, !trimmed.isEmpty { text += " " + trimmed }
        }
        if title.isEmpty && text.isEmpty { return ("", reply.trimmingCharacters(in: .whitespacesAndNewlines)) }
        return (title, text)
    }

    static func meaning(_ word: String, sentence: String) async throws -> String {
        let reply = try await Gemini.send(
            messages: [GeminiMessage(role: "user", text: "Słowo: \(word)\nZdanie: \(sentence)")],
            system: "Podaj tylko polskie znaczenie tego jednego niemieckiego słowa w tym zdaniu. Maksymalnie cztery słowa. Bez kropki na końcu i bez komentarza."
        )
        return reply
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private final class RSSParser: NSObject, XMLParserDelegate {
    let source: String
    var items: [NewsItem] = []
    private var inside = false
    private var element = ""
    private var title = ""
    private var body = ""
    private var link = ""

    init(source: String) { self.source = source }

    func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI: String?, qualifiedName: String?, attributes: [String: String] = [:]) {
        element = name.lowercased()
        if element == "item" || element == "entry" {
            inside = true
            title = ""
            body = ""
            link = ""
        }
        if inside, element == "link", let href = attributes["href"], link.isEmpty { link = href }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard inside else { return }
        switch element {
        case "title": title += string
        case "description", "summary": body += string
        case "link": link += string
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement name: String, namespaceURI: String?, qualifiedName: String?) {
        let end = name.lowercased()
        if end == "item" || end == "entry" {
            let cleanTitle = Self.plain(title)
            let cleanBody = Self.plain(body)
            if !cleanTitle.isEmpty {
                items.append(NewsItem(id: link.isEmpty ? cleanTitle : link, title: cleanTitle, body: cleanBody, source: source, link: link))
            }
            inside = false
        }
        element = ""
    }

    private static func plain(_ raw: String) -> String {
        var text = raw.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
        let entities = ["&": "&", """: "\"", "'": "'", "&#039;": "'", "<": "<", ">": ">", "&nbsp;": " ", "&#8211;": "–", "&#8212;": "—"]
        for (from, to) in entities { text = text.replacingOccurrences(of: from, with: to) }
        text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct NewsListView: View {
    @State private var items: [NewsItem] = []
    @State private var loading = false
    @State private var error = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Najnowsze wiadomości po niemiecku. Stuknij słowo, żeby dodać je do nauki.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                if loading, items.isEmpty {
                    ProgressView("Pobieram wiadomości…")
                        .tint(Theme.accent)
                        .foregroundStyle(Theme.text2)
                        .frame(maxWidth: .infinity, minHeight: 120)
                }
                if !error.isEmpty {
                    Text(error).font(.footnote).foregroundStyle(Theme.bad)
                }
                ForEach(items) { item in
                    NavigationLink {
                        NewsArticleView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.source.uppercased())
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.accent)
                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(Theme.text)
                                .multilineTextAlignment(.leading)
                            if !item.body.isEmpty {
                                Text(item.body)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.text2)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .themedCard(radius: 18)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .navigationTitle("Wiadomości")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .containerBackground(for: .navigation) { NightGlow() }
        .refreshable { await reload() }
        .task { if items.isEmpty { await reload() } }
    }

    private func reload() async {
        loading = true
        error = ""
        defer { loading = false }
        do {
            items = try await NewsFeed.load()
            if items.isEmpty { error = "Nie ma teraz nowych wiadomości. Pociągnij w dół i spróbuj jeszcze raz." }
        } catch {
            self.error = "Nie udało się pobrać wiadomości. Sprawdź internet."
        }
    }
}

struct NewsArticleView: View {
    let item: NewsItem
    @State private var polishTitle = ""
    @State private var polishText = ""
    @State private var translating = false
    @State private var error = ""
    @State private var picked: String?

    private var german: String { item.body.isEmpty ? item.title : item.body }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.source)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
                Text(item.title)
                    .font(.title2.bold())
                    .foregroundStyle(Theme.text)
                Text("Stuknij słowo, żeby dodać je do nauki.")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
                FlowLayout(spacing: 8) {
                    ForEach(Array(tokens.enumerated()), id: \.offset) { _, token in
                        Button { picked = token } label: {
                            Text(token)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.text)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.card2, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                Button { Talk.de(item.title) } label: {
                    Label("Odtwórz tytuł", systemImage: "speaker.wave.2")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.accent)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Po polsku")
                        .font(.headline)
                    if translating {
                        ProgressView("Tłumaczę…").tint(Theme.accent)
                    } else if !error.isEmpty {
                        Text(error).font(.footnote).foregroundStyle(Theme.bad)
                        Button("Tłumacz jeszcze raz") { Task { await translate() } }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.accent)
                    } else {
                        if !polishTitle.isEmpty {
                            Text(polishTitle).font(.headline).foregroundStyle(Theme.text)
                        }
                        Text(polishText.isEmpty ? "Brak tłumaczenia." : polishText)
                            .font(.body)
                            .foregroundStyle(Theme.text2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .themedCard(radius: 18)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .containerBackground(for: .navigation) { NightGlow() }
        .task { await translate() }
        .sheet(item: $pickedWord) { word in
            NewsWordSheet(word: word, sentence: sentence(for: word))
                .presentationDetents([.medium])
        }
    }

    private var pickedWord: Binding<NewsWord?> {
        Binding(
            get: { picked.map { NewsWord(text: $0) } },
            set: { picked = $0?.text }
        )
    }

    private var tokens: [String] {
        german.split { !$0.isLetter && $0 != "-" && !"äöüÄÖÜß".contains($0) }
            .map(String.init)
            .filter { $0.count > 1 }
    }

    private func sentence(for word: String) -> String {
        let parts = german.components(separatedBy: CharacterSet(charactersIn: ".!?"))
        return parts.first { $0.localizedCaseInsensitiveContains(word) }?.trimmingCharacters(in: .whitespaces) ?? item.title
    }

    private func translate() async {
        guard polishText.isEmpty else { return }
        translating = true
        error = ""
        defer { translating = false }
        do {
            let result = try await NewsFeed.polish("\(item.title)\n\(german)")
            polishTitle = result.title
            polishText = result.text
        } catch {
            self.error = "Nie udało się przetłumaczyć. Sprawdź klucz Groq albo Gemini w ustawieniach."
        }
    }
}

private struct NewsWord: Identifiable {
    var id: String { text }
    var text: String
}

private struct NewsWordSheet: View {
    let word: String
    let sentence: String
    @EnvironmentObject private var store: LearningStore
    @Environment(\.dismiss) private var dismiss
    @State private var polish = ""
    @State private var busy = true
    @State private var saved = false
    @State private var error = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(word)
                .font(.largeTitle.bold())
            Text(sentence)
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            if busy {
                ProgressView("Tłumaczę słówko…").tint(Theme.accent)
            } else if !error.isEmpty {
                Text(error).font(.footnote).foregroundStyle(Theme.bad)
            } else {
                Text(polish.isEmpty ? "Brak tłumaczenia" : polish)
                    .font(.title3.weight(.semibold))
            }
            Button {
                let entry = Word(
                    de: word,
                    pl: polish.isEmpty ? word : polish,
                    ex: sentence,
                    exPl: polish,
                    topic: "Wiadomości",
                    level: "A2"
                )
                store.pinForReview(entry)
                saved = true
                Haptic.good()
            } label: {
                Text(saved ? "Dodane do nauki" : "Dodaj do nauki")
                    .frame(maxWidth: .infinity, minHeight: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
            .disabled(saved || busy)
            Button("Zamknij") { dismiss() }
                .frame(maxWidth: .infinity, minHeight: 44)
                .foregroundStyle(Theme.text2)
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Theme.bg)
        .task { await gloss() }
    }

    private func gloss() async {
        defer { busy = false }
        do {
            polish = try await NewsFeed.meaning(word, sentence: sentence)
        } catch {
            self.error = "Tłumaczenie słówka nie doszło. Możesz je dodać i tak."
            polish = ""
            busy = false
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 320
        var x: CGFloat = 0
        var y: CGFloat = 0
        var row: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += row + spacing
                row = 0
            }
            row = max(row, size.height)
            x += size.width + spacing
        }
        return CGSize(width: width, height: y + row)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var row: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += row + spacing
                row = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(width: size.width, height: size.height))
            row = max(row, size.height)
            x += size.width + spacing
        }
    }
}
