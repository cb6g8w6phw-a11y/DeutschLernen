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
        ThinkItem(title: "Stuknij to, co słyszysz", prompt: "Bez polskiego. Najpierw ucho.", audio: "Wie viel kostet die Wurst?", words: ["Wie", "viel", "kostet", "die", "Wurst"], extras: ["Kaffee", "Wurst", "Euro"], meaning: "Ile kosztuje kiełbasa?"),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Der Chef sagt: Hol bitte die Schaufel.", audio: "Hol bitte die Schaufel.", words: ["Ich", "hole", "sie", "sofort"], extras: ["später", "gleich", "morgen"], meaning: "Zaraz ją przyniosę."),
        ThinkItem(title: "Stuknij to, co słyszysz", prompt: "Bez polskiego. Najpierw ucho.", audio: "Drei Kilo Tomaten, bitte.", words: ["Drei", "Kilo", "Tomaten", "bitte"], extras: ["Äpfel", "zwei", "Kilo"], meaning: "Trzy kilo pomidorów, poproszę."),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Der Kollege fragt: Wann kommst du?", audio: "Wann kommst du?", words: ["Ich", "komme", "um", "sechs"], extras: ["sieben", "acht", "halb"], meaning: "Przyjdę o szóstej."),
        ThinkItem(title: "Odpowiedz po niemiecku", prompt: "Jemand spricht zu schnell.", audio: "Die Lieferung kommt erst um zehn, nicht um neun.", words: ["Können", "Sie", "bitte", "langsamer", "sprechen"], extras: ["schneller", "nochmal", "laut"], meaning: "Czy może Pan mówić wolniej?")
    ]

    private var item: ThinkItem { items[index % items.count] }

    private var answer: String {
        let base = item.words.joined(separator: " ")
        if item.meaning.hasSuffix("?") { return base + "?" }
        return base + "."
    }

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
            Button { Talk.de(item.audio, rate: item.prompt.contains("schnell") ? 0.62 : 0.46) } label: {
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
                    Text(ok ? "Dobrze." : "Jeszcze nie.")
                        .font(.headline)
                    Text(answer)
                        .font(.title3.bold())
                    Text(item.meaning)
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
        Talk.de(item.audio, rate: item.prompt.contains("schnell") ? 0.62 : 0.46)
    }
}

struct FlowChips: View {
    let words: [String]
    let tap: (String) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
            ForEach(words.indices, id: \.self) { i in
                Button(words[i]) { tap(words[i]) }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.08), in: Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
}

private struct TalkPic: Identifiable {
    let id: String
    let level: String
    let title: String
    let see: String
    let order: [String]
    let extra: String
    let sample: String
    let icons: [String]
}

