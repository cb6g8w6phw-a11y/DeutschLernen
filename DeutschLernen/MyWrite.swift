import SwiftUI

/// Osobna sekcja: polski tekst użytkownika, niemiecki zwrot i nauka tylko tego.
struct WriteLearnView: View {
    @EnvironmentObject var store: LearningStore
    @State private var input = ""
    @State private var german = ""
    @State private var polish = ""
    @State private var busy = false
    @State private var note = ""
    @State private var hide = false
    @State private var typed = ""
    @State private var verdict = ""
    @FocusState private var writing: Bool

    private var mine: [Word] {
        Array(store.words.filter { $0.topic == "Moje" }.reversed())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Napisz po polsku to, czego chcesz się nauczyć. Zostaje w tej sekcji, nie w ogólnych fiszkach.")
                    .foregroundStyle(Theme.text2)
                TextField("Na przykład: jutro muszę iść do lekarza", text: $input, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)
                    .focused($writing)
                Button {
                    Task { await save() }
                } label: {
                    Group {
                        if busy { ProgressView().tint(Theme.ink) }
                        else { Text("Weź to do nauki") }
                    }
                    .primaryButton()
                }
                .buttonStyle(.plain)
                .disabled(busy || input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                if !note.isEmpty { Text(note).font(.footnote).foregroundStyle(Theme.text2) }
                if !german.isEmpty { current }
                if !mine.isEmpty {
                    Text("Twoje zdania").font(.headline)
                    ForEach(Array(mine.enumerated()), id: \.offset) { _, word in
                        Button {
                            polish = word.pl
                            german = word.de
                            hide = false
                            typed = ""
                            verdict = ""
                        } label: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(word.pl).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.text)
                                Text(word.de).font(.caption).foregroundStyle(Theme.text2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.glass)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Pisanie")
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .onDisappear { Talk.stop() }
    }

    @ViewBuilder private var current: some View {
        Text(polish).font(.headline)
        if hide {
            TextField("Napisz po niemiecku", text: $typed, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($writing)
            Button("Sprawdź") { grade() }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            if !verdict.isEmpty { Text(verdict).foregroundStyle(Theme.text2) }
        } else {
            Text(german).font(.title3.bold())
            Button { Talk.de(german, rate: 0.42) } label: { Label("Posłuchaj", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Button("Schowaj i napisz sam") {
                hide = true
                typed = ""
                verdict = ""
                writing = true
            }
            .primaryButton()
        }
    }

    private func save() async {
        let source = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard source.count > 1 else { return }
        busy = true
        note = "Tłumaczę…"
        defer { busy = false }
        let prompt = """
        Użytkownik napisał po polsku:
        \(source.prefix(500))

        Odpowiedz dokładnie dwiema liniami, bez komentarza:
        DE: jedno naturalne zdanie po niemiecku, poziom A2
        PL: to samo zdanie po polsku
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Tłumaczysz polski na prosty niemiecki. Nic nie dopisujesz od siebie.")
            let de = field(text, "DE")
            let pl = field(text, "PL")
            guard de.split(separator: " ").count >= 2 else {
                note = "Nie dostałem pełnego zdania. Spróbuj jeszcze raz."
                return
            }
            german = de
            polish = pl.isEmpty ? source : pl
            hide = false
            typed = ""
            verdict = ""
            let word = Word(de: de, pl: polish, ex: de, exPl: polish, topic: "Moje", level: "A2")
            store.pinForReview(word)
            input = ""
            writing = false
            note = "Jest w sekcji Moje. Najpierw posłuchaj, potem napisz sam."
        } catch {
            note = error.localizedDescription
        }
    }

    private func grade() {
        writing = false
        let word = Word(de: german, pl: polish, ex: german, exPl: polish, topic: "Moje", level: "A2")
        if Normalizer.same(typed, german) {
            verdict = "To zdanie wchodzi. Przypomnienie za kilka dni."
            store.grade(word, .easy, produced: true)
            store.noteSkill("sentence", ok: true)
            Haptic.good()
        } else {
            verdict = "Jeszcze nie. Zostaje tutaj i w zeszycie. Tak się pisze: \(german)"
            store.scheduleTomorrow(word)
            HardBook.add(de: german, pl: polish)
            store.noteSkill("sentence", ok: false)
            Haptic.bad()
        }
    }

    private func field(_ text: String, _ tag: String) -> String {
        for raw in text.components(separatedBy: .newlines) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            let key = line.uppercased()
            guard key.hasPrefix(tag + ":") || key.hasPrefix(tag + " ") else { continue }
            let value = line.split(separator: ":", maxSplits: 1).dropFirst().joined()
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
}
