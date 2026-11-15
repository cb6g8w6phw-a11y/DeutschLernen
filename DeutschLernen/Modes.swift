import SwiftUI

struct ThinkItem {
    let title: String
    let prompt: String
    let audio: String
    let words: [String]
    let extras: [String]
    let meaning: String
}

struct ThinkView: View {
    @EnvironmentObject var store: LearningStore
    @State private var index = 0
    @State private var bank: [String] = []
    @State private var picked: [String] = []
    @State private var streak = 0
    @State private var done = false
    @State private var ok = false

    private let items: [ThinkItem] = [
        ThinkItem(title: "Stuknij to, co słyszysz", prompt: "Bez polskiego. Najpierw ucho.", audio: "Wie viel kostet die Wurst?", words: ["Wie", "viel", "kostet", "die", "Wurst"], extras: ["Hund", "hier", "Kaffee"], meaning: "Ile kosztuje kiełbasa?"),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Der Chef sagt: Hol bitte die Schaufel.", audio: "Hol bitte die Schaufel.", words: ["Ich", "hole", "sie", "sofort"], extras: ["morgen", "Arzt", "nicht"], meaning: "Zaraz ją przyniosę."),
        ThinkItem(title: "Stuknij to, co słyszysz", prompt: "Bez polskiego. Najpierw ucho.", audio: "Drei Kilo Tomaten, bitte.", words: ["Drei", "Kilo", "Tomaten", "bitte"], extras: ["Kaffee", "fünf", "hallo"], meaning: "Trzy kilo pomidorów, poproszę."),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Der Kollege fragt: Wann kommst du?", audio: "Wann kommst du?", words: ["Ich", "komme", "um", "sechs"], extras: ["gestern", "Schaufel", "warum"], meaning: "Przyjdę o szóstej."),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Jemand spricht zu schnell.", audio: "Können Sie das wiederholen?", words: ["Können", "Sie", "das", "bitte", "wiederholen"], extras: ["langsam", "heute", "Bus"], meaning: "Czy może Pan to powtórzyć?")
    ]

    private var item: ThinkItem { items[index % items.count] }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(streak) z rzędu")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.ok)
                ProgressView(value: Double(index % items.count), total: Double(items.count))
                    .tint(Theme.ok)
                Text("\(index % items.count + 1)/\(items.count)")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
            }
            Text(item.title).font(.title2.bold())
            Text(item.prompt).foregroundStyle(Theme.text2)
            Button { Talk.de(item.audio, rate: 0.46) } label: {
                Label("Odtwórz", systemImage: "speaker.wave.2.fill")
                    .frame(maxWidth: .infinity, minHeight: 64)
            }
            .buttonStyle(.glass)
            answerRow
            chipRow
            Spacer()
        }
        .padding(20)
        .safeAreaInset(edge: .bottom) {
            if done {
                VStack(alignment: .leading, spacing: 8) {
                    Text(ok ? "Dobrze." : "Jeszcze nie ta kolejność.")
                        .font(.headline)
                    Text("Po polsku, dopiero teraz: \(item.meaning)")
                        .foregroundStyle(Theme.text2)
                    Button("Dalej") { advance() }.primaryButton()
                }
                .padding(16)
                .background(ok ? Theme.ok.opacity(0.25) : Theme.bad.opacity(0.25))
            }
        }
        .navigationTitle("Myślenie po niemiecku")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { lay() }
        .onDisappear { Talk.stop() }
    }

    private var answerRow: some View {
        HStack(spacing: 8) {
            if picked.isEmpty {
                Text("Tu ułóż odpowiedź")
                    .foregroundStyle(Theme.text2)
            }
            ForEach(picked.indices, id: \.self) { i in
                Button(picked[i]) { bank.append(picked.remove(at: i)) }
                    .buttonStyle(.glass)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
    }

    private var chipRow: some View {
        FlowChips(words: bank) { word in
            guard !done, let at = bank.firstIndex(of: word) else { return }
            picked.append(bank.remove(at: at))
            if picked.count == item.words.count { judge() }
        }
    }

    private func lay() {
        bank = (item.words + item.extras).shuffled()
        picked = []
        done = false
        ok = false
    }

    private func judge() {
        ok = picked == item.words
        done = true
        if ok {
            streak += 1
            store.noteSkill("sentence", ok: true)
            Haptic.good()
        } else {
            streak = 0
            store.noteSkill("sentence", ok: false)
            HardBook.add(de: item.words.joined(separator: " "), pl: item.meaning)
            Haptic.bad()
        }
    }

    private func advance() {
        index += 1
        lay()
        Talk.de(item.audio, rate: 0.46)
    }
}

struct FlowChips: View {
    let words: [String]
    let tap: (String) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 8)], spacing: 8) {
            ForEach(words.indices, id: \.self) { i in
                Button(words[i]) { tap(words[i]) }
                    .buttonStyle(.glass)
            }
        }
    }
}

