import SwiftUI
import WidgetKit

struct ZdanieEntry: TimelineEntry {
    let date: Date
    let de: String
    let pl: String
}

struct ZdanieProvider: TimelineProvider {
    func placeholder(in context: Context) -> ZdanieEntry {
        ZdanieEntry(date: Date(), de: DayLines.all[0].0, pl: DayLines.all[0].1)
    }

    func getSnapshot(in context: Context, completion: @escaping (ZdanieEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ZdanieEntry>) -> Void) {
        let next = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()
        completion(Timeline(entries: [entry()], policy: .after(next)))
    }

    private func entry() -> ZdanieEntry {
        let line = DayLines.today()
        return ZdanieEntry(date: Date(), de: line.0, pl: line.1)
    }
}

struct ZdanieView: View {
    let entry: ZdanieEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Zdanie na dziś")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(red: 0.86, green: 0.84, blue: 0.94))
            Text(entry.de)
                .font(family == .systemSmall ? .headline : .title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
            if family == .systemMedium {
                Text(entry.pl)
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.86, green: 0.84, blue: 0.94))
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "3A2A6B"), Color(hex: "14101F")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

private extension Color {
    init(hex: String) {
        var n: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&n)
        self.init(
            red: Double((n >> 16) & 0xFF) / 255,
            green: Double((n >> 8) & 0xFF) / 255,
            blue: Double(n & 0xFF) / 255
        )
    }
}

struct DeutschWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Zdanie", provider: ZdanieProvider()) { entry in
            ZdanieView(entry: entry)
        }
        .configurationDisplayName("Zdanie na dziś")
        .description("Jedno zdanie po niemiecku i po polsku.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct DeutschWidgetBundle: WidgetBundle {
    var body: some Widget {
        DeutschWidget()
        StudyIslandWidget()
    }
}
