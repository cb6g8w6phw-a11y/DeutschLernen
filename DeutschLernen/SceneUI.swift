import SwiftUI

struct SayLine: Hashable, Identifiable {
    let id: String
    let who: String
    let de: String
    let pl: String
}

struct LineGloss: Hashable, Identifiable {
    var id: String { de }
    let de: String
    let pl: String
}

struct MiniScene: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let level: String
    let situation: String
    let lines: [SayLine]
    let words: [LineGloss]
    let phrases: [String]
    let note: String
    let question: String
    let options: [String]
    let answer: Int
    let replyPL: String
    let replyDE: String
}

enum MiniProgress {
    static func doneIDs() -> Set<String> { Set(UserDefaults.standard.stringArray(forKey: "miniDone") ?? []) }
    static func favIDs() -> Set<String> { Set(UserDefaults.standard.stringArray(forKey: "miniFav") ?? []) }

    static func markDone(_ id: String) {
        var list = UserDefaults.standard.stringArray(forKey: "miniDone") ?? []
        if !list.contains(id) { list.append(id) }
        UserDefaults.standard.set(list, forKey: "miniDone")
        UserDefaults.standard.set(id, forKey: "miniLast")
    }

    static func toggleFav(_ id: String) {
        var list = UserDefaults.standard.stringArray(forKey: "miniFav") ?? []
        if let index = list.firstIndex(of: id) { list.remove(at: index) } else { list.append(id) }
        UserDefaults.standard.set(list, forKey: "miniFav")
    }
}

struct SceneLibraryView: View {
    @State private var category = "Wszystko"
    @State private var level = "Wszystko"
    @State private var onlyFav = false
    @State private var refresh = 0

    private var categories: [String] { ["Wszystko"] + MiniBook.categories }

    private var shown: [MiniScene] {
        MiniBook.all.filter { scene in
            (category == "Wszystko" || scene.category == category) &&
            (level == "Wszystko" || scene.level == level) &&
            (!onlyFav || MiniProgress.favIDs().contains(scene.id))
        }
    }

    var body: some View {
        let _ = refresh
        List {
            Section {
                Text("Ukończone \(MiniProgress.doneIDs().count) z \(MiniBook.all.count). Głos jest z aplikacji, nie z nagrania radiowego.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                if let last = UserDefaults.standard.string(forKey: "miniLast"),
                   let scene = MiniBook.all.first(where: { $0.id == last }) {
                    NavigationLink("Dalej: \(scene.title)") { SceneStudyView(scene: scene) }
                }
            }
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["Wszystko", "A1", "A2", "B1", "B2"], id: \.self) { name in
                            filterChip(name, on: level == name) { level = name }
                        }
                        filterChip(onlyFav ? "Ulubione: tak" : "Ulubione", on: onlyFav) { onlyFav.toggle() }
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { name in
                            filterChip(name, on: category == name) { category = name }
                        }
                    }
                }
            }
            Section("\(shown.count) scenek") {
                ForEach(shown) { scene in
                    NavigationLink {
                        SceneStudyView(scene: scene)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(scene.level).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                                Text(scene.category).font(.caption).foregroundStyle(Theme.text2)
                                if MiniProgress.doneIDs().contains(scene.id) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.ok)
                                }
                            }
                            Text(scene.title).font(.headline)
                            Text(scene.situation).font(.subheadline).foregroundStyle(Theme.text2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Mini dialogi")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear { refresh += 1 }
    }

    private func filterChip(_ name: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(name, action: action)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(on ? Theme.ok : Color.white.opacity(0.08), in: Capsule())
            .foregroundStyle(on ? Theme.ink : .white)
    }
}

