import SwiftUI

/// Najpierw obrazek, polski i krótkie zdanie. Potem uczeń wpisuje tylko brakujący kawałek.
/// Błąd nie każe przepisywać od razu: pokazuje poprawną formę i zostawia przypomnienie.
struct StudyView: View {
    @EnvironmentObject var store: LearningStore
    @State private var queue: [Word] = []
    @State private var index = 0
    @State private var phase = 0
    @State private var typed = ""
    @State private var verdict = ""
    @State private var wasOK = false
    @State private var produced = 0
    @State private var missed = 0
    @State private var topic = ""
    @State private var picking = true
    @State private var choosing = false
    @State private var pickedTopics: [String] = StudyPicks.load()
    @AppStorage("band") private var band = "A1"
    @FocusState private var writing: Bool

    private var word: Word? { index < queue.count ? queue[index] : nil }
    private var done: Bool { !queue.isEmpty && word == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if picking {
                    picker
                } else if done {
                    Text("Koniec tej serii").font(.largeTitle.bold())
                    Text("Napisane dokładnie: \(produced). Do przypomnienia: \(missed).")
                        .font(.title3)
                    Text("Przypomnienie wraca jutro. Nie musisz przepisywać tego samego od razu.")
                        .foregroundStyle(Theme.text2)
                    Button("Inna kategoria") { picking = true }.primaryButton()
                } else if let word {
                    Text("\(index + 1) z \(queue.count) · \(word.topic)")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                    if phase == 0 {
                        teach(word)
                    } else if phase == 1 {
                        write(word)
                    } else {
                        result(word)
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .navigationTitle("Nauka")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { Talk.stop() }
    }

    private var categories: [String] {
        var seen: [String] = []
        for word in store.catalog(level: band) where !seen.contains(word.topic) {
            seen.append(word.topic)
        }
        return seen
    }

    private var chosen: [String] {
        let known = Set(categories)
        let saved = pickedTopics.filter { known.contains($0) }
        if !saved.isEmpty { return saved }
        let useful = ["Moje", "Praca", "Budowa", "Zdrowie", "Mieszkanie", "Zakupy", "Transport", "Urzędy", "Komunikacja", "Na co dzień"]
        let start = useful.filter { known.contains($0) }
        return start.isEmpty ? Array(categories.prefix(8)) : start
    }

    private var picker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Czego chcesz się uczyć?")
                .font(.title2.bold())
            Text("Wybierasz kategorie. Reszta zostaje schowana.")
                .foregroundStyle(Theme.text2)
            Button("Do przypomnienia") { start(topic: "przypomnienie") }
                .primaryButton()
            Button("Wybierz kategorie") { choosing = true }
                .buttonStyle(.glass)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(chosen, id: \.self) { name in
                    Button(name) { start(topic: name) }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
        .sheet(isPresented: $choosing) {
            CategoryPick(all: categories, picked: $pickedTopics)
        }
        .onChange(of: pickedTopics) { _, next in StudyPicks.save(next) }
    }

    private func teach(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            WordPicture(word: word)
            Text(word.pl)
                .font(.title3.weight(.semibold))
            Text(sentence(word))
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Button { Talk.de(sentence(word), rate: 0.42) } label: {
                Label("Posłuchaj", systemImage: "speaker.wave.2.fill")
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.glass)
            Button("Schowaj i napisz kawałek") {
                typed = ""
                verdict = ""
                phase = 1
                writing = true
            }
            .primaryButton()
        }
    }

    private func write(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            WordPicture(word: word)
            Text("Wpisz tylko lukę. Reszta zdania zostaje.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            Text(word.pl)
                .font(.headline)
            Text(gap(word))
                .font(.title3.bold())
            TextField("Brakujące słowo", text: $typed)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($writing)
            Button("Sprawdź") { check(word) }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Nie pamiętam") { giveUp(word) }
                .ghostButton()
        }
    }

    private func result(_ word: Word) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            WordPicture(word: word)
            Text(wasOK ? "Dobrze. Tak się to pisze." : "Zapisane do przypomnienia.")
                .font(.headline)
                .foregroundStyle(wasOK ? Theme.ok : Theme.orange)
            Text("Tak się pisze:")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Text(piece(word))
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text(sentence(word))
                .foregroundStyle(Theme.text2)
            Text(verdict)
                .foregroundStyle(Theme.text2)
            Button { Talk.de(sentence(word), rate: 0.42) } label: {
                Label("Posłuchaj poprawnego", systemImage: "speaker.wave.2")
            }
            .buttonStyle(.glass)
            Button(index + 1 >= queue.count ? "Zakończ" : "Następne") {
                index += 1
                phase = 0
                typed = ""
                verdict = ""
            }
            .primaryButton()
        }
    }

    private func sentence(_ word: Word) -> String {
        let ex = word.ex.trimmingCharacters(in: .whitespacesAndNewlines)
        let bits = ex.split(separator: " ")
        if bits.count >= 3, ex.compare(word.de, options: .caseInsensitive) != .orderedSame {
            return ex
        }
        if bare(word.de).split(separator: " ").count <= 2 {
            return "Das heißt \(word.de)."
        }
        return word.de
    }

    private func piece(_ word: Word) -> String {
        let full = sentence(word)
        let head = bare(word.de)
        let words = full.split(separator: " ").map(String.init)
        if head.split(separator: " ").count <= 2,
           full.range(of: head, options: .caseInsensitive) != nil,
           head.count < full.count {
            return head
        }
        if words.count <= 3 { return full }
        return words.suffix(2).joined(separator: " ")
    }

    private func gap(_ word: Word) -> String {
        let full = sentence(word)
        let bit = piece(word)
        guard let range = full.range(of: bit, options: .caseInsensitive) else { return "______" }
        let gapped = full.replacingCharacters(in: range, with: "______")
        if gapped.replacingOccurrences(of: "_", with: "").trimmingCharacters(in: .whitespaces).isEmpty {
            return "______"
        }
        return gapped
    }

    private func bare(_ de: String) -> String {
        var token = de.trimmingCharacters(in: .whitespacesAndNewlines)
        for prefix in ["der ", "die ", "das ", "sich "] where token.lowercased().hasPrefix(prefix) {
            token = String(token.dropFirst(prefix.count))
        }
        return token.trimmingCharacters(in: CharacterSet(charactersIn: ".?!"))
    }

    private func check(_ word: Word) {
        let said = typed.trimmingCharacters(in: .whitespacesAndNewlines)
        let bit = piece(word)
        let exact = Normalizer.same(said, bit) || Normalizer.same(said, sentence(word)) || Normalizer.same(said, word.de)
        phase = 2
        writing = false
        if exact {
            wasOK = true
            produced += 1
            verdict = "Ten dzień się liczy. Przypomnienie dopiero za kilka dni."
            store.grade(word, .easy, produced: true)
            Haptic.good()
        } else {
            wasOK = false
            missed += 1
            verdict = "Twoje: \(said). Nie przepisujesz tego teraz. Jutro przypomnę tę formę."
            store.scheduleTomorrow(word)
            HardBook.add(de: sentence(word), pl: word.pl)
            Haptic.bad()
        }
    }

    private func giveUp(_ word: Word) {
        wasOK = false
        missed += 1
        verdict = "Nic nie wpisałeś. Poprawna forma jest wyżej i wróci jutro."
        phase = 2
        writing = false
        store.scheduleTomorrow(word)
        HardBook.add(de: sentence(word), pl: word.pl)
    }

    private func start(topic name: String) {
        topic = name
        let pool = store.catalog(level: band)
        let now = Date()
        let picked: [Word]
        if name == "przypomnienie" {
            picked = pool.filter { word in
                if let stat = store.stats[word.de] { return stat.due <= now }
                return false
            }
        } else {
            picked = pool.filter { $0.topic == name }
        }
        var seen = Set<String>()
        queue = picked.filter { seen.insert($0.de.lowercased()).inserted }.prefix(8).map { $0 }
        if queue.isEmpty { queue = Array(pool.filter { seen.insert($0.de.lowercased()).inserted }.prefix(8)) }
        index = 0
        phase = 0
        produced = 0
        missed = 0
        typed = ""
        verdict = ""
        picking = false
    }
}

