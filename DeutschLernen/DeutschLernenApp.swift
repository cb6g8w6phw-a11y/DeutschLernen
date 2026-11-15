import SwiftUI

@main
struct DeutschLernenApp: App {
    @StateObject private var store = LearningStore()

    init() {
        NewsRefresh.register()
        Ping.arm()
    }

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(store)
        }
    }
}

struct RootView: View {
    @Environment(\.scenePhase) private var phase
    @EnvironmentObject var store: LearningStore
    @State private var askNotify = false
    @AppStorage("notifyExplained") private var notifyExplained = false

    var body: some View {
        TabView {
            TodayView().tabItem { Label("Start", systemImage: "house.fill") }
            NavigationStack { WortHome() }
                .tabItem { Label("Słówka", systemImage: "character.book.closed") }
            NavigationStack { ListenView() }
                .tabItem { Label("Słuchaj", systemImage: "headphones") }
            TutorView().tabItem { Label("Mów", systemImage: "mic.fill") }
            NavigationStack { WorkHubView() }
                .tabItem { Label("Praca", systemImage: "helmet") }
            StatsView().tabItem { Label("Postęp", systemImage: "chart.bar.fill") }
        }
        .tint(Theme.ok)
        .preferredColorScheme(.dark)
        .fontDesign(.rounded)
        .onAppear {
            NewsClock.shared.start()
            Island.rest(reviews: store.reviewsToday)
            Ping.plan(reviews: store.reviewsToday)
            Task {
                let current = await Ping.status()
                if current == .notDetermined, !notifyExplained { askNotify = true }
            }
        }
        .onChange(of: phase) { _, phase in
            if phase == .active {
                Task { await NewsClock.shared.kick(force: false) }
                Island.rest(reviews: store.reviewsToday)
                Ping.plan(reviews: store.reviewsToday)
            }
        }
        .alert("Zezwól na powiadomienia", isPresented: $askNotify) {
            Button("Zezwól") {
                notifyExplained = true
                Task {
                    _ = await Ping.poke(reviews: store.reviewsToday)
                }
            }
            Button("Nie teraz", role: .cancel) { notifyExplained = true }
        } message: {
            Text("Rano przyjdzie zdanie po niemiecku, a o 18:00 informacja, ile słówek zostało.")
        }
    }
}

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                more("Wiadomości", "newspaper", Theme.orange) { NewsListView() }
                more("Gry", "gamecontroller", .white) { GamesHome() }
                more("Moje słówka", "text.book.closed", Theme.accent) { WordsView() }
                more("Niemiecki na budowie", "hammer", Theme.orange) { BuildView() }
                more("Słuchanie", "ear", .white) { ListenView() }
                more("Generator zdań", "text.badge.checkmark", .white) { SentenceView() }
                more("Słówka z filmu", "play.rectangle", Theme.accent) { ClipView() }
                more("Z życia", "plus.circle.fill", Theme.ok) { CaptureView() }
                more("Z twojego życia", "sparkles", Theme.orange) { LifeView() }
                more("Skan zdjęcia", "camera", .white) { ScanView() }
                more("Ustawienia i klucz", "gear", .white) { SettingsView() }
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
