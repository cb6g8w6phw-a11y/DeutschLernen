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
                        if generating { ProgressView() } else { Text("Wygeneruj nowe słówka (Gemini)") }
                    }
                    .disabled(generating)
                    if !message.isEmpty { Text(message).font(.footnote).foregroundStyle(.secondary) }
                }
            }
            .navigationTitle("Postępy")
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
        Zwróć TYLKO tablicę JSON obiektów z polami: "de" (z rodzajnikiem dla rzeczowników), "pl", "ex" (krótkie zdanie przykładowe po niemiecku), "exPl" (tłumaczenie zdania na polski), "topic" (krótka nazwa tematu po polsku).
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś nauczycielem niemieckiego dla Polaka. Odpowiadasz wyłącznie poprawnym JSON-em.",
                json: true)
            let cleaned = text
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let items = try JSONDecoder().decode([AIWord].self, from: Data(cleaned.utf8))
            let added = store.addWords(items.map {
                Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: $0.topic)
            })
            message = "Dodano \(added) nowych słówek. Zobaczysz je w następnej sesji."
        } catch {
            message = "⚠️ \(error.localizedDescription)"
        }
    }
}
