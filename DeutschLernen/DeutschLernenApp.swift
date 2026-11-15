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
    @State private var dockHeight: CGFloat = 320
    @AppStorage("notifyExplained") private var notifyExplained = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch tab {
                case 1: NavigationStack { MoreTools(title: "Ucz się") }
                case 2: NavigationStack { ListenView() }
                case 3: TutorView()
                case 4: NavigationStack { MoreTools(title: "Ucz się") }
                case 5: NavigationStack { SceneLibraryView() }
                case 6: NavigationStack { GrammarLibraryView() }
                case 7: NavigationStack { PronounceView() }
                case 8: NavigationStack { PlacementView() }
                case 9: NavigationStack { WordsView() }
                case 10: PracticeView()
                case 11: ProfileView()
                case 12: NavigationStack { TextLibraryView() }
                case 13: NavigationStack { WortHome() }
                default: TodayView()
                }
            }
            .padding(.bottom, dockHidden ? 0 : dockHeight)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            AppDock(tab: $tab)
                .padding(.bottom, 6)
                .background {
                    GeometryReader { geo in
                        Color.clear.preference(key: DockHeightKey.self, value: geo.size.height)
                    }
                }
                .offset(y: dockHidden ? dockHeight + 24 : 0)
                .opacity(dockHidden ? 0 : 1)
                .allowsHitTesting(!dockHidden)
                .animation(.easeOut(duration: 0.2), value: dockHidden)
        }
        .background(NightGlow())
        .background(DockPanBridge(hidden: $dockHidden))
        .onPreferenceChange(DockHeightKey.self) { height in
            if height > 40 { dockHeight = height }
        }
        .onChange(of: tab) { _, _ in
            var snap = Transaction()
            snap.disablesAnimations = true
            withTransaction(snap) { dockHidden = false }
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
        .onReceive(NotificationCenter.default.publisher(for: .jumpTab)) { note in
            if let next = note.object as? Int {
                tab = next
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
            icon(1, "book.fill", "Ucz się")
            icon(2, "headphones", "Słuchaj")
            icon(3, "mic.fill", "Mów")
            icon(11, "person", "Profil")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 12)
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

private struct DockHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct DockPanBridge: UIViewRepresentable {
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
        context.coordinator.install(on: uiView)
    }

    final class Probe: UIView {
        weak var coordinator: Coordinator?
        override func didMoveToWindow() {
            super.didMoveToWindow()
            coordinator?.install(on: self)
        }
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var hidden: Binding<Bool>
        private var installed = false
        private weak var watching: UIScrollView?
        private var observed: NSKeyValueObservation?
        private var hold = Date.distantPast

        init(hidden: Binding<Bool>) { self.hidden = hidden }

        func install(on view: UIView) {
            guard let window = view.window else { return }
            if !installed {
                let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
                pan.delegate = self
                pan.cancelsTouchesInView = false
                pan.delaysTouchesBegan = false
                pan.delaysTouchesEnded = false
                window.addGestureRecognizer(pan)
                installed = true
            }
            if let scroll = liveScroll(in: window) { watch(scroll) }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            true
        }

        @objc func panned(_ gesture: UIPanGestureRecognizer) {
            guard let window = gesture.view as? UIWindow ?? gesture.view?.window else { return }
            guard let scroll = liveScroll(in: window) else { return }
            watch(scroll)
            evaluate(scroll)
        }

        private func watch(_ scroll: UIScrollView) {
            guard scroll !== watching else { return }
            observed?.invalidate()
            watching = scroll
            observed = scroll.observe(\.contentOffset, options: [.new]) { [weak self] scroll, _ in
                if Thread.isMainThread {
                    self?.evaluate(scroll)
                } else {
                    DispatchQueue.main.async { self?.evaluate(scroll) }
                }
            }
        }

        private func evaluate(_ scroll: UIScrollView) {
            guard scroll.window != nil else { return }
            let fromTop = scroll.contentOffset.y + scroll.adjustedContentInset.top
            let short = scroll.contentSize.height <= scroll.bounds.height + 24
            let hide = !short && fromTop > 20
            let show = short || fromTop <= 1
            if hide { apply(true) }
            else if show { apply(false) }
        }

        private func apply(_ hide: Bool) {
            guard hidden.wrappedValue != hide else { return }
            if Date() < hold { return }
            hold = Date().addingTimeInterval(0.35)
            DispatchQueue.main.async {
                guard self.hidden.wrappedValue != hide else { return }
                self.hidden.wrappedValue = hide
            }
        }

        private func liveScroll(in view: UIView) -> UIScrollView? {
            var all: [UIScrollView] = []
            collect(view, into: &all)
            if let hot = all.last(where: { $0.isTracking || $0.isDragging || $0.isDecelerating }) {
                return hot
            }
            return all.last
        }

        private func collect(_ view: UIView, into list: inout [UIScrollView]) {
            if let scroll = view as? UIScrollView,
               scroll.bounds.height > 180, scroll.bounds.width > 200,
               !scroll.isHidden, scroll.alpha > 0.01, scroll.window != nil {
                list.append(scroll)
            }
            for sub in view.subviews { collect(sub, into: &list) }
        }
    }
}

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                more("Teksty i historie", "book.closed.fill", Theme.ok) { TextLibraryView() }
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
                more("Głosy niemieckie", "waveform", Theme.ok) { GermanVoicesView() }
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
