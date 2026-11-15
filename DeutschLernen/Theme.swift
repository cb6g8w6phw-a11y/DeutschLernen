import SwiftUI

enum Theme {
    static let bg = Color(hex: "0E1726")
    static let card = Color(hex: "16233A")
    static let card2 = Color(hex: "1C2C48")
    static let track = Color.white.opacity(0.16)
    static let text = Color(hex: "EAF0FA")
    static let text2 = Color(hex: "9AA9BF")
    static let accent = Color(hex: "1F5FBF")
    static let sign = Color(hex: "FFC400")
    static let orange = Color(hex: "FFC400")
    static let ok = Color(hex: "6FD3A1")
    static let bad = Color(hex: "FF9A90")
    static let ink = Color(hex: "13243D")

    static var gradient: LinearGradient {
        LinearGradient(colors: [accent, Color(hex: "0B4EA2")], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static var background: some View {
        Color(hex: "0E1726")
    }

    static func dni(_ n: Int) -> String {
        n == 1 ? "1 dzień" : "\(n) dni"
    }
}

extension View {
    func appBackground() -> some View {
        background { Theme.background.ignoresSafeArea() }
    }

    func themedCard(radius: CGFloat = 24) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return glassEffect(.regular, in: shape)
            .overlay(
                shape.stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.38), Color.white.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            )
    }

    func primaryButton() -> some View {
        font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    func ghostButton() -> some View {
        font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.text)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}

struct MatteGlassButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .padding(.horizontal, 12)
            .glassEffect(.regular, in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.28), lineWidth: 1))
            .opacity(configuration.isPressed ? 0.65 : 1)
    }
}

enum Haptic {
    static func good() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func bad() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var n: UInt64 = 0
        Scanner(string: s).scanHexInt64(&n)
        self.init(
            red: Double((n >> 16) & 0xFF) / 255,
            green: Double((n >> 8) & 0xFF) / 255,
            blue: Double(n & 0xFF) / 255
        )
    }
}
