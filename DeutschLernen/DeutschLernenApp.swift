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
    @State private var dockHidden = false
    @AppStorage("notifyExplained") private var notifyExplained = false

    var body: some View {
        Group {
            switch tab {
            case 1: NavigationStack { WortHome() }
            case 2: NavigationStack { ListenView() }
            case 3: TutorView()
            case 4: NavigationStack { MoreTools() }
            case 5: NavigationStack { SceneLibraryView() }
            case 6: NavigationStack { GrammarLibraryView() }
            case 7: NavigationStack { PronounceView() }
            case 8: NavigationStack { PlacementView() }
            case 9: NavigationStack { WordsView() }
            case 10: PracticeView()
            case 11: ProfileView()
            default: TodayView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !dockHidden {
                AppDock(tab: $tab)
                    .padding(.bottom, 6)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background {
            NightGlow()
            DockScrollBridge(hidden: $dockHidden)
        }
        .animation(.spring(response: 0.34, dampingFraction: 0.9), value: dockHidden)
        .onChange(of: tab) { _, _ in
            withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) { dockHidden = false }
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

struct AppDock: View {
    @Binding var tab: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                card(5, "bubble.left.and.bubble.right.fill", "Mini dialogi", "100+ scenek z życia")
                card(6, "text.book.closed.fill", "Wzorce gramatyczne", "Gramatyka przez praktykę")
            }
            HStack(spacing: 0) {
                icon(0, "house.fill", "Start")
                icon(1, "character.book.closed", "Słówka")
                icon(2, "headphones", "Słuchaj")
                icon(3, "mic.fill", "Mów")
                icon(4, "ellipsis", "Więcej")
            }
            HStack(spacing: 0) {
                icon(7, "waveform", "Wymowa")
                icon(8, "checkmark.circle", "Test")
                icon(9, "text.book.closed", "Słownik")
                icon(10, "figure.run", "Ćwicz")
                icon(11, "person", "Profil")
            }
        }
        .padding(10)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .padding(.horizontal, 10)
    }

    private func card(_ value: Int, _ symbol: String, _ title: String, _ subtitle: String) -> some View {
        Button { tab = value } label: {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(Theme.ok)
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(Theme.text2)
                    .lineLimit(1)
                Text("Nowa kategoria")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Theme.ok, in: Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(tab == value ? Theme.ok : Color.white.opacity(0.16), lineWidth: tab == value ? 1.5 : 0.5))
        }
        .buttonStyle(.plain)
    }

    private func icon(_ value: Int, _ symbol: String, _ title: String) -> some View {
        Button { tab = value } label: {
            VStack(spacing: 3) {
                Image(systemName: symbol).font(.body.weight(.semibold))
                Text(title).font(.system(size: 10, weight: .semibold)).lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(tab == value ? Theme.ok : Theme.text2)
        }
        .buttonStyle(.plain)
    }
}

private struct DockScrollBridge: UIViewRepresentable {
    @Binding var hidden: Bool

    func makeCoordinator() -> Coordinator { Coordinator(hidden: $hidden) }

    func makeUIView(context: Context) -> Probe {
        let view = Probe()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.coordinator = context.coordinator
        return view
    }

    func updateUIView(_ uiView: Probe, context: Context) {
        uiView.coordinator = context.coordinator
        context.coordinator.hidden = $hidden
        context.coordinator.scan(from: uiView)
    }

    final class Probe: UIView {
        weak var coordinator: Coordinator?
        override func didMoveToWindow() {
            super.didMoveToWindow()
            coordinator?.scan(from: self)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            coordinator?.scan(from: self)
        }
    }

    final class Coordinator: NSObject {
        var hidden: Binding<Bool>
        private var watches: [ObjectIdentifier: NSKeyValueObservation] = [:]
        private var lastY: [ObjectIdentifier: CGFloat] = [:]
        private var lock = Date.distantPast

        init(hidden: Binding<Bool>) { self.hidden = hidden }

        func scan(from view: UIView) {
            guard let window = view.window else { return }
            var found: [UIScrollView] = []
            window.collectScrolls(into: &found)
            let live = Set(found.map { ObjectIdentifier($0) })
            let stale = watches.keys.filter { !live.contains($0) }
            for key in stale {
                watches[key] = nil
                lastY[key] = nil
            }
            for scroll in found where watches[ObjectIdentifier(scroll)] == nil && scroll.bounds.height > 160 {
                let key = ObjectIdentifier(scroll)
                lastY[key] = scroll.contentOffset.y
                watches[key] = scroll.observe(\.contentOffset, options: [.new]) { [weak self] scroll, _ in
                    self?.moved(scroll)
                }
            }
        }

        func moved(_ scroll: UIScrollView) {
            let key = ObjectIdentifier(scroll)
            let y = scroll.contentOffset.y
            let previous = lastY[key] ?? y
            lastY[key] = y
            let delta = y - previous
            if abs(delta) < 1 { return }
            if y <= 12 {
                apply(false)
                return
            }
            if delta > 10 { apply(true) }
            else if delta < -10 { apply(false) }
        }

        func apply(_ hide: Bool) {
            guard Date() > lock, hidden.wrappedValue != hide else { return }
            lock = Date().addingTimeInterval(0.45)
            DispatchQueue.main.async {
                withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                    self.hidden.wrappedValue = hide
                }
            }
        }
    }
}

private extension UIView {
    func collectScrolls(into list: inout [UIScrollView]) {
        if let scroll = self as? UIScrollView { list.append(scroll) }
        for child in subviews { child.collectScrolls(into: &list) }
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
