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
    static func arm() {
        UNUserNotificationCenter.current().delegate = NotifyBox.shared
    }

    static func status() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    static func allow() async -> Bool {
        arm()
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
            return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        }
        return true
    }

    static func poke(reviews: Int) async -> String {
        arm()
        let ok = await allow()
        guard ok else { return "Brak zgody. Otwieram ustawienia iPhone’a." }
        await schedule(reviews: reviews)
        let sent = await fireNow(reviews: reviews)
        let island = await Island.force(reviews: reviews)
        return sent + " " + island
    }

    static func plan(reviews: Int) {
        arm()
        Task { await schedule(reviews: reviews) }
    }

    private static func fireNow(reviews: Int) async -> String {
        let center = UNUserNotificationCenter.current()
        let pair = DayLines.today()
        let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
        let target = goal == 0 ? 20 : goal
        let left = max(0, target - reviews)
        let content = UNMutableNotificationContent()
        content.sound = .default
        if IslandPrefs.on(IslandPrefs.evening), Calendar.current.component(.hour, from: Date()) >= 18, left > 0 {
            content.title = "Zostało \(left) słówek"
            content.body = "\(pair.0) — \(pair.1)"
        } else if IslandPrefs.on(IslandPrefs.sentence) {
            content.title = "Zdanie na dziś"
            content.body = "\(pair.0) — \(pair.1)"
        } else {
            content.title = "Deutsch"
            content.body = "Powiadomienia działają. Włącz zdanie albo wieczór, jeśli chcesz treść."
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        content.interruptionLevel = .active
        do {
            try await center.add(UNNotificationRequest(identifier: "line-now", content: content, trigger: trigger))
            return "Za 2 sekundy wyjdzie banner, także gdy aplikacja jest otwarta."
        } catch {
            return "Banner nie wyszedł: \(error.localizedDescription)."
        }
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

final class NotifyBox: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotifyBox()

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}

@MainActor
final class IslandNow: ObservableObject {
    static let shared = IslandNow()
    @Published var text = ""
    @Published var visible = false
}

enum Island {
    private static let gate = IslandGate()

    static func rest(reviews: Int) {
        Task { await gate.rest(reviews: reviews) }
    }

    static func force(reviews: Int) async -> String {
        await gate.force(reviews: reviews)
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
    private var last = "Wyspa jeszcze nie była wołana."

    func rest(reviews: Int) async {
        guard mode == "line" else { return }
        await showLine(reviews)
    }

    func force(reviews: Int) async -> String {
        mode = "line"
        let any = IslandPrefs.on(IslandPrefs.sentence)
            || IslandPrefs.on(IslandPrefs.evening)
            || IslandPrefs.on(IslandPrefs.lesson)
            || IslandPrefs.on(IslandPrefs.speak)
            || IslandPrefs.on(IslandPrefs.voice)
        guard any else {
            await stop()
            return "Włącz chociaż jedną rzecz w „Co na wyspie”."
        }
        await showLine(reviews)
        return last
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
        await mirror(nil)
        last = "Wyspa schowana, bo te rzeczy są wyłączone."
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
        await mirror(state)
        let content = ActivityContent(state: state, staleDate: nil)
        let running = Activity<StudyAttributes>.activities
        do {
            if let first = running.first {
                await first.update(content)
                for extra in running.dropFirst() {
                    await extra.end(nil, dismissalPolicy: .immediate)
                }
            } else {
                _ = try Activity.request(attributes: StudyAttributes(id: "deutsch"), content: content, pushType: nil)
            }
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                last = "Wyspa systemowa wstaje po wyjściu na pulpit. W aplikacji jest pasek u góry."
            } else {
                last = "iPhone ma wyłączone aktywności na żywo. Włącz je: Ustawienia telefonu, ta aplikacja, Aktywności na żywo. Pasek u góry i tak widać."
            }
        } catch {
            last = "Wyspa systemowa nie wstała: \(error.localizedDescription). Pasek u góry jest wymuszony w aplikacji. W LiveContainer prawdziwa wyspa często nie działa."
        }
    }

    private func mirror(_ state: StudyAttributes.ContentState?) async {
        let text = state?.de ?? ""
        let visible = state != nil
        await MainActor.run {
            IslandNow.shared.text = text
            IslandNow.shared.visible = visible
        }
    }

    private func clip(_ text: String) -> String {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count > 90 else { return clean }
        return String(clean.prefix(89)) + "…"
    }
}
