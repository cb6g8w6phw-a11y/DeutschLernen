import SwiftUI

enum Ink {
    static let bg = Color(red: 0.06, green: 0.07, blue: 0.08)
    static let card = Color(red: 0.13, green: 0.14, blue: 0.16)
    static let accent = Color(red: 0.22, green: 0.86, blue: 0.78)
    static let brass = accent
    static let pine = Color(red: 0.35, green: 0.82, blue: 0.62)
    static let clay = Color(red: 0.91, green: 0.38, blue: 0.38)
    static let muted = Color.white.opacity(0.55)
}

struct NightGlow: View {
    var body: some View {
        Ink.bg.ignoresSafeArea()
    }
}

extension View {
    func liquidGlass(radius: CGFloat = 26, interactive: Bool = false, tint: Color? = nil) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return self
            .background(tint ?? Ink.card, in: shape)
            .overlay(shape.stroke(Color.white.opacity(0.06), lineWidth: 1))
    }
}
