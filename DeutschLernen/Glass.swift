import SwiftUI

final class LookStore: ObservableObject {
    static let shared = LookStore()

    @Published var style: String {
        didSet { UserDefaults.standard.set(style, forKey: "lookStyle") }
    }
    @Published var palette: String {
        didSet { UserDefaults.standard.set(palette, forKey: "lookPalette") }
    }

    init() {
        style = UserDefaults.standard.string(forKey: "lookStyle") ?? "glass"
        palette = UserDefaults.standard.string(forKey: "lookPalette") ?? "mieta"
    }

    var accent: Color { Self.spec(palette).accent }
    var bg: Color { Self.spec(palette).bg }
    var card: Color { Self.spec(palette).card }
    var pine: Color { Self.spec(palette).pine }
    var clay: Color { Color(red: 1, green: 0.34, blue: 0.38) }
    var muted: Color { Color.white.opacity(0.62) }

    static func spec(_ id: String) -> (accent: Color, bg: Color, card: Color, pine: Color) {
        switch id {
        case "blekit":
            return (
                Color(red: 0.28, green: 0.56, blue: 1),
                Color(red: 0.04, green: 0.06, blue: 0.12),
                Color(red: 0.10, green: 0.15, blue: 0.26),
                Color(red: 0.35, green: 0.82, blue: 1)
            )
        case "fiolet":
            return (
                Color(red: 0.72, green: 0.42, blue: 1),
                Color(red: 0.07, green: 0.04, blue: 0.12),
                Color(red: 0.16, green: 0.10, blue: 0.26),
                Color(red: 0.78, green: 0.62, blue: 1)
            )
        case "slonce":
            return (
                Color(red: 1, green: 0.72, blue: 0.16),
                Color(red: 0.09, green: 0.06, blue: 0.02),
                Color(red: 0.22, green: 0.15, blue: 0.05),
                Color(red: 1, green: 0.86, blue: 0.35)
            )
        case "malina":
            return (
                Color(red: 1, green: 0.28, blue: 0.48),
                Color(red: 0.10, green: 0.03, blue: 0.06),
                Color(red: 0.24, green: 0.08, blue: 0.13),
                Color(red: 1, green: 0.55, blue: 0.68)
            )
        default:
            return (
                Color(red: 0.10, green: 0.95, blue: 0.72),
                Color(red: 0.03, green: 0.07, blue: 0.07),
                Color(red: 0.07, green: 0.16, blue: 0.14),
                Color(red: 0.45, green: 1, blue: 0.78)
            )
        }
    }
}

enum Ink {
    static var bg: Color { LookStore.shared.bg }
    static var card: Color { LookStore.shared.card }
    static var accent: Color { LookStore.shared.accent }
    static var brass: Color { accent }
    static var pine: Color { LookStore.shared.pine }
    static var clay: Color { LookStore.shared.clay }
    static var muted: Color { LookStore.shared.muted }
}

struct NightGlow: View {
    @ObservedObject private var look = LookStore.shared
    var body: some View {
        look.bg.ignoresSafeArea()
    }
}

struct GlassCard: ViewModifier {
    @ObservedObject private var look = LookStore.shared
    var radius: CGFloat
    var tint: Color?

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        let color = tint ?? look.accent
        if look.style == "glass" {
            let glass = Glass.regular.tint(color.opacity(0.55))
            content.glassEffect(glass, in: shape)
        } else {
            content
                .background(look.card, in: shape)
                .overlay(shape.stroke(color.opacity(0.55), lineWidth: 1))
        }
    }
}

extension View {
    func liquidGlass(radius: CGFloat = 22, interactive: Bool = false, tint: Color? = nil) -> some View {
        modifier(GlassCard(radius: radius, tint: tint))
    }
}

struct ThemePicker: View {
    @ObservedObject private var look = LookStore.shared

    private let choices: [(String, String)] = [
        ("mieta", "Mięta"),
        ("blekit", "Błękit"),
        ("fiolet", "Fiolet"),
        ("slonce", "Słońce"),
        ("malina", "Malina")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wygląd").font(.headline)
            HStack(spacing: 8) {
                ForEach(choices, id: \.0) { id, name in
                    Button { look.palette = id } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(LookStore.spec(id).accent)
                                .frame(width: 28, height: 28)
                                .overlay(Circle().stroke(.white.opacity(look.palette == id ? 0.9 : 0), lineWidth: 2))
                            Text(name).font(.caption2).foregroundStyle(look.palette == id ? .white : Ink.muted)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            Picker("Materiał", selection: $look.style) {
                Text("Szkło").tag("glass")
                Text("Mat").tag("matte")
            }
            .pickerStyle(.segmented)
        }
        .padding(14)
        .liquidGlass(radius: 20)
    }
}