struct SceneStudyView: View {
    @EnvironmentObject var store: LearningStore
    let scene: MiniScene
    @State private var picked: Int?
    @State private var typed = ""
    @State private var verdict = ""
    @State private var fav = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(scene.level).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                    Text(scene.category).font(.caption).foregroundStyle(Theme.text2)
                    Spacer()
                    Button(fav ? "W ulubionych" : "Ulubione") {
                        MiniProgress.toggleFav(scene.id)
                        fav.toggle()
                    }
                    .font(.caption.weight(.semibold))
                }
                Text(scene.title).font(.title2.bold())
                Text(scene.situation).foregroundStyle(Theme.text2)
                Button {
                    Talk.de(scene.lines.map(\.de).joined(separator: " "), rate: Speaker.savedPace())
                } label: {
                    Label("Odtwórz cały dialog", systemImage: "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(MatteGlassButton())
                Text("Stuknij słowo. Tłumaczenie wyskoczy w małym okienku. Głos jest z aplikacji.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ForEach(scene.lines) { line in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(line.who).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                            Spacer()
                            Button {
                                Talk.de(line.de, rate: Speaker.savedPace())
                            } label: {
                                Label("Odtwórz", systemImage: "speaker.wave.1.fill")
                                    .font(.caption.weight(.semibold))
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ok)
                        }
                        LineWords(text: line.de, meaning: meaning)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                Text(scene.question).font(.title3.bold())
                ForEach(scene.options.indices, id: \.self) { index in
                    Button(scene.options[index]) {
                        guard picked == nil else { return }
                        picked = index
                        let ok = index == scene.answer
                        store.noteListen(ok: ok)
                        if !ok { HardBook.add(de: scene.lines.map(\.de).joined(separator: " "), pl: scene.situation) }
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.white)
                    .background(fill(index), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                if let picked {
                    Text(picked == scene.answer ? "Dobrze." : "Poprawnie: \(scene.options[scene.answer])")
                        .foregroundStyle(picked == scene.answer ? Theme.ok : Theme.bad)
                }
                Text("Słówka").font(.headline)
                ForEach(scene.words) { word in
                    Text("\(word.de) — \(word.pl)").font(.subheadline)
                }
                Text("Zwroty").font(.headline)
                ForEach(scene.phrases, id: \.self) { phrase in
                    Button {
                        Talk.de(phrase, rate: Speaker.savedPace())
                    } label: {
                        Label(phrase, systemImage: "speaker.wave.1")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.text)
                }
                MerkeBox(text: scene.note)
                Text("Powiedz albo napisz po niemiecku:").font(.headline)
                Text(scene.replyPL)
                TextField("Po niemiecku", text: $typed)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Sprawdź") { checkReply() }.primaryButton().disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
                if !verdict.isEmpty { Text(verdict).foregroundStyle(Theme.text2) }
                Text("Wzorzec: \(scene.replyDE)").font(.footnote).foregroundStyle(Theme.text2)
                Button { Talk.de(scene.replyDE, rate: Speaker.savedPace()) } label: { Label("Posłuchaj wzorca", systemImage: "speaker.wave.2") }
                    .buttonStyle(.glass)
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .navigationTitle("Scenka")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear { fav = MiniProgress.favIDs().contains(scene.id) }
        .onDisappear { Talk.stop() }
    }

    private func meaning(_ token: String) -> String {
        let bare = token.lowercased().filter { $0.isLetter || "äöüß".contains($0) }
        if let hit = scene.words.first(where: { gloss in
            gloss.de.lowercased().split { !($0.isLetter || "äöüß".contains($0)) }.contains { String($0) == bare }
        }) {
            return "\(hit.de) — \(hit.pl)"
        }
        if let known = Self.bits[bare] { return "\(token) — \(known)" }
        return "Nie mam osobnego tłumaczenia dla „\(token)”."
    }

    private static let bits = [
        "ich": "ja", "du": "ty", "er": "on", "sie": "ona, oni albo pan", "es": "to",
        "wir": "my", "ihr": "wy", "mein": "mój", "meine": "moja", "meinen": "mojego",
        "ist": "jest", "sind": "są", "bin": "jestem", "bist": "jesteś",
        "habe": "mam", "hast": "masz", "hat": "ma", "haben": "mamy / mają",
        "der": "rodzajnik męski", "die": "rodzajnik żeński albo liczba mnoga", "das": "rodzajnik nijaki",
        "ein": "jakiś", "eine": "jakaś", "einen": "jakiegoś", "dem": "temu", "den": "tego",
        "und": "i", "oder": "albo", "aber": "ale", "nicht": "nie", "kein": "żaden", "keine": "żadna",
        "wo": "gdzie", "was": "co", "wie": "jak", "wann": "kiedy", "warum": "dlaczego",
        "bitte": "proszę", "danke": "dziękuję", "ja": "tak", "nein": "nie",
        "auf": "na", "mit": "z", "für": "dla", "von": "od", "zu": "do", "nach": "do / po", "bei": "przy",
        "im": "w", "am": "przy", "zum": "do", "zur": "do", "mal": "na chwilę",
        "schon": "już", "noch": "jeszcze", "hier": "tu", "da": "tu / tam", "auch": "też"
    ]

    private func fill(_ index: Int) -> Color {
        guard let picked else { return Color.white.opacity(0.08) }
        if index == scene.answer { return Theme.ok.opacity(0.85) }
        if index == picked { return Theme.bad.opacity(0.85) }
        return Color.white.opacity(0.08)
    }

    private func checkReply() {
        let ok = Normalizer.same(typed, scene.replyDE)
        if ok {
            verdict = "Dobrze. To zdanie wchodzi do rozmowy."
            MiniProgress.markDone(scene.id)
            for word in scene.words.prefix(3) {
                VocabBook.remember(Vocab(de: word.de, pl: word.pl, plural: "", ex: word.de, exPl: word.pl, topic: scene.category, kind: "Ze scenki", note: ""))
            }
            Haptic.good()
        } else {
            verdict = "Jeszcze nie. Wzorzec: \(scene.replyDE). Zostaje do powtórki."
            HardBook.add(de: scene.replyDE, pl: scene.replyPL)
            UserDefaults.standard.set(scene.note, forKey: "freshPattern")
            Haptic.bad()
        }
    }
}

struct LineWords: View {
    let text: String
    let meaning: (String) -> String
    @State private var open: String?

    var body: some View {
        WordFlow(spacing: 5) {
            ForEach(Array(text.split(separator: " ").enumerated()), id: \.offset) { _, part in
                let raw = String(part)
                Button {
                    open = raw
                } label: {
                    Text(raw)
                        .font(.body)
                        .foregroundStyle(.white)
                        .underline(open == raw, color: Theme.ok)
                }
                .buttonStyle(.plain)
                .popover(isPresented: Binding(get: { open == raw }, set: { if !$0 { open = nil } })) {
                    Text(meaning(raw))
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.text)
                        .padding(16)
                        .frame(maxWidth: 260)
                        .presentationCompactAdaptation(.popover)
                }
            }
        }
    }
}

struct WordFlow: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 320
        var x: CGFloat = 0
        var y: CGFloat = 0
        var row: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += row + spacing
                row = 0
            }
            row = max(row, size.height)
            x += size.width + spacing
        }
        return CGSize(width: width, height: y + row)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var row: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += row + spacing
                row = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            row = max(row, size.height)
            x += size.width + spacing
        }
    }
}
