import SwiftUI

struct TutorAvatar: View {
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let ui = UIImage(named: "Tutor") {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .padding(size * 0.16)
                    .foregroundStyle(.white)
                    .background(Theme.accent)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Theme.gradient, lineWidth: 2))
        .accessibilityLabel("Tutor")
    }
}

struct IconBadge: View {
    let system: String
    let tint: Color

    var body: some View {
        Image(systemName: system)
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .accessibilityHidden(true)
    }
}

struct LoadingDots: View {
    @State private var on = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TutorAvatar(size: 36)
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Theme.text)
                        .frame(width: 8, height: 8)
                        .offset(y: on ? -4 : 2)
                        .animation(.easeInOut(duration: 0.45).repeatForever().delay(Double(i) * 0.12), value: on)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Theme.card2, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .onAppear { on = true }
        .accessibilityLabel("Ładuję odpowiedź")
    }
}

struct ErrorRetry: View {
    let text: String
    let retry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "wifi.exclamationmark")
                .font(.title2)
                .foregroundStyle(Theme.bad)
            Text(text)
                .font(.body)
                .foregroundStyle(Theme.text)
            Button(action: retry) {
                Text("Spróbuj ponownie")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                    .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .themedCard()
    }
}

struct ConfettiView: View {
    @State private var fall = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<28, id: \.self) { i in
                Circle()
                    .fill([Theme.accent, Theme.orange, Theme.ok, Color(hex: "5AC8FA")][i % 4])
                    .frame(width: 8, height: 8)
                    .position(
                        x: CGFloat((i * 41) % max(Int(geo.size.width), 1)),
                        y: fall ? geo.size.height + 30 : -20
                    )
                    .animation(.easeIn(duration: 1.3).delay(Double(i) * 0.02), value: fall)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            fall = true
            Haptic.good()
        }
    }
}
