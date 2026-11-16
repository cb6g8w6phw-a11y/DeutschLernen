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
    var box: Int = 0
    var correct: Int = 0
    var wrong: Int = 0
    var due: Date = .distantPast
    var days: [String] = []
    var ease: Double = 2.5
    var gap: Int = 0
    var reps: Int = 0
    var lapses: Int = 0

    private enum CodingKeys: String, CodingKey { case box, correct, wrong, due, days, ease, gap, reps, lapses }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        box = try c.decodeIfPresent(Int.self, forKey: .box) ?? 0
        correct = try c.decodeIfPresent(Int.self, forKey: .correct) ?? 0
        wrong = try c.decodeIfPresent(Int.self, forKey: .wrong) ?? 0
        due = try c.decodeIfPresent(Date.self, forKey: .due) ?? .distantPast
        days = try c.decodeIfPresent([String].self, forKey: .days) ?? []
        ease = try c.decodeIfPresent(Double.self, forKey: .ease) ?? 2.5
        gap = try c.decodeIfPresent(Int.self, forKey: .gap) ?? 0
        reps = try c.decodeIfPresent(Int.self, forKey: .reps) ?? 0
        lapses = try c.decodeIfPresent(Int.self, forKey: .lapses) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(box, forKey: .box)
        try c.encode(correct, forKey: .correct)
        try c.encode(wrong, forKey: .wrong)
        try c.encode(due, forKey: .due)
        try c.encode(days, forKey: .days)
        try c.encode(ease, forKey: .ease)
        try c.encode(gap, forKey: .gap)
        try c.encode(reps, forKey: .reps)
        try c.encode(lapses, forKey: .lapses)
    }
}

enum ReviewAlgo {
    static func apply(_ stat: inout WordStat, quality: Int, now: Date = Date()) {
        let q = min(5, max(0, quality))
        var ease = stat.ease
        if ease < 1.3 { ease = 2.5 }
        ease += 0.1 - Double(5 - q) * (0.08 + Double(5 - q) * 0.02)
        if ease < 1.3 { ease = 1.3 }
        stat.ease = ease
        if q < 3 {
            stat.reps = 0
            stat.gap = 0
            stat.lapses += 1
            stat.due = Calendar.current.date(byAdding: .minute, value: 10, to: now) ?? now
            return
        }
        let interval: Int
        if stat.reps <= 0 { interval = 1 }
        else if stat.reps == 1 { interval = 6 }
        else { interval = max(stat.gap + 1, Int((Double(max(stat.gap, 1)) * ease).rounded())) }
        stat.reps += 1
        stat.gap = interval
        stat.box = min(stat.reps, 5)
        stat.due = Calendar.current.date(byAdding: .day, value: interval, to: now) ?? now
    }

    static func when(_ stat: WordStat) -> String {
        let left = stat.due.timeIntervalSinceNow
        if left < 3600 { return "Wróci za kilka minut." }
        let days = max(1, Int((left / 86400).rounded()))
        if days == 1 { return "Następna powtórka jutro." }
        return "Następna powtórka za \(days) dni."
    }
}

struct StoredMistake: Codable, Identifiable, Hashable {
    var id: String
    var text: String
    var fix: String
    var day: String
    var hits: Int

    init(id: String, text: String, fix: String, day: String, hits: Int = 0) {
        self.id = id
        self.text = text
        self.fix = fix
        self.day = day
        self.hits = hits
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        text = try c.decode(String.self, forKey: .text)
        fix = try c.decodeIfPresent(String.self, forKey: .fix) ?? ""
        day = try c.decodeIfPresent(String.self, forKey: .day) ?? ""
        hits = try c.decodeIfPresent(Int.self, forKey: .hits) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(text, forKey: .text)
        try c.encode(fix, forKey: .fix)
        try c.encode(day, forKey: .day)
        try c.encode(hits, forKey: .hits)
    }

    private enum CodingKeys: String, CodingKey { case id, text, fix, day, hits }
}

