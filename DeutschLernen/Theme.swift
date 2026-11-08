import SwiftUI

enum Theme {
    static let bg = Color(red: 0x14 / 255, green: 0x10 / 255, blue: 0x1F / 255)
    static let card = Color(red: 0x1F / 255, green: 0x19 / 255, blue: 0x32 / 255)
    static let card2 = Color(red: 0x24 / 255, green: 0x1D / 255, blue: 0x3D / 255)
    static let track = Color(red: 0x2D / 255, green: 0x25 / 255, blue: 0x47 / 255)
    static let text = Color(red: 0xF4 / 255, green: 0xF1 / 255, blue: 1)
    static let text2 = Color(red: 0xB9 / 255, green: 0xB1 / 255, blue: 0xD6 / 255)
    static let accent = Color(red: 0x8B / 255, green: 0x6C / 255, blue: 0xF0 / 255)
    static let orange = Color(red: 1, green: 0x9A / 255, blue: 0x62 / 255)
    static let ink = Color(red: 0x14 / 255, green: 0x10 / 255, blue: 0x1F / 255)

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
    static func good() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func bad() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
