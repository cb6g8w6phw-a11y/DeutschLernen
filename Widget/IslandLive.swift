import ActivityKit
import SwiftUI
import WidgetKit

struct StudyIslandWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StudyAttributes.self) { context in
            lock(context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: symbol(context.state))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(tint(context.state))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(trailing(context.state))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(headline(context.state))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    bottom(context.state)
                }
            } compactLeading: {
                Image(systemName: symbol(context.state))
                    .foregroundStyle(tint(context.state))
            } compactTrailing: {
                Text(trailing(context.state))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
            } minimal: {
                Image(systemName: symbol(context.state))
                    .foregroundStyle(tint(context.state))
            }
        }
    }

    private func lock(_ state: StudyAttributes.ContentState) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: symbol(state))
                    .foregroundStyle(tint(state))
                Text(state.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text(trailing(state))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
            }
            Text(headline(state))
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(3)
            if state.kind == "line" {
                Button(intent: FlipLineIntent()) {
                    Text(state.showPolish ? "Pokaż po niemiecku" : "Pokaż po polsku")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color(red: 0.65, green: 0.55, blue: 0.98))
            } else if state.kind != "voice" {
                Text(state.showPolish ? state.de : state.pl)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(2)
            }
        }
        .padding(14)
        .activityBackgroundTint(Color(red: 0.08, green: 0.06, blue: 0.14))
    }

    @ViewBuilder
    private func bottom(_ state: StudyAttributes.ContentState) -> some View {
        switch state.kind {
        case "line":
            Button(intent: FlipLineIntent()) {
                Text(state.showPolish ? "Po niemiecku" : "Po polsku")
                    .font(.caption.weight(.bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color(red: 0.65, green: 0.55, blue: 0.98))
        case "speak":
            Text(speakNote(state))
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint(state))
        case "voice":
            Text(state.listening ? "Nagrywam głosówkę" : "Nagranie zatrzymane")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
        default:
            ProgressView(value: Double(state.done), total: Double(max(state.total, 1)))
                .tint(Color(red: 0.55, green: 0.42, blue: 0.94))
        }
    }

    private func headline(_ state: StudyAttributes.ContentState) -> String {
        if state.kind == "line", state.warn {
            let left = max(0, state.total - state.done)
            return "Zostało \(left) słówek"
        }
        if state.kind == "voice" { return state.listening ? "Słucham…" : "Gotowe" }
        return state.showPolish && state.kind == "line" ? state.pl : state.de
    }

    private func trailing(_ state: StudyAttributes.ContentState) -> String {
        switch state.kind {
        case "voice":
            return String(format: "%d:%02d", state.seconds / 60, state.seconds % 60)
        case "line":
            if state.warn { return "\(max(0, state.total - state.done))" }
            return state.showPolish ? "PL" : "DE"
        default:
            return "\(min(state.done + 1, max(state.total, 1)))/\(max(state.total, 1))"
        }
    }

    private func symbol(_ state: StudyAttributes.ContentState) -> String {
        switch state.kind {
        case "speak": return state.listening ? "waveform" : "mic.fill"
        case "voice": return "mic.fill"
        case "line": return state.warn ? "flame.fill" : "text.quote"
        default: return "book.closed.fill"
        }
    }

    private func tint(_ state: StudyAttributes.ContentState) -> Color {
        if state.kind == "speak" {
            if state.listening { return Color(red: 1, green: 0.6, blue: 0.38) }
            if state.marked { return state.ok ? Color(red: 0.2, green: 0.78, blue: 0.35) : Color(red: 1, green: 0.27, blue: 0.23) }
        }
        if state.kind == "voice", state.listening { return Color(red: 1, green: 0.27, blue: 0.23) }
        if state.warn, state.kind == "line" { return Color(red: 1, green: 0.6, blue: 0.38) }
        return Color(red: 0.55, green: 0.42, blue: 0.94)
    }

    private func speakNote(_ state: StudyAttributes.ContentState) -> String {
        if state.listening { return "Mów teraz" }
        if !state.marked { return "Stuknij Powiedz" }
        return state.ok ? "Całe zdanie słyszalne" : "Popraw jeszcze raz"
    }
}