struct Journal: Codable {
    var startDay: String = ""
    var day: String = ""
    var reviews: Int = 0
    var month: String = ""
    var monthSeconds: Int = 0
    var listenOk: Int = 0
    var listenTries: Int = 0
    var listenSeconds: Int = 0
    var listenToday: Int = 0
    var listenTodayDay: String = ""
    var said: Int = 0
    var scenes: [String] = []
    var sceneStars: [String: Int] = [:]
    var mistakes: [StoredMistake] = []
    var streak: Int = 0
    var bestStreak: Int = 0
    var lastActive: String = ""
    var history: [String: Int] = [:]
    var todayOK: Int = 0
    var todayBad: Int = 0
    var skillListenOK: Int = 0
    var skillListenBad: Int = 0
    var skillGrammarOK: Int = 0
    var skillGrammarBad: Int = 0
    var skillSentenceOK: Int = 0
    var skillSentenceBad: Int = 0
    var skillSpeakOK: Int = 0
    var skillSpeakBad: Int = 0
    var skillVocabOK: Int = 0
    var skillVocabBad: Int = 0

    private enum CodingKeys: String, CodingKey {
        case startDay, day, reviews, month, monthSeconds, listenOk, listenTries, listenSeconds, listenToday, listenTodayDay, said, scenes, sceneStars, mistakes, streak, bestStreak, lastActive, history, todayOK, todayBad, skillListenOK, skillListenBad, skillGrammarOK, skillGrammarBad, skillSentenceOK, skillSentenceBad, skillSpeakOK, skillSpeakBad, skillVocabOK, skillVocabBad
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
        listenSeconds = try c.decodeIfPresent(Int.self, forKey: .listenSeconds) ?? 0
        listenToday = try c.decodeIfPresent(Int.self, forKey: .listenToday) ?? 0
        listenTodayDay = try c.decodeIfPresent(String.self, forKey: .listenTodayDay) ?? ""
        said = try c.decodeIfPresent(Int.self, forKey: .said) ?? 0
        scenes = try c.decodeIfPresent([String].self, forKey: .scenes) ?? []
        sceneStars = try c.decodeIfPresent([String: Int].self, forKey: .sceneStars) ?? [:]
        mistakes = try c.decodeIfPresent([StoredMistake].self, forKey: .mistakes) ?? []
        streak = try c.decodeIfPresent(Int.self, forKey: .streak) ?? 0
        bestStreak = try c.decodeIfPresent(Int.self, forKey: .bestStreak) ?? streak
        lastActive = try c.decodeIfPresent(String.self, forKey: .lastActive) ?? ""
        history = try c.decodeIfPresent([String: Int].self, forKey: .history) ?? [:]
        todayOK = try c.decodeIfPresent(Int.self, forKey: .todayOK) ?? 0
        todayBad = try c.decodeIfPresent(Int.self, forKey: .todayBad) ?? 0
        skillListenOK = try c.decodeIfPresent(Int.self, forKey: .skillListenOK) ?? 0
        skillListenBad = try c.decodeIfPresent(Int.self, forKey: .skillListenBad) ?? 0
        skillGrammarOK = try c.decodeIfPresent(Int.self, forKey: .skillGrammarOK) ?? 0
        skillGrammarBad = try c.decodeIfPresent(Int.self, forKey: .skillGrammarBad) ?? 0
        skillSentenceOK = try c.decodeIfPresent(Int.self, forKey: .skillSentenceOK) ?? 0
        skillSentenceBad = try c.decodeIfPresent(Int.self, forKey: .skillSentenceBad) ?? 0
        skillSpeakOK = try c.decodeIfPresent(Int.self, forKey: .skillSpeakOK) ?? 0
        skillSpeakBad = try c.decodeIfPresent(Int.self, forKey: .skillSpeakBad) ?? 0
        skillVocabOK = try c.decodeIfPresent(Int.self, forKey: .skillVocabOK) ?? 0
        skillVocabBad = try c.decodeIfPresent(Int.self, forKey: .skillVocabBad) ?? 0
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
        try c.encode(listenSeconds, forKey: .listenSeconds)
        try c.encode(listenToday, forKey: .listenToday)
        try c.encode(listenTodayDay, forKey: .listenTodayDay)
        try c.encode(said, forKey: .said)
        try c.encode(scenes, forKey: .scenes)
        try c.encode(sceneStars, forKey: .sceneStars)
        try c.encode(mistakes, forKey: .mistakes)
        try c.encode(streak, forKey: .streak)
        try c.encode(bestStreak, forKey: .bestStreak)
        try c.encode(lastActive, forKey: .lastActive)
        try c.encode(history, forKey: .history)
        try c.encode(todayOK, forKey: .todayOK)
        try c.encode(todayBad, forKey: .todayBad)
        try c.encode(skillListenOK, forKey: .skillListenOK)
        try c.encode(skillListenBad, forKey: .skillListenBad)
        try c.encode(skillGrammarOK, forKey: .skillGrammarOK)
        try c.encode(skillGrammarBad, forKey: .skillGrammarBad)
        try c.encode(skillSentenceOK, forKey: .skillSentenceOK)
        try c.encode(skillSentenceBad, forKey: .skillSentenceBad)
        try c.encode(skillSpeakOK, forKey: .skillSpeakOK)
        try c.encode(skillSpeakBad, forKey: .skillSpeakBad)
        try c.encode(skillVocabOK, forKey: .skillVocabOK)
        try c.encode(skillVocabBad, forKey: .skillVocabBad)
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
        t = t.replacingOccurrences(of: "ä", with: "ae")
            .replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue")
            .replacingOccurrences(of: "ß", with: "ss")
        let letters = t.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) || $0 == " " }
        return String(String.UnicodeScalarView(letters)).split(separator: " ").joined(separator: " ")
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
            let catalog = SeedContent.words + LifePack.words + DailyPack.words
            let known = Set(words.map { Normalizer.clean($0.de) })
            let extra = catalog.filter { !known.contains(Normalizer.clean($0.de)) }
            if !extra.isEmpty {
                words += extra
                save()
            }
        } else {
            words = SeedContent.words + LifePack.words + DailyPack.words
            stats = [:]
        }
        if let data = try? Data(contentsOf: journalURL),
           let saved = try? JSONDecoder().decode(Journal.self, from: data) {
            journal = saved
        }
        for key in stats.keys {
            var stat = stats[key]!
            if stat.days.count < 3, stat.box >= 3 {
                stat.box = min(stat.days.count, 2)
                stats[key] = stat
            }
        }
        save()
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
        noteOutcome(ok: correct)
        save()
    }

    func grade(_ w: Word, _ g: Grade, produced: Bool = false) {
        var s = stats[w.de] ?? WordStat()
        let today = Self.dayKey()
        switch g {
        case .hard:
            s.wrong += 1
            ReviewAlgo.apply(&s, quality: 1)
            UserDefaults.standard.set(w.de, forKey: "lastMiss")
        case .mid:
            s.correct += 1
            if !s.days.contains(today) { s.days.append(today) }
            ReviewAlgo.apply(&s, quality: 3)
            UserDefaults.standard.set(w.de, forKey: "lastHit")
        case .easy:
            s.correct += 1
            if !s.days.contains(today) { s.days.append(today) }
            ReviewAlgo.apply(&s, quality: produced ? 5 : 4)
            UserDefaults.standard.set(w.de, forKey: "lastHit")
        }
        stats[w.de] = s
        noteSkill(produced ? "sentence" : "vocab", ok: g != .hard)
        save()
    }

    /// Zostawione dla starych wywołań. Teraz liczy odstęp algorytmem SM-2, nie stałe 2 dni.
    func parkTwoDays(_ w: Word) {
        grade(w, .easy)
    }

    func scheduleTomorrow(_ w: Word) {
        var s = stats[w.de] ?? WordStat()
        s.wrong += 1
        if s.days.count > 1 { s.days.removeLast() }
        s.box = min(s.days.count, 5)
        s.due = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        stats[w.de] = s
        UserDefaults.standard.set(w.de, forKey: "lastMiss")
        noteOutcome(ok: false)
        save()
    }

    /// Sesja: najpierw słabe/zaległe powtórki, potem kilka nowych z puli 10 000.
    func nextSession(size: Int = 8, maxNew: Int = 4, level: String = "oba") -> [Word] {
        let pool = catalog(level: level)
        let now = Date()
        let reviews = pool.filter { w in
            if let s = stats[w.de] { return s.due <= now }
            return false
        }.sorted { a, b in
            let sa = stats[a.de]!, sb = stats[b.de]!
            if sa.due != sb.due { return sa.due < sb.due }
            if sa.ease != sb.ease { return sa.ease < sb.ease }
            return sa.wrong > sb.wrong
        }
        let reviewCap = min(reviews.count, max(2, size / 2))
        var out = Array(reviews.prefix(reviewCap))
        let recent = Set(UserDefaults.standard.stringArray(forKey: "recentNewWords") ?? [])
        func take(_ list: [Word]) {
            for word in list where out.count < size && !out.contains(where: { $0.de == word.de }) {
                out.append(word)
            }
        }
        take(pool.filter { stats[$0.de] == nil && !recent.contains($0.de) }.shuffled())
        take(pool.filter { stats[$0.de] == nil }.shuffled())
        take(pool.filter { word in
            (stats[word.de]?.days.count ?? 0) < 3 && !recent.contains(word.de)
        }.shuffled())
        if out.isEmpty {
            out = Array(pool.shuffled().prefix(max(size, 1)))
        }
        var memory = UserDefaults.standard.stringArray(forKey: "recentNewWords") ?? []
        for word in out where stats[word.de] == nil {
            memory.append(word.de)
            keep(word)
        }
        if memory.count > 400 { memory = Array(memory.suffix(400)) }
        UserDefaults.standard.set(memory, forKey: "recentNewWords")
        return out
    }

    func catalog(level: String) -> [Word] {
        let allow = Self.bands(level)
        var seen = Set<String>()
        var out: [Word] = []
        for word in FreqBank.all + words {
            if !allow.isEmpty && !allow.contains(word.level) { continue }
            let key = word.de.lowercased()
            if seen.insert(key).inserted { out.append(word) }
        }
        return out
    }

    static func bands(_ level: String) -> Set<String> {
        switch level {
        case "A1": return ["A1"]
        case "A2": return ["A2"]
        case "B1": return ["B1"]
        case "B2": return ["B2"]
        case "oba": return ["A1", "A2"]
        default: return []
        }
    }

    private func keep(_ word: Word) {
        let key = Normalizer.clean(word.de)
        guard !words.contains(where: { Normalizer.clean($0.de) == key }) else { return }
        words.append(word)
        save()
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
        words = SeedContent.words + LifePack.words + DailyPack.words
        stats = [:]
        save()
    }

    // MARK: statystyki

    var masteredCount: Int { stats.values.filter { $0.days.count >= 3 }.count }
    var learningCount: Int { stats.values.filter { $0.days.count < 3 }.count }
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
        [("A1", FreqBank.count("A1")), ("A2", FreqBank.count("A2")), ("B1", FreqBank.count("B1")), ("B2", FreqBank.count("B2"))]
    }

    func bandProgress() -> [(name: String, known: Int, total: Int)] {
        var levelOf: [String: String] = [:]
        for word in words { levelOf[word.de] = word.level }
        for word in FreqBank.all where levelOf[word.de] == nil { levelOf[word.de] = word.level }
        var known = ["A1": 0, "A2": 0, "B1": 0, "B2": 0]
        for (de, stat) in stats where stat.days.count >= 3 {
            let level = known[levelOf[de] ?? ""] != nil ? (levelOf[de] ?? "A2") : "A2"
            known[level, default: 0] += 1
        }
        return ["A1", "A2", "B1", "B2"].map { name in
            (name, known[name] ?? 0, max(FreqBank.count(name), 1))
        }
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
        UserDefaults.standard.set(Self.dayKey(), forKey: "didTalkDay")
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

    func gradeMistake(_ id: String, ok: Bool) {
        guard let index = journal.mistakes.firstIndex(where: { $0.id == id }) else { return }
        if ok {
            journal.mistakes[index].hits += 1
            if journal.mistakes[index].hits >= 2 { journal.mistakes.remove(at: index) }
        } else {
            journal.mistakes[index].hits = 0
        }
        publishJournal()
    }

    func markScene(_ id: String) {
        roll()
        if !journal.scenes.contains(id) { journal.scenes.append(id) }
        publishJournal()
    }

    func stars(for id: String) -> Int { journal.sceneStars[id] ?? 0 }

    func awardStars(_ id: String, _ n: Int) {
        roll()
        let next = min(3, max(journal.sceneStars[id] ?? 0, n))
        journal.sceneStars[id] = next
        if !journal.scenes.contains(id) { journal.scenes.append(id) }
        publishJournal()
    }

    var scenesClean: Int { journal.sceneStars.values.filter { $0 >= 3 }.count }

    func sceneUnlocked(_ index: Int) -> Bool {
        guard index > 0 else { return true }
        let prev = Scenarios.all[index - 1].id
        return stars(for: prev) >= 1
    }

    func noteListen(ok: Bool) {
        roll()
        journal.listenTries += 1
        if ok { journal.listenOk += 1 }
        UserDefaults.standard.set(journal.day, forKey: "didListenDay")
        noteSkill("listen", ok: ok)
    }

    func revealListenTime() {
        roll()
        let day = Self.dayKey()
        if journal.listenTodayDay != day {
            journal.listenTodayDay = day
            journal.listenToday = 0
        }
        guard !UserDefaults.standard.bool(forKey: "listenSecondsBackfill") else {
            publishJournal()
            return
        }
        journal.listenSeconds += journal.listenTries * 40
        UserDefaults.standard.set(true, forKey: "listenSecondsBackfill")
        publishJournal()
    }

    static func minuteText(_ seconds: Int) -> String {
        let m = max(0, seconds / 60)
        if m == 1 { return "1 minuta" }
        let mod10 = m % 10
        let mod100 = m % 100
        if mod10 >= 2 && mod10 <= 4 && !(mod100 >= 12 && mod100 <= 14) { return "\(m) minuty" }
        return "\(m) minut"
    }

    func noteSaid(ok: Bool = false) {
        roll()
        journal.said += 1
        noteSkill("speak", ok: ok)
    }

    func noteSkill(_ name: String, ok: Bool) {
        roll()
        switch name {
        case "listen":
            if ok { journal.skillListenOK += 1 } else { journal.skillListenBad += 1 }
        case "grammar":
            if ok { journal.skillGrammarOK += 1 } else { journal.skillGrammarBad += 1 }
        case "sentence":
            if ok { journal.skillSentenceOK += 1 } else { journal.skillSentenceBad += 1 }
        case "speak":
            if ok { journal.skillSpeakOK += 1 } else { journal.skillSpeakBad += 1 }
        default:
            if ok { journal.skillVocabOK += 1 } else { journal.skillVocabBad += 1 }
        }
        if ok { journal.todayOK += 1 } else { journal.todayBad += 1 }
        noteReview()
    }

    private func noteOutcome(ok: Bool) {
        roll()
        if ok { journal.todayOK += 1 } else { journal.todayBad += 1 }
        noteReview()
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
            journal.bestStreak = max(journal.bestStreak, journal.streak)
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
            journal.todayOK = 0
            journal.todayBad = 0
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
