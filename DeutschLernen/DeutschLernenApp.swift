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
                Tab("Czat", systemImage: "bubble.left.and.bubble.right") { TutorView() }
                Tab("Postęp", systemImage: "chart.bar") { StatsView() }
                Tab("Sceny", systemImage: "person.2") { ScenesView() }
                Tab("Więcej", systemImage: "ellipsis.circle") { MoreView() }
            }
            .tint(Ink.brass)
        }
    }
}

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    LifeView()
                } label: {
                    Label("Z twojego życia", systemImage: "sparkles")
                }
                NavigationLink {
                    ScanView()
                } label: {
                    Label("Skan zdjęcia", systemImage: "camera")
                }
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Ustawienia i klucz", systemImage: "gear")
                }
            }
            .navigationTitle("Więcej")
            .scrollContentBackground(.hidden)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