struct PictureTalk: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("band") private var band = "A1"
    @StateObject private var mic = Mic()
    @State private var deck: [TalkPic] = []
    @State private var index = 0
    @State private var typed = ""
    @State private var built = ""
    @State private var note = ""
    @State private var fix = ""
    @State private var busy = false
    @State private var bank: [String] = []
    @FocusState private var writing: Bool

    private static let scenes: [TalkPic] = [
        TalkPic(id: "kawa", level: "A1", title: "Kuchnia", see: "Rano. Kawa stoi na stole w kuchni. Powiedz, co robisz.", order: ["Ich", "trinke", "Kaffee", "in", "der", "Küche"], extra: "Tee", sample: "Ich trinke Kaffee in der Küche.", icons: ["cup.and.saucer", "sunrise", "house"]),
        TalkPic(id: "bus", level: "A1", title: "Przystanek", see: "Stoisz na przystanku i patrzysz na zegarek.", order: ["Der", "Bus", "kommt", "in", "fünf", "Minuten"], extra: "Zug", sample: "Der Bus kommt in fünf Minuten.", icons: ["bus", "clock", "mappin"]),
        TalkPic(id: "sklep", level: "A1", title: "Sklep", see: "Przy kasie masz chleb i mleko.", order: ["Ich", "kaufe", "Brot", "und", "Milch"], extra: "Käse", sample: "Ich kaufe Brot und Milch.", icons: ["cart", "birthday.cake", "creditcard"]),
        TalkPic(id: "klucz", level: "A1", title: "Wychodzę", see: "Zamykasz mieszkanie. Klucz jeszcze leży.", order: ["Der", "Schlüssel", "liegt", "auf", "dem", "Tisch"], extra: "Regal", sample: "Der Schlüssel liegt auf dem Tisch.", icons: ["key.fill", "door.left.hand.closed", "house"]),
        TalkPic(id: "deszcz", level: "A1", title: "Za oknem", see: "Patrzysz w okno przed wyjściem do pracy.", order: ["Heute", "regnet", "es", "stark"], extra: "Schnee", sample: "Heute regnet es stark.", icons: ["cloud.rain", "umbrella", "window.casement"]),
        TalkPic(id: "pauza", level: "A1", title: "Przerwa", see: "Koledzy siadają. Mówisz, że jest przerwa.", order: ["Wir", "machen", "jetzt", "Pause"], extra: "Feierabend", sample: "Wir machen jetzt Pause.", icons: ["cup.and.saucer", "person.2", "clock"]),
        TalkPic(id: "szef", level: "A1", title: "Telefon", see: "Dzwonisz, bo szef czeka na odpowiedź.", order: ["Ich", "rufe", "meinen", "Chef", "an"], extra: "Kollegen", sample: "Ich rufe meinen Chef an.", icons: ["phone", "person.crop.circle", "building.2"]),
        TalkPic(id: "apteka", level: "A1", title: "Apteka", see: "Boli cię głowa po zmianie. Stoisz przy ladzie.", order: ["Ich", "habe", "Kopfschmerzen"], extra: "Husten", sample: "Ich habe Kopfschmerzen.", icons: ["cross.case", "pills", "person"]),
        TalkPic(id: "obiad", level: "A1", title: "Stołówka", see: "Kucharz pyta, co podać.", order: ["Ich", "möchte", "eine", "Suppe", "bitte"], extra: "Salat", sample: "Ich möchte eine Suppe bitte.", icons: ["fork.knife", "cup.and.saucer", "person"]),
        TalkPic(id: "dom", level: "A1", title: "Po zmianie", see: "Koniec pracy. Jedziesz do domu.", order: ["Ich", "fahre", "nach", "Hause"], extra: "Arbeit", sample: "Ich fahre nach Hause.", icons: ["car", "house", "moon"]),
        TalkPic(id: "helm", level: "A2", title: "Wejście na plac", see: "Zanim wejdziesz, zakładasz kask. Jedno zdanie, nie lista rzeczy.", order: ["Ich", "setze", "den", "Helm", "auf"], extra: "Weste", sample: "Ich setze den Helm auf.", icons: ["helmet", "figure.walk", "hammer"]),
        TalkPic(id: "grzanie", level: "A2", title: "Mieszkanie", see: "Wracasz i w pokoju jest zimno.", order: ["Die", "Heizung", "ist", "kaputt"], extra: "Fenster", sample: "Die Heizung ist kaputt.", icons: ["thermometer.snowflake", "house", "wrench.and.screwdriver"]),
        TalkPic(id: "sasiad", level: "A2", title: "Klatka", see: "Sąsiad stoi z szafą na klatce. Prosisz go o chwilę pomocy.", order: ["Kannst", "du", "mir", "bitte", "helfen"], extra: "warten", sample: "Kannst du mir bitte helfen?", icons: ["person.2", "door.left.hand.open", "hand.raised"]),
        TalkPic(id: "zug", level: "A2", title: "Dworzec", see: "Tablica świeci na czerwono. Pociąg się spóźnia.", order: ["Der", "Zug", "hat", "Verspätung"], extra: "Gleis", sample: "Der Zug hat Verspätung.", icons: ["tram", "clock", "signpost.right"]),
        TalkPic(id: "leiter", level: "A2", title: "Majster", see: "Majster woła z dołu, żebyś przyniósł drabinę.", order: ["Ich", "hole", "die", "Leiter"], extra: "Hammer", sample: "Ich hole die Leiter.", icons: ["ladder", "arrow.down", "person.wave.2"]),
        TalkPic(id: "geld", level: "A2", title: "Bank", see: "Po pracy stoisz przed bankomatem.", order: ["Ich", "muss", "noch", "Geld", "abheben"], extra: "Konto", sample: "Ich muss noch Geld abheben.", icons: ["banknote", "creditcard", "building.columns"]),
        TalkPic(id: "pranie", level: "A2", title: "Łazienka", see: "Pralka jeszcze chodzi, a ty już chcesz wyjść.", order: ["Die", "Waschmaschine", "läuft", "noch"], extra: "Seife", sample: "Die Waschmaschine läuft noch.", icons: ["washer", "tshirt", "clock"]),
        TalkPic(id: "spotkanie", level: "A2", title: "Przed domem", see: "Umawiacie się pod blokiem po robocie.", order: ["Wir", "treffen", "uns", "um", "sechs"], extra: "sieben", sample: "Wir treffen uns um sechs.", icons: ["person.2", "clock", "house"]),
        TalkPic(id: "liste", level: "A2", title: "Lista", see: "W ręce masz kartkę: chleb, mleko, ser.", order: ["Ich", "brauche", "noch", "Brot", "und", "Käse"], extra: "Wasser", sample: "Ich brauche noch Brot und Käse.", icons: ["list.bullet", "cart", "basket"]),
        TalkPic(id: "dostawa", level: "B1", title: "Dostawa", see: "Zostajesz dłużej, bo towar przyjedzie później. Powiedz dlaczego.", order: ["Ich", "bleibe", "länger", "weil", "die", "Lieferung", "später", "kommt"], extra: "Rampe", sample: "Ich bleibe länger, weil die Lieferung später kommt.", icons: ["shippingbox", "clock", "person"]),
        TalkPic(id: "bahn", level: "B1", title: "Plan B", see: "Autobus nie jedzie. Mówisz, co wtedy robisz.", order: ["Wenn", "der", "Bus", "nicht", "kommt", "nehme", "ich", "die", "Bahn"], extra: "Taxi", sample: "Wenn der Bus nicht kommt, nehme ich die Bahn.", icons: ["bus", "tram", "arrow.triangle.branch"]),
        TalkPic(id: "frueher", level: "B1", title: "Wcześniej", see: "Pytasz, czy możesz dziś zejść wcześniej.", order: ["Darf", "ich", "heute", "früher", "gehen"], extra: "Schicht", sample: "Darf ich heute früher gehen?", icons: ["clock", "house", "person.crop.circle"])
    ]

    private var scene: TalkPic { deck.isEmpty ? Self.scenes[0] : deck[index % deck.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(scene.level)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.ink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.ok, in: Capsule())
                    Text("\(index + 1) z \(max(deck.count, 1))")
                        .font(.caption)
                        .foregroundStyle(Theme.text2)
                    Spacer()
                    Text(scene.title).font(.headline)
                }
                HStack(spacing: 22) {
                    ForEach(scene.icons, id: \.self) { name in
                        Image(systemName: name)
                    }
                }
                .font(.system(size: 42))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .themedCard(radius: 18)
                Text(scene.see).foregroundStyle(.white)
                Text("Ułóż całe zdanie, tak jak byś to powiedział. Kafelki mają się połączyć w jedno zdanie.")
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
                    .disabled(busy || (typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && built.isEmpty))
                if !note.isEmpty { Text(note).font(.headline) }
                if !fix.isEmpty { Text(fix).foregroundStyle(Theme.text2) }
                Button(index + 1 >= deck.count ? "Od początku" : "Następny obrazek") {
                    guard !deck.isEmpty else { return }
                    index = index + 1 >= deck.count ? 0 : index + 1
                    typed = ""
                    built = ""
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
        .onAppear { loadDeck(force: deck.isEmpty) }
        .onChange(of: band) { _, _ in loadDeck(force: true) }
        .onChange(of: mic.listening) { was, now in
            guard was, !now else { return }
            let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !heard.isEmpty { typed = heard }
        }
        .onDisappear { mic.stop(); Talk.stop() }
    }

    private func loadDeck(force: Bool) {
        guard force || deck.isEmpty else { return }
        let rank = Self.rank(band)
        let pool = Self.scenes.filter { Self.rank($0.level) <= rank }
        deck = (pool.isEmpty ? Self.scenes : pool).shuffled()
        index = 0
        typed = ""
        built = ""
        note = ""
        fix = ""
        deal()
    }

    private static func rank(_ name: String) -> Int {
        let t = name.lowercased()
        if t.contains("b2") { return 4 }
        if t.contains("b1") { return 3 }
        if t.contains("a2") || t.contains("oba") { return 2 }
        return 1
    }

    private func check() async {
        writing = false
        busy = true
        defer { busy = false }
        let written = typed.trimmingCharacters(in: .whitespacesAndNewlines)
        let said = written.isEmpty ? built.trimmingCharacters(in: .whitespacesAndNewlines) : written
        let verdict = AnswerCheck.judge(said, scene.sample)
        let right = verdict == .exact || exact(said, scene.order)
        let typo = !right && verdict == .typo
        if right || typo {
            note = typo ? AnswerCheck.almost(scene.sample) : "Tak. \(scene.sample)"
            fix = ""
            let word = Word(de: scene.sample, pl: scene.title, ex: scene.sample, exPl: scene.see, topic: "Obrazek", level: "A2")
            store.grade(word, typo ? .mid : .easy, produced: true)
            Talk.de(scene.sample, rate: 0.44)
        } else {
            note = AnswerCheck.miss(scene.sample)
            store.noteSkill("sentence", ok: false)
            HardBook.add(de: scene.sample, pl: scene.see)
            fix = await polish(said) ?? ""
            Talk.de(scene.sample, rate: 0.44)
        }
    }

    private func exact(_ said: String, _ order: [String]) -> Bool {
        let got = fold(said)
        let want = order.flatMap { fold($0) }
        return got == want || got == fold(scene.sample)
    }

    private func fold(_ s: String) -> [String] {
        var t = s.lowercased()
        t = t.replacingOccurrences(of: "ä", with: "ae")
            .replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue")
            .replacingOccurrences(of: "ß", with: "ss")
        let letters = t.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) || $0 == " " }
        return String(String.UnicodeScalarView(letters)).split(separator: " ").map(String.init)
    }

    private var answerLine: some View {
        HStack {
            Text(built.isEmpty ? "Tu ułoży się zdanie" : built)
                .font(.title3.bold())
                .foregroundStyle(built.isEmpty ? Theme.text2 : .white)
            Spacer()
            if !built.isEmpty {
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 8)], spacing: 8) {
            ForEach(bank, id: \.self) { word in
                Button(word) { place(word) }
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
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
        built = (built + " " + word).trimmingCharacters(in: .whitespaces)
    }

    private func undo() {
        let parts = built.split(separator: " ").map(String.init)
        guard let last = parts.last else { return }
        built = parts.dropLast().joined(separator: " ")
        if !bank.contains(last) { bank.append(last) }
    }

    private func polish(_ said: String) async -> String? {
        let prompt = """
        Uczeń opisuje obrazek po niemiecku. Obrazek: \(scene.title). Wzorzec: \(scene.sample).
        Napisał: \(said)
        Popraw zdanie po niemiecku, jednym zdaniem. Pod spodem jedna linia po polsku, co było nie tak. Kropka i przecinek nie są błędem. Bez ocen procentowych.
        """
        return try? await Gemini.send(messages: [GeminiMessage(role: "user", text: prompt)], system: "Krótka poprawka. Najpierw niemieckie zdanie, potem polski komentarz.")
    }
}
