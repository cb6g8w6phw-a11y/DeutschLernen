import SwiftUI

/// Ścieżka lekcji: zrobione, bieżące, zablokowane. Kolejność jest ta sama co w CourseView.
struct LessonPath: View {
    private let stops: [(id: String, title: String, symbol: String)] = [
        ("jestem", "Jestem", "person.fill"),
        ("czas", "Godzina", "clock.fill"),
        ("spoznienie", "Zmiana", "bus.fill"),
        ("rodzaj", "Rodzajniki", "textformat"),
        ("przypadek", "Przypadki", "arrow.left.arrow.right"),
        ("musze", "Muszę", "bolt.fill")
    ]

    @State private var passed: [String] = []
    @State private var lockedNote = ""

    var body: some View {
        let open = stops.firstIndex { !passed.contains($0.id) } ?? stops.count
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Ścieżka")
                    .font(.title2.bold())
                Spacer()
                Text("\(min(open, stops.count))/\(stops.count)")
                    .font(.subheadline.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Theme.track, in: Capsule())
            }
            ZStack {
                Capsule()
                    .fill(Theme.track)
                    .frame(width: 12)
                    .padding(.vertical, 36)
                VStack(spacing: 26) {
                    ForEach(Array(stops.enumerated()), id: \.offset) { index, stop in
                        let state: PathNode.State = index < open ? .done : (index == open ? .now : .locked)
                        HStack {
                            if index.isMultiple(of: 2) { Spacer(minLength: 0) }
                            node(stop, state: state, previous: index == 0 ? nil : stops[index - 1].title)
                            if !index.isMultiple(of: 2) { Spacer(minLength: 0) }
                        }
                        .padding(.leading, index.isMultiple(of: 2) ? 36 : 8)
                        .padding(.trailing, index.isMultiple(of: 2) ? 8 : 36)
                    }
                }
            }
            if !lockedNote.isEmpty {
                Text(lockedNote)
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
        }
        .onAppear { passed = UserDefaults.standard.stringArray(forKey: "coursePassed") ?? [] }
    }

    @ViewBuilder
    private func node(_ stop: (id: String, title: String, symbol: String), state: PathNode.State, previous: String?) -> some View {
        if state == .locked {
            Button {
                lockedNote = "Najpierw \(previous ?? "poprzednia lekcja"). Ta zostaje zamknięta."
            } label: {
                PathNode(title: stop.title, symbol: stop.symbol, state: state)
            }
            .buttonStyle(.plain)
        } else {
            NavigationLink { CourseView() } label: {
                PathNode(title: stop.title, symbol: stop.symbol, state: state)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct PathNode: View {
    enum State { case done, now, locked }
    let title: String
    let symbol: String
    let state: State

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(shadow)
                    .frame(width: diameter, height: diameter)
                    .offset(y: 6)
                face
                    .frame(width: diameter, height: diameter)
                    .overlay(Circle().stroke(Color.white.opacity(state == .locked ? 0 : 0.28), lineWidth: 2))
                Image(systemName: state == .done ? "checkmark" : (state == .locked ? "lock.fill" : symbol))
                    .font(.system(size: state == .now ? 26 : 20, weight: .bold))
                    .foregroundStyle(state == .locked ? Theme.text2 : .white)
            }
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(state == .now ? Theme.text : Theme.text2)
        }
        .frame(width: 108)
    }

    private var diameter: CGFloat { state == .now ? 86 : 72 }

    private var shadow: Color {
        switch state {
        case .done: return Color(hex: "1E7A34")
        case .now: return Color(hex: "5A3CC4")
        case .locked: return Color(hex: "1A1528")
        }
    }

    @ViewBuilder private var face: some View {
        switch state {
        case .done:
            Circle().fill(Theme.ok)
        case .now:
            Circle().fill(Theme.gradient)
        case .locked:
            Circle().fill(Theme.card2)
        }
    }
}
