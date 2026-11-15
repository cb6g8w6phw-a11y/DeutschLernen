import AudioToolbox
import SwiftUI

struct LessonResult: Codable, Identifiable, Equatable {
    var id: String
    var at: Date
    var day: String
    var kind: String
    var title: String
    var level: String
    var correct: Int
    var wrong: Int
    var seconds: Int
    var seenWords: Int
    var remembered: Int
    var misses: [String]
    var xp: Int
    var badge: String
    var nextTitle: String
    var nextBlurb: String
    var nextTab: Int
    var nextID: String
    var sourceID: String
    var area: String

    var percent: Int {
        let total = correct + wrong
        guard total > 0 else { return 0 }
        return Int((Double(correct) / Double(total) * 100).rounded())
    }

    enum CodingKeys: String, CodingKey {
        case id, at, day, kind, title, level, correct, wrong, seconds, seenWords, remembered, misses, xp, badge, nextTitle, nextBlurb, nextTab, nextID, sourceID, area
    }

    init(id: String, at: Date, day: String, kind: String, title: String, level: String, correct: Int, wrong: Int, seconds: Int, seenWords: Int, remembered: Int, misses: [String], xp: Int, badge: String, nextTitle: String, nextBlurb: String, nextTab: Int, nextID: String, sourceID: String, area: String) {
        self.id = id
        self.at = at
        self.day = day
        self.kind = kind
        self.title = title
        self.level = level
        self.correct = correct
        self.wrong = wrong
        self.seconds = seconds
        self.seenWords = seenWords
        self.remembered = remembered
        self.misses = misses
        self.xp = xp
        self.badge = badge
        self.nextTitle = nextTitle
        self.nextBlurb = nextBlurb
        self.nextTab = nextTab
        self.nextID = nextID
        self.sourceID = sourceID
        self.area = area
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        at = try c.decode(Date.self, forKey: .at)
        day = try c.decode(String.self, forKey: .day)
        kind = try c.decode(String.self, forKey: .kind)
        title = try c.decode(String.self, forKey: .title)
        level = try c.decode(String.self, forKey: .level)
        correct = try c.decode(Int.self, forKey: .correct)
        wrong = try c.decode(Int.self, forKey: .wrong)
        seconds = try c.decode(Int.self, forKey: .seconds)
        seenWords = try c.decode(Int.self, forKey: .seenWords)
        remembered = try c.decode(Int.self, forKey: .remembered)
        misses = try c.decode([String].self, forKey: .misses)
        xp = try c.decode(Int.self, forKey: .xp)
        badge = try c.decode(String.self, forKey: .badge)
        nextTitle = try c.decode(String.self, forKey: .nextTitle)
        nextBlurb = try c.decode(String.self, forKey: .nextBlurb)
        nextTab = try c.decode(Int.self, forKey: .nextTab)
        nextID = try c.decode(String.self, forKey: .nextID)
        sourceID = try c.decode(String.self, forKey: .sourceID)
        area = try c.decodeIfPresent(String.self, forKey: .area) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(at, forKey: .at)
        try c.encode(day, forKey: .day)
        try c.encode(kind, forKey: .kind)
        try c.encode(title, forKey: .title)
        try c.encode(level, forKey: .level)
        try c.encode(correct, forKey: .correct)
        try c.encode(wrong, forKey: .wrong)
        try c.encode(seconds, forKey: .seconds)
        try c.encode(seenWords, forKey: .seenWords)
        try c.encode(remembered, forKey: .remembered)
        try c.encode(misses, forKey: .misses)
        try c.encode(xp, forKey: .xp)
        try c.encode(badge, forKey: .badge)
        try c.encode(nextTitle, forKey: .nextTitle)
        try c.encode(nextBlurb, forKey: .nextBlurb)
        try c.encode(nextTab, forKey: .nextTab)
        try c.encode(nextID, forKey: .nextID)
        try c.encode(sourceID, forKey: .sourceID)
        try c.encode(area, forKey: .area)
    }
}

