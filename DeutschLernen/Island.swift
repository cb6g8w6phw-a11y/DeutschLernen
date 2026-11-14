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


enum Island {
    static func rest(reviews: Int) { Task { await endAll() } }
    static func force(reviews: Int) async -> String {
        await endAll()
        return ""
    }
    static func sync(reviews: Int) { Task { await endAll() } }
    static func finish(reviews: Int) { Task { await endAll() } }
    static func lesson(title: String, de: String, pl: String, done: Int, total: Int) {}
    static func speak(de: String, pl: String, done: Int, total: Int, ok: Bool, marked: Bool, listening: Bool) {}
    static func voice(seconds: Int, on: Bool) {}

    private static func endAll() async {
        for activity in Activity<StudyAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
