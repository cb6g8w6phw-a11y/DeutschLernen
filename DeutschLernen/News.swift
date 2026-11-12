import BackgroundTasks
import SwiftUI

struct NewsItem: Identifiable, Hashable, Codable {
    var id: String
    var title: String
    var body: String
    var source: String
    var link: String
    var category: String
    var image: String

    init(id: String, title: String, body: String, source: String, link: String, category: String = "Świat", image: String = "") {
        self.id = id
        self.title = title
        self.body = body
        self.source = source
        self.link = link
        self.category = category
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        body = try c.decodeIfPresent(String.self, forKey: .body) ?? ""
        source = try c.decodeIfPresent(String.self, forKey: .source) ?? ""
        link = try c.decodeIfPresent(String.self, forKey: .link) ?? ""
        category = try c.decodeIfPresent(String.self, forKey: .category) ?? "Świat"
        image = try c.decodeIfPresent(String.self, forKey: .image) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(body, forKey: .body)
        try c.encode(source, forKey: .source)
        try c.encode(link, forKey: .link)
        try c.encode(category, forKey: .category)
        try c.encode(image, forKey: .image)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, body, source, link, category, image
    }
}

enum NewsFeed {
    static func load() async throws -> [NewsItem] {
        let sources: [(String, String, String)] = [
            ("Świat", "Tagesschau", "https://www.tagesschau.de/ausland/index~rss2.xml"),
            ("Świat", "DW", "https://rss.dw.com/xml/rss-de-all"),
            ("Świat", "SPIEGEL", "https://www.spiegel.de/politik/index.rss"),
            ("Niemcy", "Tagesschau", "https://www.tagesschau.de/inland/index~rss2.xml"),
            ("Niemcy", "SPIEGEL", "https://www.spiegel.de/politik/deutschland/index.rss"),
            ("Niemcy", "SZ", "https://rss.sueddeutsche.de/rss/Politik"),
            ("Pieniądze", "Tagesschau", "https://www.tagesschau.de/wirtschaft/index~rss2.xml"),
            ("Pieniądze", "Handelsblatt", "https://www.handelsblatt.com/contentexport/feed/schlagzeilen"),
            ("Pieniądze", "ZEIT", "https://newsfeed.zeit.de/wirtschaft/index"),
            ("Sport", "Sportschau", "https://www.sportschau.de/index~rss2.xml"),
            ("Sport", "SPIEGEL", "https://www.spiegel.de/sport/index.rss"),
            ("Sport", "ZEIT", "https://newsfeed.zeit.de/sport/index"),
            ("Technologia", "heise", "https://www.heise.de/rss/heise.rdf"),
            ("Technologia", "Golem", "https://www.golem.de/rss.php?feed=RSS2.0"),
            ("Technologia", "ZEIT", "https://newsfeed.zeit.de/digital/index")
        ]
        var all: [NewsItem] = []
        await withTaskGroup(of: [NewsItem].self) { group in
            for (category, name, url) in sources {
                group.addTask {
                    let batch = (try? await fetch(name, url, category: category)) ?? []
                    return Array(batch.filter(useful).prefix(8))
                }
            }
            for await batch in group {
                all += batch
            }
        }
        var seen = Set<String>()
        let unique = all.filter { seen.insert(Normalizer.clean($0.title)).inserted }
        if unique.isEmpty { throw URLError(.cannotParseResponse) }
        return mix(unique)
    }

    static func mix(_ items: [NewsItem]) -> [NewsItem] {
        let order = ["Świat", "Niemcy", "Pieniądze", "Sport", "Technologia"]
        var buckets: [String: [NewsItem]] = [:]
        for item in items {
            buckets[item.category, default: []].append(item)
        }
        for key in buckets.keys {
            buckets[key] = Array(buckets[key, default: []].prefix(18))
        }
        var mixed: [NewsItem] = []
        var pending = true
        while pending {
            pending = false
            for key in order {
                guard var list = buckets[key], !list.isEmpty else { continue }
                mixed.append(list.removeFirst())
                buckets[key] = list
                pending = true
            }
        }
        return mixed
    }

    private static func useful(_ item: NewsItem) -> Bool {
        let title = item.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard title.count >= 16 else { return false }
        let low = title.lowercased()
        if low == "der spiegel" || low.hasPrefix("n-tv.de") || low == "kicker" { return false }
        return true
    }