enum ProgressBook {
    private static let key = "lessonResults"

    static func all() -> [LessonResult] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let rows = try? JSONDecoder().decode([LessonResult].self, from: data) else { return [] }
        return rows.sorted { $0.at > $1.at }
    }

    static func add(_ row: LessonResult) {
        var rows = all()
        rows.insert(row, at: 0)
        if rows.count > 200 { rows = Array(rows.prefix(200)) }
        if let data = try? JSONEncoder().encode(rows) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func xp() -> Int { all().reduce(0) { $0 + $1.xp } }

    static func dayStamp(_ date: Date = Date()) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }

    static func todayCount() -> Int {
        let day = Self.dayStamp()
        return all().filter { $0.day == day }.count
    }

    static func daysThisWeek() -> Int {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        let days = Set(all().filter { $0.at >= start }.map(\.day))
        return days.count
    }

    static func previousWeekCount() -> Int {
        let cal = Calendar.current
        guard let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())),
              let prev = cal.date(byAdding: .day, value: -7, to: start) else { return 0 }
        return all().filter { $0.at >= prev && $0.at < start }.count
    }

    static func make(kind: String, title: String, level: String, sourceID: String, area: String, correct: Int, wrong: Int, seconds: Int, seenWords: Int, remembered: Int, misses: [String], streak: Int) -> LessonResult {
        var cleanMiss: [String] = []
        for miss in misses where !cleanMiss.contains(miss) { cleanMiss.append(miss) }
        let xp = correct * 4 + (wrong == 0 && correct > 0 ? 6 : 0) + remembered
        var badge = ""
        if wrong == 0, correct >= 2 { badge = "Bez błędu" }
        else if streak >= 7 { badge = "Tydzień z rzędu" }
        else if todayCount() == 0 { badge = "Pierwsza dziś" }
        let next = suggest(kind: kind, misses: cleanMiss, title: title, level: level, area: area, sourceID: sourceID)
        return LessonResult(
            id: UUID().uuidString,
            at: Date(),
            day: Self.dayStamp(),
            kind: kind,
            title: title,
            level: level,
            correct: correct,
            wrong: wrong,
            seconds: max(1, seconds),
            seenWords: seenWords,
            remembered: remembered,
            misses: cleanMiss,
            xp: xp,
            badge: badge,
            nextTitle: next.title,
            nextBlurb: next.blurb,
            nextTab: next.tab,
            nextID: next.id,
            sourceID: sourceID,
            area: area
        )
    }

    static func strengths(_ row: LessonResult) -> [String] {
        var lines: [String] = []
        if row.percent >= 80, row.correct >= 2 {
            if row.kind == "dialog" { lines.append("Dobrze rozumiesz prostą rozmowę.") }
            else if row.kind == "grammar" { lines.append("Ten wzorzec już łapiesz.") }
            else { lines.append("Większość odpowiedzi w tej lekcji była dobra.") }
        }
        if row.kind == "dialog", row.correct + row.wrong >= 3, !row.misses.contains("Pytanie o całą historię") {
            lines.append("Rozumienie prostych pytań")
        }
        if row.kind == "text", row.correct + row.wrong >= 2, !row.misses.contains("Pytanie o całą historię") {
            lines.append("Rozumiesz cały tekst, nie tylko jedno zdanie.")
        }
        if row.remembered > 0, isWork(row.area) {
            lines.append("Zwroty z pracy zapisane w słowniku: \(row.remembered).")
        } else if row.remembered > 0 {
            lines.append("Słownictwo z tej lekcji: \(row.remembered) w słowniku.")
        }
        if row.misses.isEmpty, row.correct > 0 {
            lines.append("W tej lekcji nie było błędu do wskazania.")
        }
        return lines
    }

    static func drills(_ miss: String) -> String {
        switch miss {
        case "Szyk zdania": return "Ułóż jeszcze raz zdanie ze wzorca, od czasownika."
        case "Rodzajniki der, die, das": return "Powiedz rodzajnik na głos przy trzech rzeczownikach z lekcji."
        case "Akkusativ i Dativ": return "Zamień jedno zdanie: komu i kogo."
        case "Czas przeszły Perfekt": return "Powiedz to samo zdanie w Perfekt, z haben albo sein."
        case "Odpowiedź bez podpowiedzi": return "Zamknij wzorzec i napisz zdanie jeszcze raz."
        case "Pytanie o całą historię": return "Przeczytaj od początku i wskaż, o co chodziło w całości."
        case "Kto mówi na końcu": return "Przejdź wypowiedzi od ostatniej do pierwszej."
        default: return "Wróć do tego jednego miejsca, nie do całej aplikacji."
        }
    }

    static func lemma(_ de: String) -> String {
        var text = de.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        for prefix in ["der ", "die ", "das ", "den ", "dem ", "des ", "ein ", "eine ", "einen "] where text.hasPrefix(prefix) {
            text.removeFirst(prefix.count)
            break
        }
        return text.trimmingCharacters(in: .punctuationCharacters)
    }

    static func savedLemmas() -> [String] {
        guard let data = UserDefaults.standard.data(forKey: "myVocab"),
              let list = try? JSONDecoder().decode([Vocab].self, from: data) else { return [] }
        var out: [String] = []
        for card in list {
            let word = lemma(card.de)
            if word.count > 2, !out.contains(word) { out.append(word) }
        }
        return out
    }

    static func levelScore(_ have: String, _ want: String) -> Int {
        if have == want { return 6 }
        let order = ["A1", "A2", "B1", "B2"]
        guard let i = order.firstIndex(of: have), let j = order.firstIndex(of: want) else { return 0 }
        return abs(i - j) == 1 ? 2 : 0
    }

    static func nextLevel(_ level: String) -> String {
        switch level {
        case "A1": return "A2"
        case "A2": return "B1"
        case "B1": return "B2"
        default: return level
        }
    }

    private static func suggest(kind: String, misses: [String], title: String, level: String, area: String, sourceID: String) -> (title: String, blurb: String, tab: Int, id: String) {
        let saved = savedLemmas()
        if misses.contains(where: { $0.contains("Odpowiedź") }) {
            let why = "Samodzielne zdanie nie weszło. Następna lekcja ćwiczy układanie zdania, nie kolejną pozycję z listy."
            if let hit = grammarPick(needles: ["szyk zdania", "budowanie pytań"], level: level, saved: saved, why: why) {
                return hit
            }
        }
        if misses.contains(where: { $0.contains("Szyk") }) {
            if let hit = grammarPick(needles: ["szyk zdania"], level: level, saved: saved, why: "Szyk zdania uciekł. Bierzesz wzorzec z tego, nie pierwszą wolną lekcję.") {
                return hit
            }
        }
        if misses.contains(where: { $0.contains("Perfekt") }) {
            if let hit = grammarPick(needles: ["perfekt"], level: level, saved: saved, why: "Perfekt nie usiadł. Następna lekcja jest z przeszłości, nie z innej półki.") {
                return hit
            }
        }
        if misses.contains(where: { $0.contains("Rodzaj") }) {
            if let hit = grammarPick(needles: ["rodzaj"], level: level, saved: saved, why: "Rodzajnik uciekł. Następna lekcja jest o der, die, das.") {
                return hit
            }
        }
        if misses.contains(where: { $0.contains("Akkusativ") || $0.contains("Dativ") || $0.contains("Przypad") }) {
            if let hit = grammarPick(needles: ["przypadki", "dativ", "akkusativ"], level: level, saved: saved, why: "Przypadek uciekł. Następna lekcja jest o den i dem.") {
                return hit
            }
        }
        if let raw = misses.first(where: { $0.hasPrefix("Wzorzec:") }) {
            let needle = raw.replacingOccurrences(of: "Wzorzec:", with: "").trimmingCharacters(in: .whitespaces).lowercased()
            if let hit = grammarPick(needles: [needle], level: level, saved: saved, why: "Ten wzorzec jeszcze nie siadł. Wracasz do niego, nie do pierwszej wolnej lekcji.") {
                return hit
            }
        }
        if misses.contains(where: { $0.contains("Pytanie o całą") }) {
            if let hit = textPick(level: level, area: area, saved: saved, avoid: sourceID, why: "Pytanie o całość nie weszło. Następny jest tekst ciągły, nie kolejny dialog z listy.") {
                return hit
            }
        }
        if misses.contains("Kto mówi na końcu") {
            if let hit = scenePick(level: level, area: area, saved: saved, avoidTitle: title, avoidID: sourceID, why: "Uciekło, kto mówi na końcu. Biorę inną rozmowę na tym poziomie, nie pierwszą niedokończoną.") {
                return hit
            }
        }
        if kind == "grammar", let hit = sameTopic(area: area, title: title, level: level) {
            return hit
        }
        if kind == "text", let hit = textPick(level: level, area: area, saved: saved, avoid: sourceID, why: saved.isEmpty ? "Ten tekst jest zapisany. Dalej inna historia na tym poziomie, nie kolejna z brzegu." : "Dalej historia, w której jest zapisane słówko.") {
            return hit
        }
        if let hit = scenePick(level: level, area: area, saved: saved, avoidTitle: title, avoidID: sourceID, why: saved.isEmpty ? "Dalej inna rozmowa na tym poziomie. Nie biorę jej tylko dlatego, że jest następna na liście." : "Dalej rozmowa, w której jest zapisane słówko.") {
            return hit
        }
        if let hit = textPick(level: level, area: area, saved: saved, avoid: sourceID, why: "Została historia na tym poziomie.") {
            return hit
        }
        return ("Powtórka", "Na dziś nie ma nowej lekcji z tej półki. Wróć do błędów.", 0, "")
    }

    private static func grammarPick(needles: [String], level: String, saved: [String], why: String) -> (title: String, blurb: String, tab: Int, id: String)? {
        let done = GrammarBook.doneIDs()
        var best: (GLesson, Int)?
        for lesson in GrammarBook.lessons {
            let blob = (lesson.topic + " " + lesson.title).lowercased()
            var score = 0
            for (index, needle) in needles.enumerated() where blob.contains(needle) {
                score += 24 - index * 3
            }
            if score == 0 { continue }
            score += levelScore(lesson.level, level)
            if !done.contains(lesson.id) { score += 3 }
            let examples = (lesson.examples + lesson.work).map(\.de).joined(separator: " ").lowercased()
            if saved.contains(where: { examples.contains($0) }) { score += 4 }
            if best == nil || score > best!.1 { best = (lesson, score) }
        }
        guard let best else { return nil }
        let linked = scenePick(level: level, area: "", saved: saved, avoidTitle: "", avoidID: "", why: "")
        let extra = linked == nil ? "" : " Potem to samo w rozmowie: \(linked!.title)."
        let word = saved.first.map { " Zapisane słówko „\($0)” zostaje w powtórkach." } ?? ""
        return (best.0.title, why + extra + word, 6, best.0.id)
    }

    private static func sameTopic(area: String, title: String, level: String) -> (title: String, blurb: String, tab: Int, id: String)? {
        let done = GrammarBook.doneIDs()
        var best: (GLesson, Int)?
        for lesson in GrammarBook.lessons where lesson.topic == area && lesson.title != title {
            var score = levelScore(lesson.level, level)
            if lesson.level == nextLevel(level) { score += 4 }
            if !done.contains(lesson.id) { score += 10 }
            if best == nil || score > best!.1 { best = (lesson, score) }
        }
        guard let best else { return nil }
        return (best.0.title, "Ten wzorzec już był. Dalej ten sam temat: \(best.0.title), nie pierwsza wolna lekcja z innej półki.", 6, best.0.id)
    }

    private static func rank(_ id: String) -> Int { Int(id.filter(\.isNumber)) ?? 0 }

    private static func better(score: Int, id: String, bestScore: Int?, bestID: String?, avoid: String) -> Bool {
        guard let bestScore, let bestID else { return true }
        if score != bestScore { return score > bestScore }
        guard !avoid.isEmpty else { return rank(id) < rank(bestID) }
        let next = rank(avoid) + 1
        let candNext = rank(id) == next
        let bestNext = rank(bestID) == next
        if candNext != bestNext { return !candNext }
        return rank(id) < rank(bestID)
    }

    private static func textPick(level: String, area: String, saved: [String], avoid: String, why: String) -> (title: String, blurb: String, tab: Int, id: String)? {
        let done = TextBook.doneIDs()
        var best: (ReadText, Int)?
        for text in TextBook.all where text.id != avoid {
            var score = levelScore(text.level, level)
            if !done.contains(text.id) { score += 2 }
            if !area.isEmpty, text.category != area { score += 1 }
            let blob = text.german.lowercased()
            score += saved.filter { blob.contains($0) }.count * 8
            if better(score: score, id: text.id, bestScore: best?.1, bestID: best?.0.id, avoid: avoid) {
                best = (text, score)
            }
        }
        guard let best else { return nil }
        let hitWord = saved.first { best.0.german.lowercased().contains($0) }
        let because = hitWord.map { " Jest w niej zapisane słówko „\($0)”." } ?? ""
        return (best.0.title, why + " \(best.0.title), \(best.0.category), poziom \(best.0.level)." + because, 12, best.0.id)
    }

    private static func scenePick(level: String, area: String, saved: [String], avoidTitle: String, avoidID: String, why: String) -> (title: String, blurb: String, tab: Int, id: String)? {
        let done = MiniProgress.doneIDs()
        var best: (MiniScene, Int)?
        for scene in MiniBook.all where scene.id != avoidID && scene.title != avoidTitle {
            var score = levelScore(scene.level, level)
            if !done.contains(scene.id) { score += 2 }
            if !area.isEmpty, scene.category != area { score += 2 }
            let blob = (scene.lines.map(\.de) + scene.words.map(\.de) + [scene.replyDE]).joined(separator: " ").lowercased()
            score += saved.filter { blob.contains($0) }.count * 8
            if better(score: score, id: scene.id, bestScore: best?.1, bestID: best?.0.id, avoid: avoidID) {
                best = (scene, score)
            }
        }
        guard let best else { return nil }
        let blob = (best.0.lines.map(\.de) + best.0.words.map(\.de)).joined(separator: " ").lowercased()
        let because = saved.first { blob.contains($0) }.map { " Jest w niej zapisane słówko „\($0)”." } ?? ""
        return (best.0.title, why + " \(best.0.title), \(best.0.category), poziom \(best.0.level)." + because, 5, best.0.id)
    }

    static func isWork(_ area: String) -> Bool {
        switch area {
        case "W pracy", "Na budowie", "Rozmowy z szefem", "Rozmowy ze współpracownikami":
            return true
        default:
            return false
        }
    }

    static func skill(_ kind: String, _ title: String) -> String {
        let rows = all().filter { $0.kind == kind }
        guard !rows.isEmpty else { return "\(title): jeszcze nie było takiej lekcji." }
        let ok = rows.reduce(0) { $0 + $1.correct }
        let bad = rows.reduce(0) { $0 + $1.wrong }
        let total = ok + bad
        let pct = total == 0 ? 0 : ok * 100 / total
        return "\(title): \(pct)% z \(rows.count) lekcji."
    }

    static func workLine() -> String {
        let rows = all().filter { isWork($0.area) }
        guard !rows.isEmpty else { return "Niemiecki w pracy: jeszcze nie było takiej lekcji." }
        let ok = rows.reduce(0) { $0 + $1.correct }
        let bad = rows.reduce(0) { $0 + $1.wrong }
        let total = ok + bad
        let pct = total == 0 ? 0 : ok * 100 / total
        return "Niemiecki w pracy: \(pct)% z \(rows.count) lekcji."
    }

    static func counterLine(_ title: String, ok: Int, bad: Int) -> String {
        let total = ok + bad
        guard total > 0 else { return "\(title): jeszcze nie było takiej lekcji." }
        return "\(title): \(ok * 100 / total)% z \(total) odpowiedzi."
    }
}

