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

struct StoredMistake: Codable, Identifiable, Hashable {
    var id: String
    var text: String
    var fix: String
    var day: String
}

struct Journal: Codable {
    var startDay: String = ""
    var day: String = ""
    var reviews: Int = 0
    var month: String = ""
    var monthSeconds: Int = 0
    var listenOk: Int = 0
    var listenTries: Int = 0
    var said: Int = 0
    var scenes: [String] = []
    var mistakes: [StoredMistake] = []
    var streak: Int = 0
    var lastActive: String = ""
    var history: [String: Int] = [:]

    private enum CodingKeys: String, CodingKey {
        case startDay, day, reviews, month, monthSeconds, listenOk, listenTries, said, scenes, mistakes, streak, lastActive, history
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        startDay = try c.decodeIfPresent(String.self, forKey: .startDay) ?? ""
        day = try c.decodeIfPresent(String.self, forKey: .day) ?? ""
        reviews = try c.decodeIfPresent(Int.self, forKey: .reviews) ?? 0
        month = try c.decodeIfPresent(String.self, forKey: .month) ?? ""
        monthSeconds = try c.decodeIfPresent(Int.self, forKey: .monthSeconds) ?? 0
        listenOk = try c.decodeIfPresent(Int.self, forKey: .listenOk) ?? 0
        listenTries = try c.decodeIfPresent(Int.self, forKey: .listenTries) ?? 0
        said = try c.decodeIfPresent(Int.self, forKey: .said) ?? 0
        scenes = try c.decodeIfPresent([String].self, forKey: .scenes) ?? []
        mistakes = try c.decodeIfPresent([StoredMistake].self, forKey: .mistakes) ?? []
        streak = try c.decodeIfPresent(Int.self, forKey: .streak) ?? 0
        lastActive = try c.decodeIfPresent(String.self, forKey: .lastActive) ?? ""
        history = try c.decodeIfPresent([String: Int].self, forKey: .history) ?? [:]
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(startDay, forKey: .startDay)
        try c.encode(day, forKey: .day)
        try c.encode(reviews, forKey: .reviews)
        try c.encode(month, forKey: .month)
        try c.encode(monthSeconds, forKey: .monthSeconds)
        try c.encode(listenOk, forKey: .listenOk)
        try c.encode(listenTries, forKey: .listenTries)
        try c.encode(said, forKey: .said)
        try c.encode(scenes, forKey: .scenes)
        try c.encode(mistakes, forKey: .mistakes)
        try c.encode(streak, forKey: .streak)
        try c.encode(lastActive, forKey: .lastActive)
        try c.encode(history, forKey: .history)
    }
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
    @Published var journal = Journal()

    private struct Saved: Codable {
        var words: [Word]
        var stats: [String: WordStat]
    }

