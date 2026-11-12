import ActivityKit
import AppIntents
import Foundation

struct StudyAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var kind: String
        var title: String
        var de: String
        var pl: String
        var done: Int
        var total: Int
        var ok: Bool
        var marked: Bool
        var listening: Bool
        var seconds: Int
        var showPolish: Bool
        var warn: Bool
    }

    var id: String
}

enum DayLines {
    static let all: [(String, String)] = [
        ("Ich fange morgen um sechs an.", "Jutro zaczynam o szóstej."),
        ("Uns fehlt Material.", "Brakuje nam materiału."),
        ("Pass auf, hier ist ein Kabel.", "Uważaj, tu jest kabel."),
        ("Ich bin krank und komme heute nicht.", "Jestem chory i dziś nie przyjdę."),
        ("Wo soll ich das hinstellen?", "Gdzie mam to postawić?"),
        ("Die Lieferung kommt erst um zehn.", "Dostawa przyjedzie dopiero o dziesiątej."),
        ("Kannst du den Transporter alleine beladen?", "Czy możesz sam załadować busa?"),
        ("Hol bitte die Schaufel.", "Przynieś proszę łopatę."),
        ("Ich bin gleich da.", "Zaraz będę."),
        ("Was kostet das?", "Ile to kosztuje?")
    ]

    static func today() -> (String, String) {
        on(Date())
    }

    static func on(_ date: Date) -> (String, String) {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return all[day % all.count]
    }
}

struct FlipLineIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pokaż tłumaczenie"
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        for activity in Activity<StudyAttributes>.activities {
            var state = activity.content.state
            guard state.kind == "line" else { continue }
            state.showPolish.toggle()
            await activity.update(ActivityContent(state: state, staleDate: nil))
        }
        return .result()
    }
}