extension Notification.Name {
    static let jumpTab = Notification.Name("jumpTab")
}

enum Go {
    static func tab(_ n: Int, scene: String? = nil, grammar: String? = nil, text: String? = nil) {
        if let scene { UserDefaults.standard.set(scene, forKey: "jumpScene") }
        if let grammar { UserDefaults.standard.set(grammar, forKey: "jumpGrammar") }
        if let text { UserDefaults.standard.set(text, forKey: "jumpText") }
        NotificationCenter.default.post(name: .jumpTab, object: n)
    }
}

struct LessonDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: LearningStore
    let result: LessonResult
    @AppStorage("lessonMotion") private var motion = true
    @AppStorage("dailyGoal") private var dailyGoal = 20
    @State private var showScore = 0
    @State private var burst = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ZStack {
                    if motion { burstLayer }
                    VStack(spacing: 8) {
                        Text("Lekcja ukończona!")
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Theme.ok.opacity(0.18), in: Capsule())
                            .foregroundStyle(Theme.ok)
                        Text(result.percent >= 80 ? "Świetna robota!" : "Lekcja zapisana")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.ok)
                        Text("\(showScore)%")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                        Text("Poprawne odpowiedzi")
                            .foregroundStyle(Theme.text2)
                        progressBar
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack(spacing: 8) {
                    stat("\(result.correct)/\(result.correct + result.wrong)", "Odpowiedzi")
                    stat(timeText, "Czas nauki")
                    stat("\(result.seenWords)", "Nowe słowa")
                }
                Text("Zapamiętane słówka: \(result.remembered). Błędne odpowiedzi: \(result.wrong).")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                if !result.badge.isEmpty {
                    Label(result.badge, systemImage: "seal.fill")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Theme.ok.opacity(0.16), in: Capsule())
                        .foregroundStyle(Theme.ok)
                }
                Divider().overlay(Color.white.opacity(0.12))
                block("Co idzie Ci dobrze?", ProgressBook.strengths(result))
                if !result.misses.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nad czym warto popracować?").font(.headline)
                        ForEach(result.misses, id: \.self) { miss in
                            VStack(alignment: .leading, spacing: 2) {
                                Label(miss, systemImage: "target")
                                    .foregroundStyle(Theme.sign)
                                Text(ProgressBook.drills(miss))
                                    .font(.footnote)
                                    .foregroundStyle(Theme.text2)
                            }
                        }
                    }
                }
                Divider().overlay(Color.white.opacity(0.12))
                VStack(alignment: .leading, spacing: 8) {
                    Text("Twoja następna lekcja").font(.headline)
                    Text("Polecana")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Theme.ok.opacity(0.18), in: Capsule())
                        .foregroundStyle(Theme.ok)
                    Text(result.nextTitle).font(.title3.bold())
                    Text(result.nextBlurb).foregroundStyle(Theme.text2)
                }
                VStack(spacing: 6) {
                    Text("+ \(result.xp) XP")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.ok)
                    Text("Punkty doświadczenia")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    Text("Razem \(ProgressBook.xp()) XP · seria \(store.streak) \(store.streak == 1 ? "dzień" : "dni")")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    Text("Cel dzienny: \(min(store.reviewsToday, dailyGoal))/\(dailyGoal) słówek")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    Text(weekLine).font(.footnote).foregroundStyle(Theme.text2)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                Button("Rozpocznij polecaną lekcję") { open(result.nextTab) }
                    .buttonStyle(DoneButton())
                Button("Powtórz błędy") {
                    if result.kind == "grammar" { Go.tab(6, grammar: result.sourceID) }
                    else if result.kind == "text" { Go.tab(12, text: result.sourceID) }
                    else { Go.tab(5, scene: result.sourceID) }
                    dismiss()
                }
                .buttonStyle(.glass)
                Button("Przećwicz nowe słówka") { Go.tab(1); dismiss() }.buttonStyle(.glass)
                Button("Wróć do strony głównej") { Go.tab(0); dismiss() }.buttonStyle(.glass)
                WeekSkills()
            }
            .padding(16)
            .padding(.bottom, 28)
        }
        .background(NightGlow())
        .onAppear {
            guard motion else { showScore = result.percent; return }
            if result.percent >= 80 {
                Haptic.good()
                AudioServicesPlaySystemSound(1057)
            }
            withAnimation(.easeOut(duration: 0.85)) { burst = true }
            let target = result.percent
            Task { @MainActor in
                if target == 0 { showScore = 0; return }
                for step in stride(from: 0, through: target, by: max(1, target / 12)) {
                    showScore = step
                    try? await Task.sleep(nanoseconds: 40_000_000)
                }
                showScore = target
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.12))
                Capsule().fill(Theme.ok)
                    .frame(width: geo.size.width * CGFloat(showScore) / 100)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 36)
    }

    private var timeText: String {
        if result.seconds < 60 { return "\(result.seconds) s" }
        return "\(result.seconds / 60) min"
    }

    private var weekLine: String {
        let now = ProgressBook.daysThisWeek()
        let prev = ProgressBook.previousWeekCount()
        if prev == 0 { return "W tym tygodniu dni z lekcją: \(now)." }
        return "W tym tygodniu dni z lekcją: \(now). W poprzednim tygodniu lekcji: \(prev)."
    }

    private func stat(_ value: String, _ caption: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.headline)
            Text(caption).font(.caption).foregroundStyle(Theme.text2).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 74)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func block(_ title: String, _ lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            if lines.isEmpty {
                Text("Za mało dobrych odpowiedzi, żeby to chwalić.").foregroundStyle(Theme.text2)
            }
            ForEach(lines, id: \.self) { line in
                Label(line, systemImage: "checkmark.circle.fill").foregroundStyle(Theme.ok)
            }
        }
    }

    private func open(_ tab: Int) {
        if result.nextTab == 5, !result.nextID.isEmpty {
            Go.tab(5, scene: result.nextID)
        } else if result.nextTab == 6, !result.nextID.isEmpty {
            Go.tab(6, grammar: result.nextID)
        } else if result.nextTab == 12, !result.nextID.isEmpty {
            Go.tab(12, text: result.nextID)
        } else {
            Go.tab(tab)
        }
        dismiss()
    }

    private var burstLayer: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Image(systemName: i.isMultiple(of: 3) ? "star.fill" : "circle.fill")
                    .font(.system(size: i.isMultiple(of: 3) ? 13 : 6))
                    .foregroundStyle(i.isMultiple(of: 2) ? Theme.ok : Theme.sign)
                    .offset(x: burst ? CGFloat((i * 37 % 220) - 110) : 0, y: burst ? CGFloat(-16 - (i * 11 % 64)) : 18)
                    .opacity(burst ? 0 : 0.95)
            }
        }
        .frame(height: 10)
        .allowsHitTesting(false)
    }
}

private struct DoneButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundStyle(Theme.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Theme.ok, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct WeekSkills: View {
    @EnvironmentObject var store: LearningStore

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Postęp z zapisanych lekcji").font(.headline)
            Text(ProgressBook.skill("dialog", "Mini dialogi"))
            Text(ProgressBook.skill("text", "Teksty i historie"))
            Text(ProgressBook.skill("grammar", "Gramatyka"))
            Text(ProgressBook.workLine())
            Text(ProgressBook.counterLine("Słownictwo", ok: store.journal.skillVocabOK, bad: store.journal.skillVocabBad))
            Text(ProgressBook.counterLine("Słuchanie", ok: store.journal.skillListenOK, bad: store.journal.skillListenBad))
            Text(ProgressBook.counterLine("Rozmowa", ok: store.journal.skillSpeakOK, bad: store.journal.skillSpeakBad))
            Text("Procent jest z prawdziwych odpowiedzi. Pusta półka nie dostaje liczby.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
        }
    }
}