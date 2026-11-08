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
            List {
                Section("Podsumowanie") {
                    LabeledContent("Opanowane", value: "\(store.masteredCount)")
                    LabeledContent("W nauce", value: "\(store.learningCount)")
                    LabeledContent("Nowe", value: "\(store.newCount)")
                    LabeledContent("Dzień planu", value: "\(store.planDay)/30")
                    LabeledContent("Rozmowa w tym miesiącu", value: store.talkLabel)
                    LabeledContent("Słuchanie", value: store.journal.listenTries == 0 ? "jeszcze nic" : "\(store.journal.listenOk)/\(store.journal.listenTries)")
                    LabeledContent("Zdania na głos", value: "\(store.journal.said)")
                    LabeledContent("Sceny", value: "\(store.journal.scenes.count)/\(Scenarios.all.count)")
                }
                Section("Błędy") {
                    let slips = store.mistakesToday.isEmpty ? Array(store.journal.mistakes.prefix(8)) : store.mistakesToday
                    if slips.isEmpty {
                        Text("Jak w rozmowie powiesz coś krzywo, wpadnie to tutaj.").foregroundStyle(.secondary)
                    }
                    ForEach(slips) { slip in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(slip.text)
                            if !slip.fix.isEmpty {
                                Text(slip.fix).font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section("Skuteczność wg tematów") {
                    let topics = store.topicAccuracy()
                    if topics.isEmpty { Text("Brak danych – zrób pierwszą sesję.").foregroundStyle(.secondary) }
                    ForEach(topics, id: \.topic) { t in
                        VStack(alignment: .leading) {
                            HStack { Text(t.topic); Spacer(); Text("\(Int(t.accuracy * 100))%") }
                            ProgressView(value: t.accuracy)
                        }
                    }
                }
                Section("Do poprawy") {
                    let weak = store.weakWords.prefix(10)
                    if weak.isEmpty { Text("Na razie nic.").foregroundStyle(.secondary) }
                    ForEach(Array(weak)) { w in
                        HStack { Text(w.de); Spacer(); Text(w.pl).foregroundStyle(.secondary) }
                    }
                }
                Section("Lekcja od AI") {
                    Button {
                        Task { await generateLesson() }
                    } label: {
                        if generating { ProgressView() } else { Text("Wygeneruj nowe słówka") }
                    }
                    .disabled(generating)
                    if !message.isEmpty { Text(message).font(.footnote).foregroundStyle(.secondary) }
                }
            }
            .navigationTitle("Postępy")
            .scrollContentBackground(.hidden)
            .containerBackground(for: .navigation) { NightGlow() }
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