    private static func fetch(_ source: String, _ url: String, category: String) async throws -> [NewsItem] {
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 20
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let parser = RSSParser(source: source, category: category)
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

    static func brief(_ german: String) async -> String {
        let source = String(german.prefix(4000))
        do {
            let reply = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: source)],
                system: "Wyciągnij tylko najważniejsze z tego newsa. Napisz po niemiecku, prosto, poziom A2. Dokładnie 4 krótkie zdania. Same fakty. Bez tytułu, bez listy i bez komentarza."
            )
            let clean = reply
                .replacingOccurrences(of: "*", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if clean.count > 40, clean.count < 800 { return clean }
        } catch {}
        return short(german)
    }

    static func short(_ text: String) -> String {
        var sentences: [String] = []
        var current = ""
        for ch in text {
            current.append(ch)
            if ".!?".contains(ch) {
                let bit = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if bit.count > 25 { sentences.append(bit) }
                current = ""
                if sentences.count == 3 { break }
            }
        }
        if sentences.isEmpty { return String(text.prefix(280)) }
        return sentences.joined(separator: " ")
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
            system: "Przetłumacz ten krótki news na prosty polski. Zostaw wszystkie podane zdania, nic nie dopisuj. Odpowiedz tak:\nTYTUŁ: krótki tytuł\nTEKST:\npełny przekład tych zdań."
        )
        var title = ""
        var lines: [String] = []
        var seenText = false
        for raw in reply.components(separatedBy: .newlines) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }
            let key = line.uppercased()
            if key.hasPrefix("TYTUŁ:") || key.hasPrefix("TYTUL:") {
                title = String(line.drop(while: { $0 != ":" }).dropFirst()).trimmingCharacters(in: .whitespaces)
                continue
            }
            if key.hasPrefix("TEKST:") || key.hasPrefix("TŁUMACZENIE:") || key.hasPrefix("TLUMACZENIE:") {
                seenText = true
                let rest = String(line.drop(while: { $0 != ":" }).dropFirst()).trimmingCharacters(in: .whitespaces)
                if !rest.isEmpty { lines.append(rest) }
                continue
            }
            if title.isEmpty && !seenText && lines.isEmpty {
                title = line
                seenText = true
                continue
            }
            lines.append(line)
        }
        var text = lines.joined(separator: "\n\n")
        if text.isEmpty {
            let clean = reply.trimmingCharacters(in: .whitespacesAndNewlines)
            text = title.isEmpty ? clean : clean.replacingOccurrences(of: title, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
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
    private static let storeKey = "newsDayCache3"

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
        var items = fresh + cached()
        var seen = Set<String>()
        items = items.filter { seen.insert(Normalizer.clean($0.title)).inserted }
        items = Array(NewsFeed.mix(items).prefix(100))
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
    let category: String
    var items: [NewsItem] = []
    private var inside = false
    private var element = ""
    private var title = ""
    private var body = ""
    private var link = ""
    private var image = ""
    private var extra = ""

    init(source: String, category: String) {
        self.source = source
        self.category = category
    }

    func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI: String?, qualifiedName: String?, attributes: [String: String] = [:]) {
        element = (qualifiedName ?? name).lowercased()
        if element == "item" || element == "entry" {
            inside = true
            title = ""
            body = ""
            link = ""
            image = ""
            extra = ""
        }
        if inside, element == "link", let href = attributes["href"], link.isEmpty { link = href }
        if inside, image.isEmpty, let url = attributes["url"], url.hasPrefix("http"),
           element == "enclosure" || element.hasSuffix("content") || element.hasSuffix("thumbnail") {
            image = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard inside else { return }
        switch element {
        case "title": title += string
        case "description", "summary": body += string
        case "link": link += string
        default:
            if element.hasSuffix("encoded") { extra += string }
        }
    }

    func parser(_ parser: XMLParser, didEndElement name: String, namespaceURI: String?, qualifiedName: String?) {
        let end = name.lowercased()
        if end == "item" || end == "entry" {
            let raw = extra.count > body.count ? extra : body
            let cleanTitle = Self.plain(title)
            let cleanBody = Self.plain(raw)
            let cleanLink = link.trimmingCharacters(in: .whitespacesAndNewlines)
            let shot = image.isEmpty ? Self.picture(extra.isEmpty ? body : extra) : image
            if !cleanTitle.isEmpty {
                items.append(NewsItem(id: cleanLink.isEmpty ? cleanTitle : cleanLink, title: cleanTitle, body: cleanBody, source: source, link: cleanLink, category: category, image: shot))
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

    private static func picture(_ raw: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: "src=\"(https:[^\"]+)\""),
              let match = regex.firstMatch(in: raw, range: NSRange(raw.startIndex..., in: raw)),
              let range = Range(match.range(at: 1), in: raw) else { return "" }
        return String(raw[range])
    }
}

struct NewsListView: View {
    @ObservedObject private var clock = NewsClock.shared
    @State private var topic = "Wszystko"
    private let topics = ["Wszystko", "Świat", "Niemcy", "Pieniądze", "Sport", "Technologia"]

    private var shown: [NewsItem] {
        topic == "Wszystko" ? clock.items : clock.items.filter { $0.category == topic }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(clock.caption)
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(topics, id: \.self) { name in
                            Button { topic = name } label: {
                                Text(name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(topic == name ? Theme.ink : Theme.text)
                                    .padding(.horizontal, 14)
                                    .frame(minHeight: 36)
                                    .background(topic == name ? AnyShapeStyle(Theme.gradient) : AnyShapeStyle(Theme.card), in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                if clock.loading, shown.isEmpty {
                    ProgressView("Pobieram wiadomości…")
                        .tint(Theme.accent)
                        .foregroundStyle(Theme.text2)
                        .frame(maxWidth: .infinity, minHeight: 120)
                }
                if !clock.loading, shown.isEmpty {
                    Text(topic == "Wszystko" ? "Jeszcze nic nie doszło. Jak jest internet, aplikacja sama spróbuje ponownie." : "W tej kategorii jeszcze nic nie ma. Pociągnij w dół.")
                        .font(.footnote)
                        .foregroundStyle(Theme.bad)
                }
                ForEach(shown) { item in
                    NavigationLink {
                        NewsArticleView(item: item)
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            if let url = URL(string: item.image), !item.image.isEmpty {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable().scaledToFill()
                                    } else {
                                        Theme.card2
                                    }
                                }
                                .frame(width: 84, height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.category.uppercased())
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
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(Theme.text)
                                    .multilineTextAlignment(.leading)
                                if !item.body.isEmpty {
                                    Text(NewsFeed.short(item.body))
                                        .font(.subheadline)
                                        .foregroundStyle(Theme.text2)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
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
                if let url = URL(string: item.image), !item.image.isEmpty {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFill()
                        } else {
                            Theme.card2
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
                Text(item.category.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.18), in: Capsule())
                Text(item.title)
                    .font(.title.bold())
                    .foregroundStyle(Theme.text)
                Text("Najważniejsze. Stuknij słowo, żeby dodać je do nauki.")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
                VStack(alignment: .leading, spacing: 14) {
                    if loadingText, full.isEmpty {
                        ProgressView("Wybieram najważniejsze…")
                            .tint(Theme.accent)
                            .frame(maxWidth: .infinity, minHeight: 80)
                    }
                    ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                        FlowLayout(spacing: 2) {
                            ForEach(Array(words(block).enumerated()), id: \.offset) { _, token in
                                Button { picked = cleanToken(token) } label: {
                                    Text(token + " ")
                                        .font(.body)
                                        .foregroundStyle(Theme.text)
                                        .multilineTextAlignment(.leading)
                                }
                                .buttonStyle(.plain)
                                .disabled(cleanToken(token).count < 2)
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
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .themedCard(radius: 22)
                NavigationLink {
                    NewsTalkView(title: item.title, facts: german)
                } label: {
                    Label("Pogadaj: o co chodziło?", systemImage: "bubble.left.and.bubble.right.fill")
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Theme.gradient, in: Capsule())
                        .foregroundStyle(Theme.ink)
                }
                .buttonStyle(.plain)
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
        text.split(separator: " ").map(String.init).filter { !$0.isEmpty }
    }

    private func cleanToken(_ token: String) -> String {
        token.trimmingCharacters(in: CharacterSet.punctuationCharacters.union(.symbols))
    }

    private func open() async {
        let raw = await NewsFeed.fullText(link: item.link, fallback: item.body)
        let source = raw.isEmpty ? item.title : "\(item.title)\n\(raw)"
        full = await NewsFeed.brief(source)
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

struct NewsTalkView: View {
    let title: String
    let facts: String
    @State private var lines: [(id: UUID, mine: Bool, text: String)] = []
    @State private var draft = ""
    @State private var busy = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(lines, id: \.id) { line in
                        Text(line.text)
                            .font(.body)
                            .foregroundStyle(Theme.text)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: line.mine ? .trailing : .leading)
                            .background(line.mine ? Theme.accent.opacity(0.35) : Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    if busy { ProgressView().tint(Theme.accent) }
                }
                .padding(16)
                .padding(.bottom, 80)
            }
            HStack(spacing: 8) {
                TextField("Odpowiedz po niemiecku", text: $draft)
                    .padding(12)
                    .background(Theme.card, in: Capsule())
                    .foregroundStyle(Theme.text)
                Button("Wyślij") { Task { await send() } }
                    .disabled(busy || draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundStyle(Theme.accent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .navigationTitle("O co chodziło?")
        .navigationBarTitleDisplayMode(.inline)
        .containerBackground(for: .navigation) { NightGlow() }
        .task {
            guard lines.isEmpty else { return }
            lines.append((UUID(), false, "Worum geht es in dem Artikel? Sag es mit einem kurzen Satz auf Deutsch."))
        }
    }

    private func send() async {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !busy else { return }
        draft = ""
        lines.append((UUID(), true, text))
        busy = true
        defer { busy = false }
        let history = lines.map { GeminiMessage(role: $0.mine ? "user" : "model", text: $0.text) }
        let system = """
        Jesteś cierpliwym nauczycielem niemieckiego dla Polaka na A2. Uczeń przeczytał news.
        Tytuł: \(title)
        Najważniejsze: \(String(facts.prefix(900)))
        Sprawdź, czy wie, o co chodziło. Jak jest blisko, pochwal krótko po polsku w nawiasie i dopytaj o jeden fakt. Jak pudłuje, podaj prostą poprawną odpowiedź po niemiecku i jedno zdanie po polsku. Maksymalnie 3 zdania.
        """
        do {
            let reply = try await Gemini.send(messages: history, system: system)
            lines.append((UUID(), false, reply))
        } catch {
            lines.append((UUID(), false, "Nie udało się dopytać. Sprawdź internet albo klucz."))
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
