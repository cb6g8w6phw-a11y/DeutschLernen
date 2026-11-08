import SwiftUI

enum Theme {
    static let bg = Color(red: 0x14 / 255, green: 0x10 / 255, blue: 0x1F / 255)
    static let card = Color(red: 0x1F / 255, green: 0x19 / 255, blue: 0x32 / 255)
    static let card2 = Color(red: 0x24 / 255, green: 0x1D / 255, blue: 0x3D / 255)
    static let track = Color(red: 0x2D / 255, green: 0x25 / 255, blue: 0x47 / 255)
    static let text = Color(red: 0xF4 / 255, green: 0xF1 / 255, blue: 1)
    static let text2 = Color(red: 0.86, green: 0.84, blue: 0.94)
    static let accent = Color(hex: "8B6CF0")
    static let orange = Color(hex: "FF9A62")
    static let ok = Color(hex: "34C759")
    static let bad = Color(hex: "FF453A")
    static let ink = Color(hex: "14101F")

    static var gradient: LinearGradient {
        LinearGradient(colors: [accent, orange], startPoint: .leading, endPoint: .trailing)
    }

    static var background: some View {
        RadialGradient(
            colors: [Color(red: 0x3A / 255, green: 0x2A / 255, blue: 0x6B / 255), bg],
            center: .topLeading,
            startRadius: 20,
            endRadius: 520
        )
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
        return background(Theme.card, in: shape)
            .overlay(shape.stroke(Color.white.opacity(0.09), lineWidth: 1))
    }

    func primaryButton() -> some View {
        font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundStyle(Theme.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.gradient, in: Capsule())
    }

    func ghostButton() -> some View {
        font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.text)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
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