    private let url: URL
    private let journalURL: URL
    private let intervalsDays: [Int] = [0, 1, 2, 4, 8, 16]

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = dir.appendingPathComponent("progress.json")
        journalURL = dir.appendingPathComponent("journal.json")
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
        if let data = try? Data(contentsOf: journalURL),
           let saved = try? JSONDecoder().decode(Journal.self, from: data) {
            journal = saved
        }
        var promoted = false
        for key in stats.keys {
            var stat = stats[key]!
            if stat.correct >= 1, stat.box < 3 {
                stat.box = 3
                stats[key] = stat
                promoted = true
            }
        }
        if promoted { save() }
        roll()
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
        noteReview()
        save()
    }

    func grade(_ w: Word, _ g: Grade) {
        var s = stats[w.de] ?? WordStat()
        switch g {
        case .hard:
            s.wrong += 1
            if s.box < 3 { s.box = 0 }
            s.due = Date().addingTimeInterval(10 * 60)
        case .mid:
            s.correct += 1
            s.box = min(s.box + 2, 5)
            s.due = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case .easy:
            s.correct += 1
            s.box = 5
            s.due = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
        }
        stats[w.de] = s
        noteReview()
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

    func pinForReview(_ word: Word) {
        let known = Set(words.map { Normalizer.clean($0.de) })
        if !known.contains(Normalizer.clean(word.de)) {
            words.append(word)
        }
        var stat = stats[word.de] ?? WordStat()
        stat.box = 0
        stat.due = Date()
        stats[word.de] = stat
        save()
    }

    func reset() {
        words = SeedContent.words
        stats = [:]
        save()
    }

    // MARK: statystyki

    var masteredCount: Int { stats.values.filter { $0.box >= 3 }.count }
    var learningCount: Int { stats.values.filter { $0.box < 3 }.count }
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
        Ostatnie błędy: \(journal.mistakes.prefix(5).map { $0.fix.isEmpty ? $0.text : "\($0.text) → \($0.fix)" }.joined(separator: "; ").ifEmpty("brak")).
        """
    }

    var dueToday: Int {
        let now = Date()
        return words.filter { stats[$0.de]?.due ?? .distantFuture <= now }.count
    }

    var reviewsToday: Int { journal.day == Self.dayKey() ? journal.reviews : 0 }
    var monthTalkSeconds: Int {
        journal.month == String(Self.dayKey().prefix(7)) ? journal.monthSeconds : 0
    }
    var talkLabel: String {
        let s = monthTalkSeconds
        if s < 60 { return "\(s) s" }
        if s < 3600 { return "\(s / 60) min" }
        return String(format: "%.1f h", Double(s) / 3600)
    }
    var planDay: Int {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        guard let start = f.date(from: journal.startDay.isEmpty ? Self.dayKey() : journal.startDay) else { return 1 }
        let days = Calendar.current.dateComponents([.day], from: start, to: Date()).day ?? 0
        return min(30, max(1, days + 1))
    }
    var phaseTitle: String {
        switch planDay {
        case 1...7: return "Dni 1–7: zdania, pytania i odpowiedzi"
        case 8...14: return "Dni 8–14: praca, polecenia, słuchanie"
        case 15...21: return "Dni 15–21: rozmowa bez podpowiedzi"
        default: return "Dni 22–30: prawdziwe rozmowy"
        }
    }
    var streak: Int {
        let today = Self.dayKey()
        let yesterday = Self.dayKey(Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        if journal.lastActive == today || journal.lastActive == yesterday { return journal.streak }
        return 0
    }

    func recentActivity(_ count: Int = 14) -> [(label: String, value: Int)] {
        let cal = Calendar.current
        return (0..<count).reversed().compactMap { offset in
            guard let date = cal.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            return ("\(cal.component(.day, from: date))", journal.history[Self.dayKey(date)] ?? 0)
        }
    }

    func levelCounts() -> [(name: String, count: Int)] {
        let a1 = words.filter { $0.level == "A1" }.count
        let a2 = words.filter { $0.level == "A2" }.count
        return [("A1", a1), ("A2", a2), ("Inne", max(0, words.count - a1 - a2))]
    }
    var wordOfDay: Word? {
        guard !words.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return words[day % words.count]
    }
    var mistakesToday: [StoredMistake] {
        let day = Self.dayKey()
        return journal.mistakes.filter { $0.day == day }
    }

    func addTalk(_ seconds: Int) {
        guard seconds > 0 else { return }
        roll()
        journal.monthSeconds += min(seconds, 3600)
        publishJournal()
    }

    func addMistake(_ raw: String) {
        let parts = raw.split(separator: "|", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let text = parts.first ?? ""
        guard text.count > 2 else { return }
        let fix = parts.count > 1 ? parts[1] : ""
        roll()
        if journal.mistakes.contains(where: { $0.day == journal.day && $0.text == text }) { return }
        journal.mistakes.insert(StoredMistake(id: UUID().uuidString, text: text, fix: fix, day: journal.day), at: 0)
        if journal.mistakes.count > 40 { journal.mistakes = Array(journal.mistakes.prefix(40)) }
        publishJournal()
    }

    func markScene(_ id: String) {
        roll()
        if !journal.scenes.contains(id) { journal.scenes.append(id) }
        publishJournal()
    }

    func noteListen(ok: Bool) {
        roll()
        journal.listenTries += 1
        if ok { journal.listenOk += 1 }
        publishJournal()
    }

    func noteSaid() {
        roll()
        journal.said += 1
        publishJournal()
    }

    private func noteReview() {
        roll()
        journal.reviews += 1
        let day = journal.day
        journal.history[day, default: 0] += 1
        if journal.history.count > 40 {
            let keep = Set(journal.history.keys.sorted().suffix(40))
            journal.history = journal.history.filter { keep.contains($0.key) }
        }
        if journal.lastActive != day {
            let yesterday = Self.dayKey(Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
            journal.streak = journal.lastActive == yesterday ? journal.streak + 1 : 1
            journal.lastActive = day
        }
        publishJournal()
    }

    private func publishJournal() {
        journal = journal
        if let data = try? JSONEncoder().encode(journal) {
            try? data.write(to: journalURL, options: .atomic)
        }
    }

    private func roll() {
        let day = Self.dayKey()
        let month = String(day.prefix(7))
        var changed = false
        if journal.startDay.isEmpty { journal.startDay = day; changed = true }
        if journal.day != day {
            journal.day = day
            journal.reviews = 0
            changed = true
        }
        if journal.month != month {
            journal.month = month
            journal.monthSeconds = 0
            changed = true
        }
        if changed { publishJournal() }
    }

    static func dayKey(_ date: Date = Date()) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}

private extension String {
    func ifEmpty(_ fallback: String) -> String { isEmpty ? fallback : self }
}