private struct WordPicture: View {
    let word: Word

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(LinearGradient(colors: [tint.opacity(0.95), Color(hex: "1B1530")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 150)
            VStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                Text(word.topic)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }

    private var blob: String {
        (word.topic + " " + word.de + " " + word.pl).lowercased()
    }

    private var symbol: String {
        let s = blob
        if s.contains("zeit") || s.contains("czas") || s.contains("pause") || s.contains("uhr") || s.contains("piąt") { return "clock.fill" }
        if s.contains("arzt") || s.contains("krank") || s.contains("zdrow") || s.contains("schmerz") { return "cross.case.fill" }
        if s.contains("essen") || s.contains("jedz") || s.contains("küche") || s.contains("kuchen") { return "fork.knife" }
        if s.contains("bus") || s.contains("zug") || s.contains("bahn") || s.contains("transport") { return "bus.fill" }
        if s.contains("haus") || s.contains("wohn") || s.contains("miesz") || s.contains("schlüssel") { return "house.fill" }
        if s.contains("arbeit") || s.contains("praca") || s.contains("schicht") || s.contains("büro") { return "briefcase.fill" }
        if s.contains("geld") || s.contains("kauf") || s.contains("sklep") || s.contains("preis") { return "cart.fill" }
        if s.contains("amt") || s.contains("urząd") || s.contains("formular") { return "building.columns.fill" }
        if s.contains("wetter") || s.contains("pogod") { return "cloud.sun.fill" }
        if s.contains("magaz") || s.contains("lager") || s.contains("paket") { return "shippingbox.fill" }
        if s.contains("sport") || s.contains("lauf") { return "figure.run" }
        return "sparkles"
    }

    private var tint: Color {
        switch symbol {
        case "clock.fill": return Color(hex: "5AC8FA")
        case "cross.case.fill": return Color(hex: "FF6B9A")
        case "fork.knife": return Color(hex: "FF9A62")
        case "bus.fill": return Color(hex: "8B6CF0")
        case "house.fill": return Color(hex: "34C759")
        case "briefcase.fill": return Color(hex: "5AC8FA")
        case "cart.fill": return Color(hex: "FFD60A")
        default: return Color(hex: "8B6CF0")
        }
    }
}

enum StudyPicks {
    static func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: "studyPicks") ?? []
    }

    static func save(_ names: [String]) {
        UserDefaults.standard.set(names, forKey: "studyPicks")
    }
}

struct CategoryPick: View {
    let all: [String]
    @Binding var picked: [String]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(all, id: \.self) { name in
                Button {
                    if let index = picked.firstIndex(of: name) {
                        picked.remove(at: index)
                    } else {
                        picked.append(name)
                    }
                } label: {
                    HStack {
                        Text(name).foregroundStyle(.primary)
                        Spacer()
                        if picked.contains(name) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Kategorie")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
