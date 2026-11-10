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
            TodayView().tabItem { Label("Lekcje", systemImage: "book.closed") }
            PracticeView().tabItem { Label("Ćwicz", systemImage: "bubble.left.and.bubble.right") }
            NavigationStack {
                WordsView()
            }
            .tabItem { Label("Słownik", systemImage: "text.book.closed") }
            ProfileView().tabItem { Label("Profil", systemImage: "person.crop.circle") }
        }
        .tint(Color(hex: "8B6CF0"))
        .preferredColorScheme(.dark)
        .fontDesign(.rounded)
    }
}

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                more("Gry", "gamecontroller", Color(hex: "FFD60A")) { GamesHome() }
                more("Moje słówka", "text.book.closed", Theme.accent) { WordsView() }
                more("Niemiecki na budowie", "hammer", Theme.orange) { BuildView() }
                more("Słuchanie", "ear", Color(hex: "5AC8FA")) { ListenView() }
                more("Generator zdań", "text.badge.checkmark", Color(hex: "FF6B9A")) { SentenceView() }
                more("Słówka z filmu", "play.rectangle", Theme.accent) { ClipView() }
                more("Z twojego życia", "sparkles", Theme.orange) { LifeView() }
                more("Skan zdjęcia", "camera", Color(hex: "5AC8FA")) { ScanView() }
                more("Ustawienia i klucz", "gear", Color(hex: "FF6B9A")) { SettingsView() }
            }
            .navigationTitle("Więcej")
            .scrollContentBackground(.hidden)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private func more<Dest: View>(_ title: String, _ icon: String, _ tint: Color, @ViewBuilder dest: () -> Dest) -> some View {
        NavigationLink { dest() } label: {
            HStack(spacing: 12) {
                IconBadge(system: icon, tint: tint)
                Text(title).font(.body).foregroundStyle(Theme.text)
            }
            .frame(minHeight: 44)
        }
    }
}
