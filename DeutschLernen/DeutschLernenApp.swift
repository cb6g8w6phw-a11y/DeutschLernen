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
                Tab("Sceny", systemImage: "person.2") { ScenesView() }
                Tab("Życie", systemImage: "sparkles") { LifeView() }
                Tab("Skan", systemImage: "camera") { ScanView() }
                Tab("Ustawienia", systemImage: "gear") { SettingsView() }
            }
            .tint(Ink.brass)
        }
    }
}
