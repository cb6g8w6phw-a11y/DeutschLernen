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
            Tab("Dziś", systemImage: "sun.max") { TodayView() }
            Tab("Czat", systemImage: "bubble.left.and.bubble.right") { TutorView() }
            Tab("Postęp", systemImage: "chart.bar") { StatsView() }
            Tab("Sceny", systemImage: "person.2") { ScenesView() }
            Tab("Więcej", systemImage: "ellipsis.circle") { MoreView() }
        }
        .tint(Theme.accent)
        .preferredColorScheme(.dark)
        .fontDesign(.rounded)
    }
}

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    WordsView()
                } label: {
                    Label("Moje słówka", systemImage: "text.book.closed")
                }
                NavigationLink {
                    BuildView()
                } label: {
                    Label("Niemiecki na budowie", systemImage: "hammer")
                }
                NavigationLink {
                    ListenView()
                } label: {
                    Label("Słuchanie", systemImage: "ear")
                }
                NavigationLink {
                    SentenceView()
                } label: {
                    Label("Generator zdań", systemImage: "text.badge.checkmark")
                }
                NavigationLink {
                    ClipView()
                } label: {
                    Label("Słówka z filmu", systemImage: "play.rectangle")
                }
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
