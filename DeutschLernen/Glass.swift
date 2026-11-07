import SwiftUI

enum Ink {
    static let brass = Color(red: 0.90, green: 0.66, blue: 0.36)
    static let pine = Color(red: 0.56, green: 0.75, blue: 0.48)
    static let clay = Color(red: 0.88, green: 0.48, blue: 0.42)
}

struct NightGlow: View {
    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.05, blue: 0.07)
            Circle()
                .fill(Color(red: 0.20, green: 0.36, blue: 0.72).opacity(0.85))
                .frame(width: 360, height: 360)
                .blur(radius: 80)
                .offset(x: -150, y: -300)
            Circle()
                .fill(Color(red: 0.75, green: 0.40, blue: 0.16).opacity(0.55))
                .frame(width: 300, height: 300)
                .blur(radius: 90)
                .offset(x: 160, y: 20)
            Circle()
                .fill(Color(red: 0.12, green: 0.40, blue: 0.32).opacity(0.5))
                .frame(width: 280, height: 280)
                .blur(radius: 90)
                .offset(x: -30, y: 420)
        }
        .ignoresSafeArea()
    }
}

extension View {
    func liquidGlass(radius: CGFloat = 26, interactive: Bool = false, tint: Color? = nil) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        var glass: Glass = interactive ? .regular.interactive() : .regular
        if let tint { glass = glass.tint(tint) }
        return self.glassEffect(glass, in: shape)
    }
}