struct PictureTalk: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var index = 0
    @State private var typed = ""
    @State private var note = ""
    @State private var fix = ""
    @State private var busy = false
    @FocusState private var writing: Bool

    private let scenes: [(title: String, see: String, need: [String], sample: String, symbol: String, extra: String, side: String)] = [
        ("Budowa", "Kask, łopata i bus. Opowiedz po niemiecku, co widzisz.", ["Schaufel", "Baustelle"], "Auf der Baustelle liegt eine Schaufel.", "helmet", "hammer", "bus"),
        ("Sklep", "Chleb i kasa. Powiedz, co jest w sklepie.", ["Brot", "Kasse"], "Im Laden gibt es Brot an der Kasse.", "cart", "birthday.cake", "creditcard"),
        ("Ulica", "Autobus i ulica. Powiedz, co jedzie.", ["Bus", "Straße"], "Der Bus fährt auf der Straße.", "bus", "car", "trafficlight")
    ]

    private var scene: (title: String, see: String, need: [String], sample: String, symbol: String, extra: String, side: String) { scenes[index % scenes.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(scene.title).font(.largeTitle.bold())
                HStack(spacing: 22) {
                    Image(systemName: scene.symbol)
                    Image(systemName: scene.extra)
                    Image(systemName: scene.side)
                }
                .font(.system(size: 42))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .themedCard(radius: 18)
                Text(scene.see).foregroundStyle(.white)
                Text("Napisz albo powiedz całe zdanie. Polskiego tłumaczenia nie ma, dopóki nie sprawdzisz.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                TextField("Po niemiecku", text: $typed, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($writing)
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powiedz, co widzisz", systemImage: "mic.fill")
                }
                .buttonStyle(MatteGlassButton())
                if mic.listening { Text(mic.text.isEmpty ? "Słucham…" : mic.text) }
                Button("Sprawdź") { Task { await check() } }
                    .primaryButton()
                    .disabled(busy || typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                if !note.isEmpty { Text(note).font(.headline) }
                if !fix.isEmpty { Text(fix).foregroundStyle(Theme.text2) }
                Button(index + 1 >= scenes.count ? "Od początku" : "Następny obrazek") {
                    index = index + 1 >= scenes.count ? 0 : index + 1
                    typed = ""
                    note = ""
                    fix = ""
                }
                .buttonStyle(.glass)
            }
            .padding(20)
        }
        .navigationTitle("Opisz obrazek")
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: mic.listening) { was, now in
            guard was, !now else { return }
            let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !heard.isEmpty { typed = heard }
        }
        .onDisappear { mic.stop(); Talk.stop() }
    }

    private func check() async {
        writing = false
        busy = true
        defer { busy = false }
        let said = typed.trimmingCharacters(in: .whitespacesAndNewlines)
        let clean = Normalizer.clean(said)
        let hit = scene.need.filter { clean.contains(Normalizer.clean($0)) }
        let missed = scene.need.filter { !clean.contains(Normalizer.clean($0)) }
        if missed.isEmpty {
            note = "Są słowa z obrazka: \(hit.joined(separator: ", "))."
            store.noteSkill("sentence", ok: true)
            let word = Word(de: said, pl: scene.title, ex: scene.sample, exPl: scene.see, topic: "Obrazek", level: "A2")
            store.grade(word, .easy, produced: true)
        } else {
            note = "Brakuje na obrazku: \(missed.joined(separator: ", "))."
            store.noteSkill("sentence", ok: false)
            HardBook.add(de: scene.sample, pl: scene.see)
        }
        fix = await polish(said) ?? "Wzorzec z tych samych rzeczy: \(scene.sample)"
        if let line = fix.split(separator: "\n").first.map(String.init), line.contains(" ") {
            Talk.de(scene.sample, rate: 0.44)
        }
    }

    private func polish(_ said: String) async -> String? {
        let prompt = """
        Uczeń opisuje obrazek po niemiecku. Obrazek: \(scene.title). Powinien użyć: \(scene.need.joined(separator: ", ")).
        Napisał: \(said)
        Popraw zdanie po niemiecku, jednym zdaniem. Pod spodem jedna linia po polsku, co było nie tak. Bez ocen procentowych.
        """
        return try? await Gemini.send(messages: [GeminiMessage(role: "user", text: prompt)], system: "Krótka poprawka. Najpierw niemieckie zdanie, potem polski komentarz.")
    }
}
