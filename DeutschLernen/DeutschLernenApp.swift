import SwiftUI

@main
struct DeutschLernenApp: App {
    @StateObject private var store = LearningStore()

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(store)
        }
    }
}

struct RootView: View {
    var body: some View {
        ZStack {
            NightGlow()
            TabView {
                Tab("Nauka", systemImage: "book") { QuizView() }
                Tab("Czat", systemImage: "bubble.left.and.bubble.right") { ChatView() }
                Tab("Postęp", systemImage: "chart.bar") { StatsView() }
                Tab("Ustawienia", systemImage: "gear") { SettingsView() }
            }
            .tint(Ink.brass)
        }
    }
}
