import Foundation

struct Word: Identifiable, Codable, Hashable {
    var id: String { de }
    let de: String
    let pl: String
    let ex: String
    let exPl: String
    let topic: String
    var level: String

    init(de: String, pl: String, ex: String, exPl: String, topic: String, level: String = "A2") {
        self.de = de
        self.pl = pl
        self.ex = ex
        self.exPl = exPl
        self.topic = topic
        self.level = level
    }

    private enum CodingKeys: String, CodingKey {
        case de, pl, ex, exPl, topic, level
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        de = try c.decode(String.self, forKey: .de)
        pl = try c.decode(String.self, forKey: .pl)
        ex = try c.decode(String.self, forKey: .ex)
        exPl = try c.decode(String.self, forKey: .exPl)
        topic = try c.decode(String.self, forKey: .topic)
        level = try c.decodeIfPresent(String.self, forKey: .level) ?? "A2"
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(de, forKey: .de)
        try c.encode(pl, forKey: .pl)
        try c.encode(ex, forKey: .ex)
        try c.encode(exPl, forKey: .exPl)
        try c.encode(topic, forKey: .topic)
        try c.encode(level, forKey: .level)
    }
}

struct WordStat: Codable {
    var box: Int = 0          // 0 = nowe/słabe ... 5 = opanowane
    var correct: Int = 0
    var wrong: Int = 0
    var due: Date = .distantPast
}

enum Grade { case hard, mid, easy }

enum Normalizer {
    static func clean(_ s: String) -> String {
        var t = s.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        for a in ["der ", "die ", "das "] where t.hasPrefix(a) {
            t = String(t.dropFirst(a.count))
            break
        }
        return t.replacingOccurrences(of: "ä", with: "ae")
            .replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue")
            .replacingOccurrences(of: "ß", with: "ss")
    }
    static func same(_ a: String, _ b: String) -> Bool { clean(a) == clean(b) }
}

@MainActor
final class LearningStore: ObservableObject {
    @Published var words: [Word]
    @Published var stats: [String: WordStat]

    private struct Saved: Codable {
        var words: [Word]
        var stats: [String: WordStat]
    }

    private let url: URL
    private let intervalsDays: [Int] = [0, 1, 2, 4, 8, 16]

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = dir.appendingPathComponent("progress.json")
        if let data = try? Data(contentsOf: url),
           let saved = try? JSONDecoder().decode(Saved.self, from: data) {
            words = saved.words
            stats = saved.stats
            let known = Set(words.map { Normalizer.clean($0.de) })
            let extra = SeedContent.words.filter { !known.contains(Normalizer.clean($0.de)) }
            if !extra.isEmpty {
                words += extra
                save()
            }
        } else {
            words = SeedContent.words
            stats = [:]
        }
    }

    private func save() {
        let saved = Saved(words: words, stats: stats)
        if let data = try? JSONEncoder().encode(saved) {
            try? data.write(to: url, options: .atomic)
        }
    }

    func record(_ w: Word, correct: Bool) {
        var s = stats[w.de] ?? WordStat()
        if correct {
            s.correct += 1
            s.box = min(s.box + 1, 5)
        } else {
            s.wrong += 1
            s.box = 0
        }
        let days = intervalsDays[s.box]
        s.due = correct
            ? Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
            : Date()
        stats[w.de] = s
        save()
    }

    func grade(_ w: Word, _ g: Grade) {
        var s = stats[w.de] ?? WordStat()
        switch g {
        case .hard:
            s.wrong += 1
            s.box = 0
            s.due = Date().addingTimeInterval(10 * 60)
        case .mid:
            s.correct += 1
            s.box = min(s.box + 1, 4)
            s.due = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case .easy:
            s.correct += 1
            s.box = min(max(s.box, 2) + 1, 5)
            s.due = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
        }
        stats[w.de] = s
        save()
    }

    /// Sesja: najpierw słabe/zaległe powtórki, potem kilka nowych słówek.
    func nextSession(size: Int = 8, maxNew: Int = 4, level: String = "oba") -> [Word] {
        let pool: [Word]
        switch level {
        case "A1": pool = words.filter { $0.level == "A1" }
        case "A2": pool = words.filter { $0.level == "A2" }
        default: pool = words
        }
        let now = Date()
        let reviews = pool.filter { w in
            if let s = stats[w.de] { return s.due <= now }
            return false
        }.sorted { a, b in
            let sa = stats[a.de]!, sb = stats[b.de]!
            if sa.box != sb.box { return sa.box < sb.box }
            return sa.wrong > sb.wrong
        }
        let fresh = pool.filter { stats[$0.de] == nil }.shuffled()
        var out = Array(reviews.prefix(size))
        let room = max(0, size - out.count)
        out += fresh.prefix(min(room, maxNew + (reviews.isEmpty ? size : 0)))
        return out
    }

    func addWords(_ new: [Word]) -> Int {
        let known = Set(words.map { Normalizer.clean($0.de) })
        let fresh = new.filter { !known.contains(Normalizer.clean($0.de)) }
        words += fresh
        save()
        return fresh.count
    }

    func reset() {
        words = SeedContent.words
        stats = [:]
        save()
    }

    // MARK: statystyki

    var masteredCount: Int { stats.values.filter { $0.box >= 4 }.count }
    var learningCount: Int { stats.values.filter { $0.box < 4 }.count }
    var newCount: Int { words.count - stats.count }

    var weakWords: [Word] {
        words.filter { (stats[$0.de]?.wrong ?? 0) > (stats[$0.de]?.correct ?? 0) }
            .sorted { (stats[$0.de]?.wrong ?? 0) > (stats[$1.de]?.wrong ?? 0) }
    }

    func topicAccuracy() -> [(topic: String, accuracy: Double, answers: Int)] {
        var agg: [String: (c: Int, w: Int)] = [:]
        for w in words {
            guard let s = stats[w.de] else { continue }
            let cur = agg[w.topic] ?? (0, 0)
            agg[w.topic] = (cur.c + s.correct, cur.w + s.wrong)
        }
        return agg.map { (k, v) in
            let n = v.c + v.w
            return (k, n == 0 ? 0 : Double(v.c) / Double(n), n)
        }.sorted { $0.accuracy < $1.accuracy }
    }

    /// Tekst przekazywany do Gemini, żeby dopasował lekcje i rozmowę.
    func progressSummary() -> String {
        let weak = weakWords.prefix(8).map { "\($0.de) (\($0.pl))" }.joined(separator: ", ")
        let topics = topicAccuracy()
            .map { "\($0.topic): \(Int($0.accuracy * 100))% (\($0.answers) odp.)" }
            .joined(separator: "; ")
        return """
        Opanowane słowa: \(masteredCount), w trakcie nauki: \(learningCount), nowe: \(newCount).
        Najsłabsze słowa: \(weak.isEmpty ? "brak danych" : weak).
        Skuteczność wg tematów: \(topics.isEmpty ? "brak danych" : topics).
        """
    }
}
