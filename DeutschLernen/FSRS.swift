import Foundation

enum FSRSRating: Int {
    case again = 1
    case hard = 2
    case good = 3
    case easy = 4
}

enum FSRS {
    static let decay = -0.5
    static let factor = 19.0 / 81.0
    static var retention = 0.90
    static let w: [Double] = [
        0.40255, 1.18385, 3.173, 15.69105, 7.1949,
        0.5345, 1.4604, 0.0046, 1.54575, 0.1192,
        1.01925, 1.9395, 0.11, 0.29605, 2.2698,
        0.2315, 2.9898, 0.51655, 0.6621
    ]

    static func retrievability(stability: Double, elapsedDays: Double) -> Double {
        let s = max(stability, 0.01)
        let t = max(elapsedDays, 0)
        let value = pow(1 + factor * t / s, decay)
        return value.isFinite ? value : 0
    }

    static func intervalDays(stability: Double, retention requested: Double = retention) -> Double {
        let s = max(stability, 0.01)
        let r = min(0.97, max(0.70, requested))
        let value = (s / factor) * (pow(r, 1 / decay) - 1)
        return value.isFinite ? max(0, value) : 1
    }

    static func fuzzed(_ days: Double, unit: Double) -> Double {
        let base = max(days, 1)
        let swing = base * 0.05
        let u = min(1, max(0, unit))
        let moved = base + (u - 0.5) * 2 * swing
        return min(base * 1.05, max(base * 0.95, moved))
    }

    static func mastered(_ stat: WordStat) -> Bool {
        stat.stability >= 21 && stat.reps >= 2 && stat.gap >= 21
    }

    static func isLeech(_ stat: WordStat) -> Bool { stat.lapses >= 6 }

    static func apply(_ stat: inout WordStat, rating: FSRSRating, now: Date = Date(), fuzz: Bool = true) {
        let grade = rating.rawValue
        let first = stat.stability <= 0 && stat.reps == 0 && stat.lapses == 0
        let elapsed = stat.lastReview.map { max(0, now.timeIntervalSince($0) / 86400) } ?? 0
        let sameDay = !first && elapsed < 0.8
        let recall = stat.stability > 0 ? retrievability(stability: stat.stability, elapsedDays: elapsed) : 0

        if first {
            stat.stability = finite(w[grade - 1], fallback: 1)
            stat.difficulty = difficulty(for: grade)
        } else if sameDay, rating != .again {
            let bump = exp(w[17] * (Double(grade - 3) + w[18]))
            stat.stability = finite(max(0.1, stat.stability * bump), fallback: stat.stability)
            stat.difficulty = nextDifficulty(stat.difficulty, grade: grade)
            stat.reps += 1
            if stat.due <= now {
                stat.gap = max(stat.gap, 1)
                stat.due = Calendar.current.date(byAdding: .day, value: stat.gap, to: now) ?? now
            }
            stat.lastReview = now
            stat.box = min(stat.reps, 5)
            return
        } else if rating == .again {
            let forgotten = w[11] * pow(max(stat.difficulty, 1), -w[12]) * (pow(stat.stability + 1, w[13]) - 1) * exp((1 - recall) * w[14])
            stat.stability = finite(max(0.1, forgotten), fallback: 0.5)
            stat.difficulty = nextDifficulty(stat.difficulty, grade: grade)
        } else {
            let hardPenalty = rating == .hard ? w[15] : 1
            let easyBonus = rating == .easy ? w[16] : 1
            let gain = exp((1 - recall) * w[10]) - 1
            let base = exp(w[8]) * (11 - stat.difficulty) * pow(max(stat.stability, 0.1), -w[9]) * max(gain, 0.05)
            stat.stability = finite(max(0.1, min(stat.stability * base * hardPenalty * easyBonus, 36500)), fallback: stat.stability)
            stat.difficulty = nextDifficulty(stat.difficulty, grade: grade)
        }

        if rating == .again {
            stat.reps = 0
            stat.lapses += 1
            stat.gap = 0
            stat.due = Calendar.current.date(byAdding: .minute, value: 10, to: now) ?? now
        } else {
            var days = max(1, intervalDays(stability: stat.stability))
            if rating == .hard { days = max(1, days * 0.8) }
            if fuzz {
                let unit = Double(abs(Int(now.timeIntervalSince1970) % 11)) / 10
                days = fuzzed(days, unit: unit)
            }
            let whole = max(1, Int(days.rounded()))
            stat.reps += 1
            stat.gap = whole
            stat.box = min(stat.reps, 5)
            stat.due = Calendar.current.date(byAdding: .day, value: whole, to: now) ?? now
        }
        stat.lastReview = now
    }

    private static func difficulty(for grade: Int) -> Double {
        clamp(w[4] - exp(w[5] * Double(grade - 1)) + 1)
    }

    private static func nextDifficulty(_ current: Double, grade: Int) -> Double {
        let easy = difficulty(for: 4)
        let step = current - w[6] * Double(grade - 3)
        return clamp(w[7] * easy + (1 - w[7]) * step)
    }

    private static func clamp(_ value: Double) -> Double {
        let safe = finite(value, fallback: 5)
        return min(10, max(1, safe))
    }

    private static func finite(_ value: Double, fallback: Double) -> Double {
        value.isFinite ? value : fallback
    }
}

struct CreditSnapshot {
    var counted: Int
    var due: Date
    var mastered: Bool
}

enum StudyCredit {
    static func goodHit(card: inout WordStat, counted: Int, now: Date = Date()) -> CreditSnapshot {
        FSRS.apply(&card, rating: .good, now: now, fuzz: false)
        return CreditSnapshot(counted: counted + 1, due: card.due, mastered: FSRS.mastered(card))
    }
}

enum AnswerCheck {
    enum Verdict { case exact, typo, wrong }

    static func fold(_ raw: String) -> String {
        var text = raw.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        text = text.replacingOccurrences(of: "ä", with: "ae")
            .replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue")
            .replacingOccurrences(of: "ß", with: "ss")
        let letters = text.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) || $0 == " " }
        return String(String.UnicodeScalarView(letters)).split(separator: " ").joined(separator: " ")
    }

    static func distance(_ left: String, _ right: String) -> Int {
        let a = Array(left)
        let b = Array(right)
        if a.isEmpty { return b.count }
        if b.isEmpty { return a.count }
        var row = Array(0...b.count)
        for i in 1...a.count {
            var next = [i]
            for j in 1...b.count {
                let cost = a[i - 1] == b[j - 1] ? 0 : 1
                let best = min(next[j - 1] + 1, row[j] + 1, row[j - 1] + cost)
                next.append(best)
            }
            row = next
        }
        return row[b.count]
    }

    static func judge(_ typed: String, _ expected: String) -> Verdict {
        let got = fold(typed)
        let want = fold(expected)
        if got == want { return .exact }
        if got.isEmpty || want.isEmpty { return .wrong }
        return distance(got, want) <= 1 ? .typo : .wrong
    }

    static func almost(_ expected: String) -> String { "Prawie dobrze: \(expected)" }
    static func miss(_ expected: String) -> String { "Poprawnie: \(expected)" }
}
