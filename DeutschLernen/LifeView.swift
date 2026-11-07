import SwiftUI

struct LifeView: View {
    @EnvironmentObject var store: LearningStore
    @State private var tab = "Temat"

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Narzędzie", selection: $tab) {
                    Text("Temat").tag("Temat")
                    Text("SOS").tag("SOS")
                    Text("Korekta").tag("Korekta")
                    Text("Klocki").tag("Klocki")
                    Text("Głos").tag("Głos")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                Group {
                    switch tab {
                    case "SOS": SOSPane()
                    case "Korekta": CorrectPane()
                    case "Klocki": BlocksPane()
                    case "Głos": ShadowPane()
                    default: TopicPane()
                    }
                }
                .environmentObject(store)
            }
            .navigationTitle("Z twojego życia")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

private struct TopicPane: View {
    @EnvironmentObject var store: LearningStore
    @State private var topic = ""
    @State private var busy = false
    @State private var note = ""
    @State private var made: [Word] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Wpisz, czym się zajmujesz albo co akurat robisz. Dostaniesz 10 zdań z tej roboty, od razu do powtórek.")
                    .foregroundStyle(.secondary)
                TextField("Np. montaż klimatyzacji, zawieszenie w Audi", text: $topic, axis: .vertical)
                    .lineLimit(1...3)
                    .padding(12)
                    .liquidGlass(radius: 18)
                Button {
                    Task { await generate() }
                } label: {
                    if busy { ProgressView() } else { Text("Generuj 10 zdań") }
                }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
                .disabled(busy || topic.trimmingCharacters(in: .whitespaces).count < 3)
                if !note.isEmpty { Text(note).font(.footnote).foregroundStyle(.secondary) }
                ForEach(made) { w in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(w.ex).font(.headline)
                        Text(w.exPl).font(.footnote).foregroundStyle(.secondary)
                        Button { Talk.de(w.ex) } label: { Image(systemName: "speaker.wave.2") }
                            .buttonStyle(.glass)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .liquidGlass(radius: 18)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func generate() async {
        busy = true
        note = "Łączę…"
        defer { busy = false }
        let prompt = """
        Temat z życia użytkownika: \(topic).
        Wygeneruj 10 praktycznych zdań po niemiecku (A2), których użyje w tej sytuacji w Niemczech.
        Nie dawaj powitań. Każde zdanie ma być pełne i naturalne.
        Zwróć TYLKO JSON: tablicę obiektów z polami de, pl, ex, exPl, topic.
        de = krótki zwrot (max 8 słów), pl = tłumaczenie zwrotu, ex = pełne zdanie po niemiecku, exPl = tłumaczenie zdania, topic = krótka nazwa po polsku.
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Odpowiadasz wyłącznie JSON-em.",
                json: true)
            let items = try JSONDecoder().decode([AIWord].self, from: Data(jsonSlice(text).utf8))
            let words = items.map { Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: $0.topic, level: "A2") }
            let added = store.addWords(words)
            made = words
            note = "Dodano \(added) do powtórek. Reszta już tam była."
        } catch {
            note = error.localizedDescription
        }
    }
}

private struct SOSPane: View {
    @EnvironmentObject var store: LearningStore
    @State private var need = ""
    @State private var reply = ""
    @State private var busy = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Napisz po polsku, co musisz powiedzieć. Dostaniesz zdanie normalne, prostsze i co może odpowiedzieć druga strona.")
                    .foregroundStyle(.secondary)
                TextField("Muszę spytać klienta, gdzie jest główny wyłącznik prądu", text: $need, axis: .vertical)
                    .lineLimit(2...5)
                    .padding(12)
                    .liquidGlass(radius: 18)
                Button { Task { await ask() } } label: {
                    if busy { ProgressView() } else { Text("Jak to powiedzieć") }
                }
                .buttonStyle(.glassProminent)
                .tint(Ink.brass)
                .disabled(busy || need.trimmingCharacters(in: .whitespaces).count < 4)
                if !reply.isEmpty {
                    Text(reply).padding(12).liquidGlass(radius: 18)
                    Button("Odtwórz") { Talk.de(firstLine(reply)) }.buttonStyle(.glass)
                    Button("Zapisz do powtórek") { saveLine() }.buttonStyle(.glass)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func ask() async {
        busy = true
        defer { busy = false }
        let prompt = """
        Polak na poziomie A2 musi to powiedzieć w Niemczech, w pracy albo w życiu:
        \(need)
        Odpowiedz dokładnie tak, bez markdownu:
        NORMALNIE: zdanie po niemiecku
        PROŚCIEJ: jeszcze prostsza wersja
        DRUGA STRONA: prawdopodobna krótka odpowiedź po niemiecku
        ZAPISZ: najlepsze zdanie po niemiecku | tłumaczenie po polsku
        """
        do {
            reply = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś tłumaczem niemieckiego dla Polaka w pracy. Krótko i praktycznie.")
            Talk.de(firstLine(reply))
        } catch {
            reply = error.localizedDescription
        }
    }

    private func saveLine() {
        guard let pair = savePair(in: reply) else { return }
        _ = store.addWords([Word(de: pair.0, pl: pair.1, ex: pair.0, exPl: pair.1, topic: "Z życia", level: "A2")])
    }
}

private struct CorrectPane: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var mine = ""
    @State private var reply = ""
    @State private var busy = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Wpisz albo powiedz swoje zdanie po niemiecku. Dostaniesz wersję z budowy, poprawną i uprzejmą.")
                    .foregroundStyle(.secondary)
                TextField("Twoje zdanie po niemiecku", text: $mine, axis: .vertical)
                    .lineLimit(2...4)
                    .padding(12)
                    .liquidGlass(radius: 18)
                HStack {
                    Button { mic.toggle() } label: {
                        Label(mic.listening ? "Stop" : "Mów", systemImage: mic.listening ? "stop.fill" : "mic.fill")
                    }
                    .buttonStyle(.glass)
                    Button { Task { await fix() } } label: {
                        if busy { ProgressView() } else { Text("Popraw") }
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Ink.brass)
                    .disabled(busy || mine.trimmingCharacters(in: .whitespaces).count < 2)
                }
                if !mic.note.isEmpty { Text(mic.note).font(.footnote) }
                if !reply.isEmpty {
                    Text(reply).padding(12).liquidGlass(radius: 18)
                    Button("Odtwórz poprawną") { Talk.de(line(reply, prefix: "POPRAWNIE:")) }.buttonStyle(.glass)
                    Button("Zapisz poprawną") { saveFixed() }.buttonStyle(.glass)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: mic.text) { _, new in if !new.isEmpty { mine = new } }
        .onDisappear { mic.stop() }
    }

    private func fix() async {
        busy = true
        mic.stop()
        defer { busy = false }
        let prompt = """
        Uczeń napisał po niemiecku: \(mine)
        Pokaż trzy wersje, bez markdownu:
        PROSTO: jak na budowie albo w magazynie
        POPRAWNIE: zwykły poprawny niemiecki
        UPRZEJMIE: do klienta albo urzędu
        ZAPISZ: wersja POPRAWNIE | tłumaczenie po polsku
        Jedna linia komentarza po polsku, co było nie tak.
        """
        do {
            reply = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Poprawiasz niemiecki Polaka. Krótko.")
        } catch {
            reply = error.localizedDescription
        }
    }

    private func saveFixed() {
        guard let pair = savePair(in: reply) else { return }
        _ = store.addWords([Word(de: pair.0, pl: pair.1, ex: pair.0, exPl: pair.1, topic: "Korekta", level: "A2")])
    }
}

private struct BlocksPane: View {
    @EnvironmentObject var store: LearningStore
    private let blocks: [(label: String, left: String, right: String, sample: String)] = [
        ("Gdzie to jest", "Wo finde ich ", "?", "den Hauptschalter"),
        ("Potrzebuję pomocy", "Ich brauche Hilfe bei ", ".", "der Montage"),
        ("Prośba", "Könnten Sie ", "?", "das wiederholen"),
        ("Awaria", "Das ist seit ", " kaputt.", "gestern"),
        ("Reklamacja", "Ich möchte ", " reklamieren.", "die Ware"),
        ("Spóźnienie", "Ich komme etwa ", " zu spät.", "zwanzig Minuten"),
        ("Pytanie o termin", "Wann kann ich ", "?", "das Auto abholen")
    ]
    @State private var fills: [String: String] = [:]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Nie uczysz się suchego słówka. Wstawiasz swoje słowo w gotowy klocek, którego użyjesz w rozmowie.")
                    .foregroundStyle(.secondary)
                ForEach(blocks, id: \.label) { b in
                    let value = fills[b.label, default: ""]
                    VStack(alignment: .leading, spacing: 8) {
                        Text(b.label).font(.headline)
                        Text(b.left + (value.isEmpty ? "___" : value) + b.right)
                            .font(.title3.bold())
                        TextField(b.sample, text: binding(b.label))
                            .padding(10)
                            .liquidGlass(radius: 14)
                        HStack {
                            Button("Powiedz") {
                                Talk.de(b.left + (value.isEmpty ? b.sample : value) + b.right)
                            }
                            .buttonStyle(.glass)
                            Button("Zapisz") {
                                let phrase = b.left + (value.isEmpty ? b.sample : value) + b.right
                                _ = store.addWords([Word(de: phrase, pl: b.label, ex: phrase, exPl: b.label + ": " + (value.isEmpty ? b.sample : value), topic: "Klocki", level: "A2")])
                            }
                            .buttonStyle(.glass)
                        }
                    }
                    .padding(12)
                    .liquidGlass(radius: 18)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func binding(_ key: String) -> Binding<String> {
        Binding(get: { fills[key, default: ""] }, set: { fills[key] = $0 })
    }
}

private struct ShadowPane: View {
    @StateObject private var mic = Mic()
    @State private var line = "Die Lieferung kommt morgen früh."
    @State private var heard = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Odsłuchaj zdanie i powtórz je. Zielone słowo telefon rozpoznał, czerwone nie. To nie jest ocena akcentu w studio, tylko czy słowa było słychać.")
                    .foregroundStyle(.secondary)
                TextField("Zdanie do powtórzenia", text: $line, axis: .vertical)
                    .lineLimit(2...4)
                    .padding(12)
                    .liquidGlass(radius: 18)
                Button("Odtwórz") { Talk.de(line) }.buttonStyle(.glassProminent).tint(Ink.brass)
                Button(mic.listening ? "Stop" : "Powtórz na głos") { mic.toggle() }
                    .buttonStyle(.glass)
                if !mic.note.isEmpty { Text(mic.note).font(.footnote) }
                if !heard.isEmpty {
                    FlowWords(parts: Heard.parts(target: line, heard: heard))
                    Text("Usłyszane: \(heard)").font(.footnote).foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .onChange(of: mic.text) { _, new in heard = new }
        .onDisappear { mic.stop(); Talk.stop() }
    }
}

private struct FlowWords: View {
    let parts: [(word: String, ok: Bool)]
    var body: some View {
        WrappingWords(parts: parts)
    }
}

private struct WrappingWords: View {
    let parts: [(word: String, ok: Bool)]
    var body: some View {
        Text(parts.map(\.word).joined(separator: " "))
            .font(.title3)
        HStack {
            ForEach(Array(parts.enumerated()), id: \.offset) { _, p in
                Text(p.ok ? "●" : "●")
                    .foregroundStyle(p.ok ? Ink.pine : Ink.clay)
                Text(p.word).foregroundStyle(p.ok ? Ink.pine : Ink.clay)
            }
        }
        .font(.footnote)
    }
}

func jsonSlice(_ text: String) -> String {
    var t = text.replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "")
    if let a = t.firstIndex(of: "["), let b = t.lastIndex(of: "]") { t = String(t[a...b]) }
    return t.trimmingCharacters(in: .whitespacesAndNewlines)
}

func firstLine(_ text: String) -> String {
    line(text, prefix: "NORMALNIE:")
}

func line(_ text: String, prefix: String) -> String {
    let rows = text.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespaces) }
    if let row = rows.first(where: { $0.uppercased().hasPrefix(prefix) }) {
        return row.dropFirst(prefix.count).trimmingCharacters(in: .whitespaces)
    }
    return rows.first(where: { !$0.isEmpty }) ?? text
}

func savePair(in text: String) -> (String, String)? {
    let rows = text.split(separator: "\n").map(String.init)
    guard let row = rows.first(where: { $0.uppercased().contains("ZAPISZ:") }) else { return nil }
    let body = row.replacingOccurrences(of: "ZAPISZ:", with: "", options: .caseInsensitive)
    let bits = body.split(separator: "|", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
    guard let de = bits.first, !de.isEmpty else { return nil }
    let pl = bits.count > 1 ? bits[1] : de
    return (de, pl)
}
