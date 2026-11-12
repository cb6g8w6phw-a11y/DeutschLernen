import ActivityKit
import Foundation

enum Island {
    private static let gate = IslandGate()

    static func rest(reviews: Int) {
        Task { await gate.rest(reviews: reviews) }
    }

    static func finish(reviews: Int) {
        Task { await gate.finish(reviews: reviews) }
    }

    static func lesson(title: String, de: String, pl: String, done: Int, total: Int) {
        Task { await gate.lesson(title: title, de: de, pl: pl, done: done, total: total) }
    }

    static func speak(de: String, pl: String, done: Int, total: Int, ok: Bool, marked: Bool, listening: Bool) {
        Task { await gate.speak(de: de, pl: pl, done: done, total: total, ok: ok, marked: marked, listening: listening) }
    }

    static func voice(seconds: Int, on: Bool) {
        Task { await gate.voice(seconds: seconds, on: on) }
    }
}

private actor IslandGate {
    private var mode = "line"

    func rest(reviews: Int) async {
        guard mode == "line" else { return }
        await push(line(reviews))
    }

    func finish(reviews: Int) async {
        mode = "line"
        await push(line(reviews))
    }

    func lesson(title: String, de: String, pl: String, done: Int, total: Int) async {
        mode = "lesson"
        await push(StudyAttributes.ContentState(
            kind: "lesson", title: title, de: clip(de), pl: clip(pl),
            done: done, total: total, ok: true, marked: false, listening: false,
            seconds: 0, showPolish: false, warn: false
        ))
    }

    func speak(de: String, pl: String, done: Int, total: Int, ok: Bool, marked: Bool, listening: Bool) async {
        mode = "speak"
        await push(StudyAttributes.ContentState(
            kind: "speak", title: "Wymowa", de: clip(de), pl: clip(pl),
            done: done, total: total, ok: ok, marked: marked, listening: listening,
            seconds: 0, showPolish: false, warn: false
        ))
    }

    func voice(seconds: Int, on: Bool) async {
        mode = "voice"
        await push(StudyAttributes.ContentState(
            kind: "voice", title: "Głosówka", de: on ? "Słucham…" : "Gotowe", pl: "",
            done: 0, total: 1, ok: true, marked: false, listening: on,
            seconds: seconds, showPolish: false, warn: false
        ))
    }

    private func line(_ reviews: Int) -> StudyAttributes.ContentState {
        let pair = DayLines.today()
        let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
        let target = goal == 0 ? 20 : goal
        let hour = Calendar.current.component(.hour, from: Date())
        return StudyAttributes.ContentState(
            kind: "line", title: "Zdanie", de: pair.0, pl: pair.1,
            done: reviews, total: target, ok: true, marked: false, listening: false,
            seconds: 0, showPolish: false, warn: hour >= 18 && reviews < target
        )
    }

    private func push(_ state: StudyAttributes.ContentState) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let content = ActivityContent(state: state, staleDate: nil)
        let running = Activity<StudyAttributes>.activities
        if let first = running.first {
            await first.update(content)
            for extra in running.dropFirst() {
                await extra.end(nil, dismissalPolicy: .immediate)
            }
            return
        }
        do {
            _ = try Activity.request(attributes: StudyAttributes(id: "deutsch"), content: content, pushType: nil)
        } catch {}
    }

    private func clip(_ text: String) -> String {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count > 90 else { return clean }
        return String(clean.prefix(89)) + "…"
    }
}
