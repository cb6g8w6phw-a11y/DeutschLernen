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
        TabView {
            QuizView().tabItem { Label("Nauka", systemImage: "book") }
            ChatView().tabItem { Label("Czat AI", systemImage: "bubble.left.and.bubble.right") }
            StatsView().tabItem { Label("Postępy", systemImage: "chart.bar") }
            SettingsView().tabItem { Label("Ustawienia", systemImage: "gear") }
        }
    }
}
