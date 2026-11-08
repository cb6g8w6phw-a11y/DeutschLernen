import SwiftUI

struct AIWord: Decodable {
    let de: String
    let pl: String
    let ex: String
    let exPl: String
    let topic: String
}

struct StatsView: View {
    @EnvironmentObject var store: LearningStore
    @State private var generating = false
    @State private var message = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    summary
                    topics
                    activity
                    skills
                    mistakes
                    weak
                    lesson
                }
                .padding()
            }
            .navigationTitle("Postęp")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var summary: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(store.learningCount)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.text)
                Text("słów w nauce, opanowane \(store.masteredCount)")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Theme.text2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(Theme.dni(store.streak))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.text)
                Text("Seria")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Theme.text2)
            }
        }
        .padding(16)
        .themedCard()
    }

    private var topics: some View {
        let rows = store.topicAccuracy().prefix(6)
        return VStack(alignment: .leading, spacing: 10) {
            Text("Tematy").font(.headline)
            if rows.isEmpty {
                Text("Po pierwszej sesji zobaczysz, co już siedzi.").foregroundStyle(Ink.muted)
            }
            ForEach(Array(rows), id: \.topic) { row in
                HStack {
                    Text(row.topic).font(.subheadline)
                    Spacer()
                    Text("\(Int(row.accuracy * 100))%").font(.caption).foregroundStyle(Ink.muted)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Theme.track)
                        Capsule().fill(Theme.gradient).frame(width: max(6, geo.size.width * row.accuracy))
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var activity: some View {
        let days = store.recentActivity()
        let maxValue = max(days.map(\.value).max() ?? 1, 1)
        return VStack(alignment: .leading, spacing: 10) {
            Text("Powtórki, 14 dni").font(.system(size: 17, weight: .semibold, design: .rounded))
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(day.label == days.last?.label ? AnyShapeStyle(Theme.gradient) : AnyShapeStyle(Theme.accent.opacity(day.value == 0 ? 0.25 : 0.7)))
                            .frame(height: max(6, 70 * CGFloat(day.value) / CGFloat(maxValue)))
                        Text(day.label).font(.system(size: 8)).foregroundStyle(Ink.muted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 96, alignment: .bottom)
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var skills: some View {
        let words = store.words.isEmpty ? 0 : Double(store.masteredCount) / Double(store.words.count)
        let listen = store.journal.listenTries == 0 ? 0 : Double(store.journal.listenOk) / Double(store.journal.listenTries)
        let talk = min(1, Double(store.monthTalkSeconds) / 1800)
        let scenes = Scenarios.all.isEmpty ? 0 : Double(store.journal.scenes.count) / Double(Scenarios.all.count)
        let rows: [(String, Double)] = [("Słówka", words), ("Słuchanie", listen), ("Rozmowa", talk), ("Sceny", scenes)]
        return VStack(alignment: .leading, spacing: 10) {
            Text("Umiejętności").font(.headline)
            ForEach(rows, id: \.0) { name, value in
                HStack {
                    Text(name).frame(width: 90, alignment: .leading).font(.subheadline)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.08))
                            Capsule().fill(Ink.accent).frame(width: geo.size.width * value)
                        }
                    }
                    .frame(height: 8)
                }
            }
            Text("Rozmowa w tym miesiącu: \(store.talkLabel) · Dzień \(store.planDay)/30")
                .font(.footnote)
                .foregroundStyle(Ink.muted)
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var mistakes: some View {
        let slips = store.mistakesToday.isEmpty ? Array(store.journal.mistakes.prefix(6)) : store.mistakesToday
        return VStack(alignment: .leading, spacing: 8) {
            Text("Błędy").font(.headline)
            if slips.isEmpty {
                Text("Jak w rozmowie powiesz coś krzywo, wpadnie to tutaj.").foregroundStyle(Ink.muted)
            }
            ForEach(slips) { slip in
                VStack(alignment: .leading, spacing: 2) {
                    Text(slip.text)
                    if !slip.fix.isEmpty { Text(slip.fix).font(.footnote).foregroundStyle(Ink.muted) }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 22)
    }

    private var weak: some View {
        let weak = Array(store.weakWords.prefix(6))
        return VStack(alignment: .leading, spacing: 8) {
            Text("Do poprawy").font(.headline)
            if weak.isEmpty { Text("Na razie nic.").foregroundStyle(Ink.muted) }
            ForEach(weak) { word in
                HStack {
                    Text(word.de)
                    Spacer()
                    Text(word.pl).foregroundStyle(Ink.muted)
                }
                .font(.subheadline)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 22)
    }

    private var lesson: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                Task { await generateLesson() }
            } label: {
                Text(generating ? "Chwilę…" : "Wygeneruj nowe słówka")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 12)
            .background(Ink.accent, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(.black)
            .disabled(generating)
            if !message.isEmpty { Text(message).font(.footnote).foregroundStyle(Ink.muted) }
        }
    }

    private func generateLesson() async {
        generating = true
        message = ""
        defer { generating = false }
        let known = store.words.map(\.de).suffix(300).joined(separator: ", ")
        let prompt = """
        Postępy ucznia:
        \(store.progressSummary())

        Znane już słówka (NIE powtarzaj ich): \(known)

        Wygeneruj 10 NOWYCH, przydatnych słówek lub zwrotów (poziom A2–B1) do codziennego życia i pracy w Niemczech. \
        Skup się na tematach, w których uczeń ma najniższą skuteczność, oraz na tych samych trudnościach co słabe słowa. \
        Nie podawaj bardzo łatwych słów (powitania, liczby, kolory).
        Zwróć JSON obiektu {"items":[{"de":"","pl":"","ex":"","exPl":"","topic":""}]}. Nic poza JSON.
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś nauczycielem niemieckiego dla Polaka. Odpowiadasz wyłącznie poprawnym JSON-em.",
                json: true)
            let items = try WordJSON.decode(text)
            let added = store.addWords(items.map {
                Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: $0.topic)
            })
            message = "Dodano \(added) nowych słówek. Zobaczysz je w następnej sesji."
        } catch {
            message = "⚠️ Nie wyszła lista słówek. Stuknij jeszcze raz."
        }
    }
}

enum WordJSON {
    static func decode(_ text: String) throws -> [AIWord] {
        let raw = jsonSlice(text)
        let data = Data(raw.utf8)
        if let items = try? JSONDecoder().decode([AIWord].self, from: data), !items.isEmpty { return items }
        guard let obj = try? JSONSerialization.jsonObject(with: data) else { throw GeminiError.badResponse }
        let rows: [[String: Any]]
        if let arr = obj as? [[String: Any]] {
            rows = arr
        } else if let dict = obj as? [String: Any] {
            rows = (dict["items"] ?? dict["words"] ?? dict["slowka"]) as? [[String: Any]] ?? []
        } else {
            rows = []
        }
        let words: [AIWord] = rows.compactMap { row in
            func pick(_ keys: String...) -> String {
                for key in keys {
                    if let value = row[key] as? String {
                        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty { return trimmed }
                    }
                }
                return ""
            }
            let de = pick("de", "german", "niemiecki")
            guard !de.isEmpty else { return nil }
            let pl = pick("pl", "polish", "polski")
            let ex = pick("ex", "example", "sentence")
            let topic = pick("topic", "temat")
            return AIWord(
                de: de,
                pl: pl.isEmpty ? de : pl,
                ex: ex.isEmpty ? de : ex,
                exPl: pick("exPl", "examplePl", "tlumaczenie"),
                topic: topic.isEmpty ? "Z życia" : topic)
        }
        if words.isEmpty { throw GeminiError.badResponse }
        return words
    }
}
