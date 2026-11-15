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
    @State private var bank: [String] = []
    @FocusState private var writing: Bool

    private let scenes: [(title: String, see: String, order: [String], extra: String, sample: String, symbol: String, side: String, third: String)] = [
        ("Budowa", "Kask i łopata. Ułóż, co leży.", ["Eine", "Schaufel", "liegt"], "Helm", "Eine Schaufel liegt.", "helmet", "hammer", "shippingbox"),
        ("Sklep", "Chleb w sklepie. Ułóż, co jest.", ["Es", "gibt", "Brot"], "Kasse", "Es gibt Brot.", "cart", "birthday.cake", "creditcard"),
        ("Ulica", "Autobus i auto. Ułóż, co jedzie.", ["Ein", "Bus", "fährt"], "Auto", "Ein Bus fährt.", "bus", "car", "road.lanes")
    ]

    private var scene: (title: String, see: String, order: [String], extra: String, sample: String, symbol: String, side: String, third: String) { scenes[index % scenes.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(scene.title).font(.largeTitle.bold())
                HStack(spacing: 22) {
                    Image(systemName: scene.symbol)
                    Image(systemName: scene.side)
                    Image(systemName: scene.third)
                }
                .font(.system(size: 42))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .themedCard(radius: 18)
                Text(scene.see).foregroundStyle(.white)
                Text("Ułóż zdanie z podanych słów. Stuknięcie wstawia słowo. Możesz też napisać albo powiedzieć.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                answerLine
                chipRow
                TextField("albo napisz sam", text: $typed, axis: .vertical)
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
                    deal()
                }
                .buttonStyle(.glass)
            }
            .padding(20)
        }
        .navigationTitle("Opisz obrazek")
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .onAppear { if bank.isEmpty { deal() } }
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
        let right = exact(said, scene.order)
        if right {
            note = "Tak. \(scene.sample)"
            fix = ""
            store.noteSkill("sentence", ok: true)
            let word = Word(de: said, pl: scene.title, ex: scene.sample, exPl: scene.see, topic: "Obrazek", level: "A2")
            store.grade(word, .easy, produced: true)
            Talk.de(scene.sample, rate: 0.44)
        } else {
            note = "Jeszcze nie. Bez zbędnego słowa, w tej kolejności: \(scene.sample)"
            store.noteSkill("sentence", ok: false)
            HardBook.add(de: scene.sample, pl: scene.see)
            fix = await polish(said) ?? ""
            Talk.de(scene.sample, rate: 0.44)
        }
    }

    private func exact(_ said: String, _ order: [String]) -> Bool {
        let got = Normalizer.clean(said).split(separator: " ").map(String.init)
        let want = order.map { Normalizer.clean($0) }
        return got == want
    }

    private var answerLine: some View {
        HStack {
            Text(typed.isEmpty ? "Tu ułoży się zdanie" : typed)
                .font(.title3.bold())
                .foregroundStyle(typed.isEmpty ? Theme.text2 : .white)
            Spacer()
            if !typed.isEmpty {
                Button("Cofnij") { undo() }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
        .themedCard(radius: 16)
    }

    private var chipRow: some View {
        HStack(spacing: 8) {
            ForEach(bank, id: \.self) { word in
                Button(word) { place(word) }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
        }
    }

    private func deal() {
        bank = (scene.order + [scene.extra]).shuffled()
    }

    private func place(_ word: String) {
        guard let at = bank.firstIndex(of: word) else { return }
        bank.remove(at: at)
        typed = (typed + " " + word).trimmingCharacters(in: .whitespaces)
    }

    private func undo() {
        let parts = typed.split(separator: " ").map(String.init)
        guard let last = parts.last else { return }
        typed = parts.dropLast().joined(separator: " ")
        if !bank.contains(last) { bank.append(last) }
    }

    private func polish(_ said: String) async -> String? {
        let prompt = """
        Uczeń opisuje obrazek po niemiecku. Obrazek: \(scene.title). Wzorzec: \(scene.sample).
        Napisał: \(said)
        Popraw zdanie po niemiecku, jednym zdaniem. Pod spodem jedna linia po polsku, co było nie tak. Bez ocen procentowych.
        """
        return try? await Gemini.send(messages: [GeminiMessage(role: "user", text: prompt)], system: "Krótka poprawka. Najpierw niemieckie zdanie, potem polski komentarz.")
    }
}
