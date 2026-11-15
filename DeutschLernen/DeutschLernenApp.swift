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
    @State private var tab = 0
    @AppStorage("notifyExplained") private var notifyExplained = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case 1: NavigationStack { WortHome() }
                case 2: NavigationStack { ListenView() }
                case 3: TutorView()
                case 4: NavigationStack { MoreTools() }
                case 5: NavigationStack { SceneLibraryView() }
                case 6: NavigationStack { GrammarLibraryView() }
                default: TodayView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            AppDock(tab: $tab)
        }
        .background(Color.black)
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

struct AppDock: View {
    @Binding var tab: Int

    var body: some View {
        HStack(spacing: 0) {
            icon(0, "house.fill", "Start")
            icon(1, "character.book.closed", "Słówka")
            icon(5, "bubble.left.and.bubble.right.fill", "Dialogi")
            icon(2, "headphones", "Słuchaj")
            icon(3, "mic.fill", "Mów")
            icon(6, "text.book.closed.fill", "Wzorce")
            icon(4, "ellipsis", "Więcej")
        }
        .padding(.top, 8)
        .padding(.bottom, 6)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) { Rectangle().fill(Color.white.opacity(0.12)).frame(height: 0.5) }
    }

    private func icon(_ value: Int, _ symbol: String, _ title: String) -> some View {
        Button { tab = value } label: {
            VStack(spacing: 3) {
                Image(systemName: symbol).font(.body.weight(.semibold))
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(tab == value ? Theme.ok : Theme.text2)
        }
        .buttonStyle(.plain)
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
