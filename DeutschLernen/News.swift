import BackgroundTasks
import SwiftUI

struct NewsItem: Identifiable, Hashable, Codable {
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

    static func fullText(link: String, fallback: String) async -> String {
        guard let url = URL(string: link), url.scheme == "https" else { return fallback }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        guard let (data, response) = try? await URLSession.shared.data(for: request),
              let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
              let html = String(data: data, encoding: .utf8) else { return fallback }
        if let body = articleBody(html), body.count > 180 { return body }
        let parts = paragraphs(html)
        let joined = parts.joined(separator: "\n\n")
        if joined.count > max(fallback.count, 180) { return joined }
        return fallback
    }

    private static func articleBody(_ html: String) -> String? {
        guard let marker = html.range(of: "\"articleBody\"") else { return nil }
        let tail = html[marker.upperBound...]
        guard let colon = tail.firstIndex(of: ":") else { return nil }
        var rest = tail[tail.index(after: colon)...].drop(while: \.isWhitespace)
        guard rest.first == "\"" else { return nil }
        rest.removeFirst()
        var out = ""
        var escaped = false
        for ch in rest {
            if escaped {
                if ch == "n" { out.append("\n") }
                else if ch == "\"" { out.append("\"") }
                else if ch != "t" { out.append(ch) }
                escaped = false
                continue
            }
            if ch == "\\" { escaped = true; continue }
            if ch == "\"" { break }
            out.append(ch)
        }
        let clean = RSSParser.plain(out)
        return clean.count > 80 ? clean : nil
    }

    private static func paragraphs(_ html: String) -> [String] {
        var source = html
        if let start = source.range(of: "<article", options: .caseInsensitive),
           let end = source.range(of: "</article>", options: .caseInsensitive, range: start.upperBound..<source.endIndex) {
            source = String(source[start.lowerBound..<end.upperBound])
        }
        if let tags = try? NSRegularExpression(pattern: "<(script|style)[\\s\\S]*?</\\1>", options: .caseInsensitive) {
            let range = NSRange(source.startIndex..., in: source)
            source = tags.stringByReplacingMatches(in: source, range: range, withTemplate: " ")
        }
        guard let regex = try? NSRegularExpression(pattern: "<p[^>]*>([\\s\\S]*?)</p>", options: .caseInsensitive) else { return [] }
        let ns = source as NSString
        return regex.matches(in: source, range: NSRange(location: 0, length: ns.length)).compactMap { match in
            guard match.numberOfRanges > 1 else { return nil }
            let text = RSSParser.plain(ns.substring(with: match.range(at: 1)))
            guard text.count > 40 else { return nil }
            let low = text.lowercased()
            if low.contains("cookie") || low.contains("newsletter") || low.contains("datenschutz") { return nil }
            return text
        }
    }

    static func polish(_ german: String) async throws -> (title: String, text: String) {
        let reply = try await Gemini.send(
            messages: [GeminiMessage(role: "user", text: german)],
            system: "Przetłumacz cały niemiecki news na prosty polski. Nie skracaj do jednego zdania. Pierwsza linia zaczyna się od TYTUŁ: a zaraz potem TEKST: i cały przekład."
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

enum NewsDay {
    private static let storeKey = "newsDayCache"

    private struct Box: Codable {
        var day: String
        var items: [NewsItem]
        var updated: Date
    }

    static func cached() -> [NewsItem] {
        box()?.items ?? []
    }

    static func stamp() -> Date? {
        guard box()?.day == NewsDay.today() else { return nil }
        return box()?.updated
    }

    static func refresh(force: Bool) async -> [NewsItem] {
        let hour = Calendar.current.component(.hour, from: Date())
        let daytime = (6..<22).contains(hour)
        let today = cached()
        let stale = stamp().map { Date().timeIntervalSince($0) > 30 * 60 } ?? true
        guard force || today.isEmpty || (daytime && stale) else { return today }
        do {
            return merge(try await NewsFeed.load())
        } catch {
            return today
        }
    }

    private static func merge(_ fresh: [NewsItem]) -> [NewsItem] {
        var items = cached()
        var seen = Set(items.map { Normalizer.clean($0.title) })
        let added = fresh.filter { seen.insert(Normalizer.clean($0.title)).inserted }
        items = added + items
        items = Array(items.prefix(40))
        let next = Box(day: today(), items: items, updated: Date())
        if let data = try? JSONEncoder().encode(next) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
        return items
    }

    private static func today() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private static func box() -> Box? {
        guard let data = UserDefaults.standard.data(forKey: storeKey),
              let saved = try? JSONDecoder().decode(Box.self, from: data),
              saved.day == today() else { return nil }
        return saved
    }
}

enum NewsRefresh {
    static let id = "com.example.DeutschLernen.news"

    static func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: id, using: nil) { task in
            guard let task = task as? BGAppRefreshTask else { return }
            let work = Task {
                _ = await NewsDay.refresh(force: false)
                task.setTaskCompleted(success: true)
                schedule()
            }
            task.expirationHandler = {
                work.cancel()
                task.setTaskCompleted(success: false)
            }
        }
    }

    static func schedule() {
        let request = BGAppRefreshTaskRequest(identifier: id)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }
}

@MainActor
final class NewsClock: ObservableObject {
    static let shared = NewsClock()
    @Published var items: [NewsItem] = NewsDay.cached()
    @Published var updated: Date? = NewsDay.stamp()
    @Published var loading = false
    private var timer: Timer?
    private var started = false

    var caption: String {
        let time = updated.map { Self.clock.string(from: $0) } ?? "jeszcze dziś nie"
        return "Sama bierze newsy z internetu od 6:00 do 22:00 i dokłada nowe z całego dnia. Ostatnio: \(time)."
    }

