import ActivityKit
import Foundation
import UIKit
import UserNotifications

enum IslandPrefs {
    static let sentence = "islandSentence"
    static let lesson = "islandLesson"
    static let speak = "islandSpeak"
    static let voice = "islandVoice"
    static let evening = "islandEvening"

    static func on(_ key: String) -> Bool {
        if UserDefaults.standard.object(forKey: key) == nil { return true }
        return UserDefaults.standard.bool(forKey: key)
    }
}

enum Ping {
    static func status() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    static func allow() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let current = await center.notificationSettings().authorizationStatus
        if current == .denied {
            await MainActor.run {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            return false
        }
        if current == .notDetermined {
            let ok = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            return ok
        }
        return true
    }

    static func plan(reviews: Int) {
        Task { await schedule(reviews: reviews) }
    }

    private static func schedule(reviews: Int) async {
        let center = UNUserNotificationCenter.current()
        let current = await center.notificationSettings().authorizationStatus
        let ids = (0..<7).map { "line-morning-\($0)" } + ["line-evening"]
        center.removePendingNotificationRequests(withIdentifiers: ids)
        guard current == .authorized || current == .provisional || current == .ephemeral else { return }
        let calendar = Calendar.current
        if IslandPrefs.on(IslandPrefs.sentence) {
            for offset in 0..<7 {
                guard let day = calendar.date(byAdding: .day, value: offset, to: Date()) else { continue }
                var parts = calendar.dateComponents([.year, .month, .day], from: day)
                parts.hour = 8
                parts.minute = 0
                guard let fire = calendar.date(from: parts), fire > Date() else { continue }
                let pair = DayLines.on(day)
                let content = UNMutableNotificationContent()
                content.title = "Zdanie na dziś"
                content.body = "\(pair.0) — \(pair.1)"
                content.sound = .default
                let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
                try? await center.add(UNNotificationRequest(identifier: "line-morning-\(offset)", content: content, trigger: trigger))
            }
        }
        if IslandPrefs.on(IslandPrefs.evening) {
            let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
            let target = goal == 0 ? 20 : goal
            let left = max(0, target - reviews)
            var parts = calendar.dateComponents([.year, .month, .day], from: Date())
            parts.hour = 18
            parts.minute = 0
            if calendar.date(from: parts).map({ $0 <= Date() }) ?? true {
                if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) {
                    parts = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                    parts.hour = 18
                    parts.minute = 0
                }
            }
            let content = UNMutableNotificationContent()
            content.title = left == 0 ? "Cel na dziś zrobiony" : "Zostało \(left) słówek"
            content.body = left == 0 ? "Możesz iść dalej, albo odpuścić na dziś." : "Wróć do nauki, żeby nie zgubić dnia."
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            try? await center.add(UNNotificationRequest(identifier: "line-evening", content: content, trigger: trigger))
        }
    }
}

enum Island {
    private static let gate = IslandGate()

    static func rest(reviews: Int) {
        Task { await gate.rest(reviews: reviews) }
    }

    static func sync(reviews: Int) {
        Task { await gate.sync(reviews: reviews) }
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
        await showLine(reviews)
    }

    func sync(reviews: Int) async {
        if mode == "lesson", !IslandPrefs.on(IslandPrefs.lesson) { mode = "line" }
        if mode == "speak", !IslandPrefs.on(IslandPrefs.speak) { mode = "line" }
        if mode == "voice", !IslandPrefs.on(IslandPrefs.voice) { mode = "line" }
        guard mode == "line" else { return }
        await showLine(reviews)
    }

    func finish(reviews: Int) async {
        mode = "line"
        await showLine(reviews)
    }

    func lesson(title: String, de: String, pl: String, done: Int, total: Int) async {
        guard IslandPrefs.on(IslandPrefs.lesson) else { return }
        mode = "lesson"
        await push(StudyAttributes.ContentState(
            kind: "lesson", title: title, de: clip(de), pl: clip(pl),
            done: done, total: total, ok: true, marked: false, listening: false,
            seconds: 0, showPolish: false, warn: false
        ))
    }

    func speak(de: String, pl: String, done: Int, total: Int, ok: Bool, marked: Bool, listening: Bool) async {
        guard IslandPrefs.on(IslandPrefs.speak) else { return }
        mode = "speak"
        await push(StudyAttributes.ContentState(
            kind: "speak", title: "Wymowa", de: clip(de), pl: clip(pl),
            done: done, total: total, ok: ok, marked: marked, listening: listening,
            seconds: 0, showPolish: false, warn: false
        ))
    }

    func voice(seconds: Int, on: Bool) async {
        guard IslandPrefs.on(IslandPrefs.voice) else { return }
        mode = "voice"
        await push(StudyAttributes.ContentState(
            kind: "voice", title: "Głosówka", de: on ? "Słucham…" : "Gotowe", pl: "",
            done: 0, total: 1, ok: true, marked: false, listening: on,
            seconds: seconds, showPolish: false, warn: false
        ))
    }

    private func showLine(_ reviews: Int) async {
        let state = line(reviews)
        let sentence = IslandPrefs.on(IslandPrefs.sentence)
        let evening = IslandPrefs.on(IslandPrefs.evening)
        let warn = state.warn && evening
        guard sentence || warn else {
            await stop()
            return
        }
        var next = state
        next.warn = warn
        if !sentence {
            let left = max(0, next.total - next.done)
            next.title = "Cel"
            next.de = "Zostało \(left) słówek"
            next.pl = "Wróć do nauki, żeby nie zgubić dnia."
        }
        await push(next)
    }

    private func stop() async {
        for activity in Activity<StudyAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    private func line(_ reviews: Int) -> StudyAttributes.ContentState {
        let pair = DayLines.today()
        let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
        let target = goal == 0 ? 20 : goal
        let hour = Calendar.current.component(.hour, from: Date())
        let evening = IslandPrefs.on(IslandPrefs.evening)
        return StudyAttributes.ContentState(
            kind: "line", title: "Zdanie", de: pair.0, pl: pair.1,
            done: reviews, total: target, ok: true, marked: false, listening: false,
            seconds: 0, showPolish: false, warn: evening && hour >= 18 && reviews < target
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
