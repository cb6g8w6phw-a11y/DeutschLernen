import SwiftUI

enum Theme {
    static let bg = Color.black
    static let card = Color(white: 0.11)
    static let card2 = Color(white: 0.16)
    static let track = Color.white.opacity(0.12)
    static let text = Color.white
    static let text2 = Color.white.opacity(0.55)
    static let accent = Color.white
    static let orange = Color.white.opacity(0.72)
    static let ok = Color(hex: "3DDC84")
    static let bad = Color(hex: "FF453A")
    static let ink = Color.black

    static var gradient: LinearGradient {
        LinearGradient(colors: [.white, .white], startPoint: .leading, endPoint: .trailing)
    }

    static var background: some View {
        Color.black
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
        return background(.ultraThinMaterial, in: shape)
            .background(Color.white.opacity(0.05), in: shape)
            .overlay(shape.stroke(Color.white.opacity(0.10), lineWidth: 1))
    }

    func primaryButton() -> some View {
        font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(.white, in: Capsule())
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
            .background(.ultraThinMaterial, in: Capsule())
            .background(Color.white.opacity(0.08), in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.22), lineWidth: 1))
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