    func start() {
        NewsRefresh.schedule()
        if !started {
            started = true
            timer = Timer.scheduledTimer(withTimeInterval: 30 * 60, repeats: true) { _ in
                Task { @MainActor in await NewsClock.shared.kick(force: false) }
            }
        }
        Task { await kick(force: false) }
    }

    func kick(force: Bool) async {
        loading = true
        defer { loading = false }
        items = await NewsDay.refresh(force: force)
        updated = NewsDay.stamp()
        NewsRefresh.schedule()
    }

    private static let clock: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
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

    static func plain(_ raw: String) -> String {
        var text = raw
        if let tags = try? NSRegularExpression(pattern: "<[^>]+>") {
            let range = NSRange(text.startIndex..., in: text)
            text = tags.stringByReplacingMatches(in: text, range: range, withTemplate: " ")
        }
        let pairs = [
            ("&" + "amp;", "&"),
            ("&" + "quot;", "\""),
            ("&" + "apos;", "'"),
            ("&" + "#039;", "'"),
            ("&" + "lt;", "<"),
            ("&" + "gt;", ">"),
            ("&" + "nbsp;", " "),
            ("&" + "#8211;", "–"),
            ("&" + "#8212;", "—")
        ]
        for (from, to) in pairs { text = text.replacingOccurrences(of: from, with: to) }
        if let spaces = try? NSRegularExpression(pattern: "\\s+") {
            let range = NSRange(text.startIndex..., in: text)
            text = spaces.stringByReplacingMatches(in: text, range: range, withTemplate: " ")
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct NewsListView: View {
    @ObservedObject private var clock = NewsClock.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(clock.caption)
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                if clock.loading, clock.items.isEmpty {
                    ProgressView("Pobieram wiadomości…")
                        .tint(Theme.accent)
                        .foregroundStyle(Theme.text2)
                        .frame(maxWidth: .infinity, minHeight: 120)
                }
                if !clock.loading, clock.items.isEmpty {
                    Text("Jeszcze nic nie doszło. Jak jest internet, aplikacja sama spróbuje ponownie.")
                        .font(.footnote)
                        .foregroundStyle(Theme.bad)
                }
                ForEach(clock.items) { item in
                    NavigationLink {
                        NewsArticleView(item: item)
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(Theme.gradient)
                                .frame(width: 4)
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.source.uppercased())
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Theme.accent)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Theme.accent.opacity(0.18), in: Capsule())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(Theme.text2)
                                }
                                Text(item.title)
                                    .font(.title3.weight(.bold))
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .themedCard(radius: 22)
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
        .refreshable { await clock.kick(force: true) }
    }
}

struct NewsArticleView: View {
    let item: NewsItem
    @State private var polishTitle = ""
    @State private var polishText = ""
    @State private var full = ""
    @State private var loadingText = true
    @State private var translating = false
    @State private var error = ""
    @State private var picked: String?

    private var german: String { full.isEmpty ? (item.body.isEmpty ? item.title : item.body) : full }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.source.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.18), in: Capsule())
                Text(item.title)
                    .font(.title.bold())
                    .foregroundStyle(Theme.text)
                Text("Cała wiadomość. Stuknij słowo, żeby dodać je do nauki.")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
                VStack(alignment: .leading, spacing: 14) {
                    if loadingText, full.isEmpty {
                        ProgressView("Pobieram całą wiadomość…")
                            .tint(Theme.accent)
                            .frame(maxWidth: .infinity, minHeight: 80)
                    }
                    ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                        FlowLayout(spacing: 2) {
                            ForEach(Array(words(block).enumerated()), id: \.offset) { _, token in
                                Button { picked = token } label: {
                                    Text(token + " ")
                                        .font(.body)
                                        .foregroundStyle(Theme.text)
                                        .multilineTextAlignment(.leading)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .themedCard(radius: 22)
                Button { Talk.de(String(german.prefix(420))) } label: {
                    Label("Odtwórz wiadomość", systemImage: "speaker.wave.2")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.accent)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Po polsku")
                        .font(.headline)
                    if translating {
                        ProgressView("Tłumaczę całość…").tint(Theme.accent)
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
                .themedCard(radius: 22)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .containerBackground(for: .navigation) { NightGlow() }
        .task { await open() }
        .sheet(item: pickedWord) { word in
            NewsWordSheet(word: word.text, sentence: sentence(for: word.text))
                .presentationDetents([.medium])
        }
    }

    private var pickedWord: Binding<NewsWord?> {
        Binding(
            get: { picked.map { NewsWord(text: $0) } },
            set: { picked = $0?.text }
        )
    }

    private var blocks: [String] {
        let parts = german.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return parts.isEmpty ? [item.title] : parts
    }

    private func words(_ text: String) -> [String] {
        text.split { !$0.isLetter && $0 != "-" && !"äöüÄÖÜß".contains($0) }
            .map(String.init)
            .filter { $0.count > 1 }
    }

    private func open() async {
        full = await NewsFeed.fullText(link: item.link, fallback: item.body)
        loadingText = false
        await translate()
    }

    private func sentence(for word: String) -> String {
        let parts = german.components(separatedBy: CharacterSet(charactersIn: ".!?"))
        return parts.first { $0.localizedCaseInsensitiveContains(word) }?.trimmingCharacters(in: .whitespacesAndNewlines) ?? item.title
    }

    private func translate() async {
        guard polishText.isEmpty else { return }
        translating = true
        error = ""
        defer { translating = false }
        do {
            let clip = String(german.prefix(3500))
            let result = try await NewsFeed.polish("\(item.title)\n\(clip)")
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
