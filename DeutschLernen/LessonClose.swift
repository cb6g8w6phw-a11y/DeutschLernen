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

    var percent: Int {
        let total = correct + wrong
        guard total > 0 else { return 0 }
        return Int((Double(correct) / Double(total) * 100).rounded())
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

    static func todayCount() -> Int {
        let day = LearningStore.dayKey()
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

    static func make(kind: String, title: String, level: String, sourceID: String, correct: Int, wrong: Int, seconds: Int, seenWords: Int, remembered: Int, misses: [String], streak: Int) -> LessonResult {
        var cleanMiss: [String] = []
        for miss in misses where !cleanMiss.contains(miss) { cleanMiss.append(miss) }
        let xp = correct * 4 + (wrong == 0 && correct > 0 ? 6 : 0) + remembered
        var badge = ""
        if wrong == 0, correct >= 2 { badge = "Bez błędu" }
        else if streak >= 7 { badge = "Tydzień z rzędu" }
        else if todayCount() == 0 { badge = "Pierwsza dziś" }
        let next = suggest(kind: kind, misses: cleanMiss, title: title)
        return LessonResult(
            id: UUID().uuidString,
            at: Date(),
            day: LearningStore.dayKey(),
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
            sourceID: sourceID
        )
    }

    static func strengths(_ row: LessonResult) -> [String] {
        var lines: [String] = []
        if row.percent >= 80, row.correct > 0 {
            if row.kind == "dialog" { lines.append("Dobrze rozumiesz prostą rozmowę.") }
            else if row.kind == "grammar" { lines.append("Ten wzorzec już łapiesz.") }
            else { lines.append("Większość odpowiedzi w tej lekcji była dobra.") }
        }
        if row.kind == "dialog", !row.misses.contains("Pytanie o całą historię"), row.correct > 0 {
            lines.append("Rozumiesz proste pytanie o historię.")
        }
        if row.remembered > 0 {
            lines.append("Zapamiętane słówka z tej lekcji: \(row.remembered).")
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
        case "Pytanie o całą historię": return "Przeczytaj dialog od początku i wskaż, o co chodziło."
        case "Kto mówi na końcu": return "Przejdź wypowiedzi od ostatniej do pierwszej."
        default: return "Wróć do tego jednego miejsca, nie do całej aplikacji."
        }
    }

    private static func suggest(kind: String, misses: [String], title: String) -> (title: String, blurb: String, tab: Int, id: String) {
        let grammarLeft = GrammarBook.lessons.filter { !GrammarBook.doneIDs().contains($0.id) }
        if misses.contains(where: { $0.contains("Szyk") || $0.contains("Rodzaj") || $0.contains("Akkusativ") || $0.contains("Perfekt") }) {
            let needle = misses.contains { $0.contains("Perfekt") } ? "perfekt"
                : misses.contains { $0.contains("Rodzaj") } ? "rodzaj"
                : misses.contains { $0.contains("Akkusativ") } ? "dativ"
                : "szyk"
            if let hit = grammarLeft.first(where: { ($0.topic + " " + $0.title).lowercased().contains(needle) })
                ?? grammarLeft.first {
                return (hit.title, "Tu uciekł \(misses[0].lowercased()). Następna lekcja jest z tego, nie z losowego tematu.", 6, hit.id)
            }
        }
        let scenes = MiniBook.all.filter { !MiniProgress.doneIDs().contains($0.id) && $0.title != title }
        if kind == "dialog", let next = scenes.first {
            let tone = misses.isEmpty ? "Ta rozmowa usiadła." : "W tej rozmowie zostało: \(misses.joined(separator: ", "))."
            return (next.title, "\(tone) Dalej weź inną scenkę: \(next.title), poziom \(next.level).", 5, next.id)
        }
        if let next = grammarLeft.first {
            return (next.title, "Wzorzec z tej lekcji jest zapisany. Kolejny, którego jeszcze nie było: \(next.title).", 6, next.id)
        }
        if let next = scenes.first {
            return (next.title, "Została scenka \(next.title), poziom \(next.level).", 5, next.id)
        }
        return ("Powtórka", "Na dziś nie ma nowej lekcji z tej półki. Wróć do błędów.", 0, "")
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
}

extension Notification.Name {
    static let jumpTab = Notification.Name("jumpTab")
}

enum Go {
    static func tab(_ n: Int, scene: String? = nil, grammar: String? = nil) {
        if let scene { UserDefaults.standard.set(scene, forKey: "jumpScene") }
        if let grammar { UserDefaults.standard.set(grammar, forKey: "jumpGrammar") }
        NotificationCenter.default.post(name: .jumpTab, object: n)
    }
}

struct LessonDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: LearningStore
    let result: LessonResult
    @AppStorage("lessonMotion") private var motion = true
    @State private var showScore = 0
    @State private var burst = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    if motion { burstLayer }
                    VStack(spacing: 8) {
                        Text("Lekcja ukończona")
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.ok.opacity(0.2), in: Capsule())
                            .foregroundStyle(Theme.ok)
                        Text(result.percent >= 80 ? "Świetna robota" : "Lekcja zapisana")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.ok)
                        Text("\(showScore)%")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                        Text("Poprawne odpowiedzi")
                            .foregroundStyle(Theme.text2)
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack(spacing: 8) {
                    stat("\(result.correct)/\(result.correct + result.wrong)", "Odpowiedzi")
                    stat(timeText, "Czas nauki")
                    stat("\(result.seenWords)", "Nowe słowa")
                }
                Text("Zapamiętane w słowniku: \(result.remembered). Błędne odpowiedzi: \(result.wrong).")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                if !result.badge.isEmpty {
                    Label(result.badge, systemImage: "seal.fill")
                        .font(.headline)
                        .foregroundStyle(Theme.ok)
                }
                block("Co idzie dobrze?", ProgressBook.strengths(result), "checkmark.circle.fill", Theme.ok)
                if !result.misses.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nad czym warto popracować?").font(.headline)
                        ForEach(result.misses, id: \.self) { miss in
                            VStack(alignment: .leading, spacing: 2) {
                                Label(miss, systemImage: "target")
                                Text(ProgressBook.drills(miss))
                                    .font(.footnote)
                                    .foregroundStyle(Theme.text2)
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Twoja następna lekcja").font(.headline)
                    Text("Polecana").font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                    Text(result.nextTitle).font(.title3.bold())
                    Text(result.nextBlurb).foregroundStyle(Theme.text2)
                }
                VStack(spacing: 8) {
                    Text("+\(result.xp) XP").font(.title2.bold()).foregroundStyle(Theme.ok)
                    Text("Razem \(ProgressBook.xp()) XP · seria \(store.streak) · dziś lekcji \(ProgressBook.todayCount())")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    Text(weekLine).font(.footnote).foregroundStyle(Theme.text2)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                Button("Rozpocznij polecaną lekcję") { open(result.nextTab) }.primaryButton()
                Button("Powtórz błędy") {
                    if result.kind == "grammar" { Go.tab(6, grammar: result.sourceID) }
                    else { Go.tab(5, scene: result.sourceID) }
                    dismiss()
                }
                    .buttonStyle(.glass)
                Button("Przećwicz nowe słówka") { Go.tab(1); dismiss() }.buttonStyle(.glass)
                Button("Wróć do strony głównej") { Go.tab(0); dismiss() }.buttonStyle(.glass)
                WeekSkills()
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .background(NightGlow())
        .onAppear {
            guard motion else { showScore = result.percent; return }
            withAnimation(.easeOut(duration: 0.8)) { burst = true }
            let target = result.percent
            Task { @MainActor in
                for step in stride(from: 0, through: target, by: max(1, target / 12)) {
                    showScore = step
                    try? await Task.sleep(nanoseconds: 40_000_000)
                }
                showScore = target
            }
        }
    }

    private var timeText: String {
        let m = max(1, (result.seconds + 59) / 60)
        return "\(m) min"
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
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func block(_ title: String, _ lines: [String], _ icon: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            if lines.isEmpty {
                Text("Za mało odpowiedzi, żeby chwalić.").foregroundStyle(Theme.text2)
            }
            ForEach(lines, id: \.self) { line in
                Label(line, systemImage: icon).foregroundStyle(color)
            }
        }
    }

    private func open(_ tab: Int) {
        if result.nextTab == 5, !result.nextID.isEmpty {
            Go.tab(5, scene: result.nextID)
        } else if result.nextTab == 6, !result.nextID.isEmpty {
            Go.tab(6, grammar: result.nextID)
        } else {
            Go.tab(tab)
        }
        dismiss()
    }

    private var burstLayer: some View {
        ZStack {
            ForEach(0..<14, id: \.self) { i in
                Circle()
                    .fill(i.isMultiple(of: 2) ? Theme.ok : Color.white)
                    .frame(width: 7, height: 7)
                    .offset(x: burst ? CGFloat((i * 29 % 160) - 80) : 0, y: burst ? CGFloat(30 + (i * 17 % 90)) : -20)
                    .opacity(burst ? 0 : 0.9)
            }
        }
        .frame(height: 20)
        .allowsHitTesting(false)
    }
}

struct WeekSkills: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Postęp z zapisanych lekcji").font(.headline)
            Text(ProgressBook.skill("dialog", "Mini dialogi"))
            Text(ProgressBook.skill("grammar", "Gramatyka"))
            Text(ProgressBook.skill("vocab", "Słownictwo"))
            Text(ProgressBook.skill("listen", "Słuchanie"))
            Text(ProgressBook.skill("speak", "Rozmowa"))
            Text(ProgressBook.skill("work", "Niemiecki w pracy"))
            Text("Półka bez lekcji nie dostaje procentu. Liczy się tylko to, co zostało dokończone.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
        }
    }
}
