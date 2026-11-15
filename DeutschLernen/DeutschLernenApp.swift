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
        VStack(spacing: 0) {
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
                case 12: NavigationStack { TextLibraryView() }
                default: TodayView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            AppDock(tab: $tab)
                .padding(.bottom, 6)
                .frame(height: dockHidden ? 0 : nil, alignment: .top)
                .clipped()
                .opacity(dockHidden ? 0 : 1)
                .allowsHitTesting(!dockHidden)
        }
        .background(NightGlow())
        .background(DockPanBridge(hidden: $dockHidden))
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
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                card(5, "bubble.left.and.bubble.right.fill", "Mini dialogi", "100+ scenek z życia")
                card(6, "text.book.closed.fill", "Wzorce gramatyczne", "Gramatyka przez praktykę")
            }
            Button { tab = 12 } label: {
                HStack(spacing: 8) {
                    Image(systemName: "book.closed.fill")
                    Text("Teksty i historie").font(.caption.weight(.bold))
                    Spacer()
                    Text("Tłumaczenie po kliknięciu").font(.caption2).foregroundStyle(tab == 12 ? Theme.ink.opacity(0.8) : Theme.text2)
                }
                .foregroundStyle(tab == 12 ? Theme.ink : Theme.text)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: 36)
                .background(tab == 12 ? Theme.ok : Color.white.opacity(0.08), in: Capsule())
            }
            .buttonStyle(.plain)
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
        private var lock = Date.distantPast

        init(hidden: Binding<Bool>) { self.hidden = hidden }

        func install(on view: UIView) {
            guard !installed, let window = view.window else { return }
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
            pan.delegate = self
            pan.cancelsTouchesInView = false
            pan.delaysTouchesBegan = false
            window.addGestureRecognizer(pan)
            installed = true
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            true
        }

        @objc func panned(_ gesture: UIPanGestureRecognizer) {
            guard gesture.state == .changed || gesture.state == .ended else { return }
            let move = gesture.translation(in: gesture.view)
            if abs(move.x) > abs(move.y) + 16 { return }
            if move.y < -20 { apply(true) }
            else if move.y > 20 { apply(false) }
        }

        func apply(_ hide: Bool) {
            guard Date() > lock, hidden.wrappedValue != hide else { return }
            lock = Date().addingTimeInterval(0.35)
            DispatchQueue.main.async {
                withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                    self.hidden.wrappedValue = hide
                }
            }
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
