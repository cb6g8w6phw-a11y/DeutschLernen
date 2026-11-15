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
    @State private var jump: String?

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
        .scrollContentBackground(.hidden)
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { refresh += 1
            if let id = UserDefaults.standard.string(forKey: "jumpScene") {
                UserDefaults.standard.removeObject(forKey: "jumpScene")
                jump = id
            }
        }
        .navigationDestination(isPresented: Binding(get: { jump != nil }, set: { if !$0 { jump = nil } })) {
            if let jump, let scene = MiniBook.all.first(where: { $0.id == jump }) {
                SceneStudyView(scene: scene)
            }
        }
    }

    private func filterChip(_ name: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(name, action: action)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(on ? Theme.ink : .white)
            .background { if on { Capsule().fill(Theme.ok) } }
            .modifier(IdleGlass(active: !on))
    }
}

private struct IdleGlass: ViewModifier {
    var active: Bool
    func body(content: Content) -> some View {
        if active {
            content
                .glassEffect(.regular, in: Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.22), lineWidth: 1))
        } else {
            content
        }
    }
}

struct SceneStudyView: View {
    @EnvironmentObject var store: LearningStore
    let scene: MiniScene
    @State private var picked: Int?
    @State private var endPick: String?
    @State private var typed = ""
    @State private var verdict = ""
    @State private var fav = false
    @State private var qOK: Bool?
    @State private var whoOK: Bool?
    @State private var started = Date()
    @State private var report: LessonResult?

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
                Text("Poziom \(scene.level). Przewiń w dół: cała rozmowa, tłumaczenie, słówka i ćwiczenie są pod spodem. Nic nie jest obcięte.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Button {
                    GermanVoice.shared.speak(lines: scene.lines.map { DeTurn(speaker: $0.who, text: $0.de) })
                } label: {
                    Label("Odtwórz cały dialog", systemImage: "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(MatteGlassButton())
                LocalPlayBar()
                Text("Stuknij słowo. Tłumaczenie wyskoczy w małym okienku. Głos jest z iPhone’a, nie z AI.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ForEach(scene.lines) { line in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(line.who).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                            Spacer()
                            Button {
                                GermanVoice.shared.speak(lines: [DeTurn(speaker: line.who, text: line.de)])
                            } label: {
                                Label("Odtwórz", systemImage: "speaker.wave.1.fill")
                                    .font(.caption.weight(.semibold))
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ok)
                        }
                        LineWords(text: line.de, meaning: meaning)
                        Text(line.pl)
                            .font(.subheadline)
                            .foregroundStyle(Theme.text2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.white.opacity(0.18), lineWidth: 1))
                }
                Text(scene.question).font(.title3.bold())
                ForEach(scene.options.indices, id: \.self) { index in
                    Button(scene.options[index]) {
                        guard picked == nil else { return }
                        picked = index
                        let ok = index == scene.answer
                        qOK = ok
                        store.noteListen(ok: ok)
                        if !ok { HardBook.add(de: scene.lines.map(\.de).joined(separator: " "), pl: scene.situation) }
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.white)
                    .background {
                        if picked != nil {
                            RoundedRectangle(cornerRadius: 14, style: .continuous).fill(fill(index))
                        }
                    }
                    .modifier(IdleGlassRect(active: picked == nil))
                }
                if let picked {
                    Text(picked == scene.answer ? "Dobrze." : "Poprawnie: \(scene.options[scene.answer])")
                        .foregroundStyle(picked == scene.answer ? Theme.ok : Theme.bad)
                }
                Text("Kto mówi na końcu całej historii?").font(.title3.bold())
                let lastWho = scene.lines.last?.who ?? ""
                let people = Array(Set(scene.lines.map(\.who)))
                ForEach(people, id: \.self) { name in
                    Button(name) {
                        guard endPick == nil else { return }
                        endPick = name
                        whoOK = name == lastWho
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.white)
                    .background {
                        if endPick != nil {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(name == lastWho ? Theme.ok.opacity(0.85) : (endPick == name ? Theme.bad.opacity(0.85) : Color.white.opacity(0.08)))
                        }
                    }
                    .modifier(IdleGlassRect(active: endPick == nil))
                }
                if let endPick {
                    Text(endPick == lastWho ? "Dobrze. Na końcu mówi \(lastWho)." : "Na końcu mówi \(lastWho).")
                        .foregroundStyle(endPick == lastWho ? Theme.ok : Theme.bad)
                }
                Text("Słówka").font(.headline)
                if !savedInScene.isEmpty {
                    Text("Z twojego słownika w tej rozmowie").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ok)
                    ForEach(savedInScene, id: \.de) { card in
                        Text("\(card.de) — \(card.pl)").font(.subheadline)
                    }
                }
                ForEach(scene.words) { word in
                    HStack {
                        Text("\(word.de) — \(word.pl)").font(.subheadline)
                        Spacer()
                        SaveWordButton(de: word.de, pl: word.pl, ex: exampleFor(ProgressBook.lemma(word.de)), exPl: word.pl, topic: scene.category, level: scene.level)
                    }
                }
                Text("Zwroty").font(.headline)
                ForEach(scene.phrases, id: \.self) { phrase in
                    Button {
                        GermanVoice.shared.speak(text: phrase)
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
                Button { GermanVoice.shared.speak(text: scene.replyDE) } label: { Label("Posłuchaj wzorca", systemImage: "speaker.wave.2") }
                    .buttonStyle(.glass)
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .navigationTitle("Scenka")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            fav = MiniProgress.favIDs().contains(scene.id)
            if let id = UserDefaults.standard.string(forKey: "jumpScene"), id == scene.id {
                UserDefaults.standard.removeObject(forKey: "jumpScene")
            }
        }
        .onDisappear { GermanVoice.shared.stop() }
        .sheet(item: $report) { row in
            LessonDoneView(result: row).environmentObject(store)
        }
    }

    private func meaning(_ token: String) -> String {
        let bare = token.lowercased().filter { $0.isLetter || "äöüß".contains($0) }
        if let hit = scene.words.first(where: { gloss in
            gloss.de.lowercased().split { !($0.isLetter || "äöüß".contains($0)) }.contains { String($0) == bare }
        }) {
            let plural = Self.plurals[bare].map { "\nLiczba mnoga: \($0)" } ?? ""
            return "\(hit.de) — \(hit.pl)\(plural)\nPrzykład z tej rozmowy: \(exampleFor(bare))"
        }
        if let verb = Self.verbs[bare] {
            return "\(token) — \(verb.pl)\nBezokolicznik: \(verb.inf)\nOdmiana: \(verb.forms)\nPrzykład: \(verb.ex)"
        }
        if let known = Self.bits[bare] { return "\(token) — \(known)" }
        return "Nie mam osobnego tłumaczenia dla „\(token)”."
    }

    private var savedInScene: [Vocab] {
        let blob = scene.lines.map(\.de).joined(separator: " ").lowercased()
        return VocabBook.custom.filter { blob.contains(ProgressBook.lemma($0.de)) }
    }

    private func exampleFor(_ bare: String) -> String {
        scene.lines.first { $0.de.lowercased().contains(bare) }?.de ?? scene.lines[0].de
    }

    private static let verbs: [String: (pl: String, inf: String, forms: String, ex: String)] = [
        "komme": ("przyjdę", "kommen", "ich komme, du kommst, er kommt, wir kommen", "Ich komme in zehn Minuten."),
        "kommst": ("przychodzisz", "kommen", "ich komme, du kommst, er kommt", "Wann kommst du zur Arbeit?"),
        "kommt": ("przychodzi", "kommen", "ich komme, du kommst, er kommt", "Der Bus kommt in fünf Minuten."),
        "kommen": ("przyjść, przyjechać", "kommen", "ich komme, du kommst, er kommt", "Komm bitte sofort!"),
        "gekommen": ("przyszedł", "kommen", "ich bin gekommen", "Ich bin zu spät gekommen."),
        "gehe": ("idę", "gehen", "ich gehe, du gehst, er geht", "Ich gehe nach Hause."),
        "gehst": ("idziesz", "gehen", "ich gehe, du gehst, er geht", "Gehst du schon?"),
        "geht": ("idzie", "gehen", "ich gehe, du gehst, er geht", "Das geht nicht."),
        "gehen": ("iść", "gehen", "ich gehe, du gehst, er geht", "Ich muss zum Arzt gehen."),
        "mache": ("robię", "machen", "ich mache, du machst, er macht", "Ich mache das jetzt."),
        "machst": ("robisz", "machen", "ich mache, du machst, er macht", "Was machst du da?"),
        "macht": ("robi", "machen", "ich mache, du machst, er macht", "Er macht Pause."),
        "machen": ("robić", "machen", "ich mache, du machst, er macht", "Was muss ich machen?"),
        "habe": ("mam", "haben", "ich habe, du hast, er hat", "Ich habe Kopfschmerzen."),
        "hast": ("masz", "haben", "ich habe, du hast, er hat", "Hast du den Schlüssel?"),
        "hat": ("ma", "haben", "ich habe, du hast, er hat", "Der Zug hat Verspätung."),
        "haben": ("mieć", "haben", "ich habe, du hast, er hat", "Wir haben keine Zeit."),
        "bin": ("jestem", "sein", "ich bin, du bist, er ist", "Ich bin unterwegs."),
        "bist": ("jesteś", "sein", "ich bin, du bist, er ist", "Bist du schon da?"),
        "ist": ("jest", "sein", "ich bin, du bist, er ist", "Die Heizung ist kaputt."),
        "sind": ("jesteśmy, są", "sein", "wir sind, sie sind", "Wir sind auf der Baustelle."),
        "muss": ("muszę", "müssen", "ich muss, du musst, er muss", "Ich muss noch Geld abheben."),
        "musst": ("musisz", "müssen", "ich muss, du musst, er muss", "Du musst den Helm aufsetzen."),
        "kann": ("mogę", "können", "ich kann, du kannst, er kann", "Ich kann später kommen."),
        "kannst": ("możesz", "können", "ich kann, du kannst, er kann", "Kannst du mir bitte helfen?"),
        "will": ("chcę", "wollen", "ich will, du willst, er will", "Ich will früher gehen."),
        "fahre": ("jadę", "fahren", "ich fahre, du fährst, er fährt", "Ich fahre nach Hause."),
        "fährst": ("jedziesz", "fahren", "ich fahre, du fährst, er fährt", "Wie fährst du zur Arbeit?"),
        "fährt": ("jedzie", "fahren", "ich fahre, du fährst, er fährt", "Der Bus fährt gleich."),
        "arbeite": ("pracuję", "arbeiten", "ich arbeite, du arbeitest, er arbeitet", "Ich arbeite heute länger."),
        "arbeitest": ("pracujesz", "arbeiten", "ich arbeite, du arbeitest", "Arbeitest du am Samstag?"),
        "arbeitet": ("pracuje", "arbeiten", "ich arbeite, du arbeitest, er arbeitet", "Er arbeitet auf dem Dach."),
        "hole": ("biorę, przynoszę", "holen", "ich hole, du holst, er holt", "Ich hole die Leiter."),
        "holst": ("bierzesz", "holen", "ich hole, du holst, er holt", "Holst du den Kaffee?"),
        "holt": ("bierze", "holen", "ich hole, du holst, er holt", "Er holt den Schlüssel."),
        "warte": ("czekam", "warten", "ich warte, du wartest, er wartet", "Ich warte am Eingang."),
        "wartet": ("czeka", "warten", "ich warte, du wartest, er wartet", "Der Bus wartet nicht."),
        "frage": ("pytam", "fragen", "ich frage, du fragst, er fragt", "Ich frage den Chef."),
        "fragst": ("pytasz", "fragen", "ich frage, du fragst, er fragt", "Fragst du noch mal nach?"),
        "fragt": ("pyta", "fragen", "ich frage, du fragst, er fragt", "Der Chef fragt nach dir."),
        "bleibe": ("zostaję", "bleiben", "ich bleibe, du bleibst, er bleibt", "Ich bleibe bis sechs."),
        "bleibst": ("zostajesz", "bleiben", "ich bleibe, du bleibst, er bleibt", "Bleibst du länger?"),
        "bleibt": ("zostaje", "bleiben", "ich bleibe, du bleibst, er bleibt", "Das bleibt so."),
        "sage": ("mówię", "sagen", "ich sage, du sagst, er sagt", "Ich sage dem Chef Bescheid."),
        "sagst": ("mówisz", "sagen", "ich sage, du sagst, er sagt", "Sagst du mir Bescheid?"),
        "sagt": ("mówi", "sagen", "ich sage, du sagst, er sagt", "Der Meister sagt Bescheid."),
        "brauche": ("potrzebuję", "brauchen", "ich brauche, du brauchst, er braucht", "Ich brauche den Schlüssel."),
        "brauchst": ("potrzebujesz", "brauchen", "ich brauche, du brauchst", "Was brauchst du dafür?"),
        "braucht": ("potrzebuje", "brauchen", "ich brauche, du brauchst, er braucht", "Er braucht Hilfe.")
    ]

    private static let plurals = [
        "schlüssel": "die Schlüssel", "rechnung": "die Rechnungen", "waschmaschine": "die Waschmaschinen",
        "filter": "die Filter", "musik": "—", "fenster": "die Fenster", "joghurt": "die Joghurts",
        "flasche": "die Flaschen", "brot": "die Brote", "brötchen": "die Brötchen", "tisch": "die Tische",
        "bus": "die Busse", "zug": "die Züge", "karte": "die Karten", "helm": "die Helme",
        "leiter": "die Leitern", "kabel": "die Kabel", "beton": "—", "chef": "die Chefs",
        "palette": "die Paletten", "schraube": "die Schrauben", "wohnung": "die Wohnungen",
        "heizung": "die Heizungen", "miete": "die Mieten", "kaution": "die Kautionen",
        "termin": "die Termine", "rezept": "die Rezepte", "zahn": "die Zähne", "rücken": "die Rücken"
    ]

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
        closeLesson(replyOK: ok)
    }

    private func closeLesson(replyOK: Bool) {
        guard report == nil else { return }
        var correct = 0
        var wrong = 0
        var misses: [String] = []
        if let qOK {
            if qOK { correct += 1 } else { wrong += 1; misses.append("Pytanie o całą historię") }
        }
        if let whoOK {
            if whoOK { correct += 1 } else { wrong += 1; misses.append("Kto mówi na końcu") }
        }
        if replyOK { correct += 1 } else { wrong += 1; misses.append("Odpowiedź bez podpowiedzi") }
        let remembered = replyOK ? min(3, scene.words.count) : 0
        let row = ProgressBook.make(
            kind: "dialog",
            title: scene.title,
            level: scene.level,
            sourceID: scene.id,
            area: scene.category,
            correct: correct,
            wrong: wrong,
            seconds: Int(Date().timeIntervalSince(started)),
            seenWords: scene.words.count,
            remembered: remembered,
            misses: misses,
            streak: store.streak
        )
        ProgressBook.add(row)
        report = row
    }
}

private struct IdleGlassRect: ViewModifier {
    var active: Bool
    func body(content: Content) -> some View {
        if active {
            content
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.white.opacity(0.18), lineWidth: 1))
        } else {
            content
        }
    }
}

struct LineWords: View {
    let text: String
    let meaning: (String) -> String
    @State private var open: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WordFlow(spacing: 4) {
                ForEach(Array(text.split(separator: " ").enumerated()), id: \.offset) { _, part in
                    let raw = String(part)
                    Button {
                        open = open == raw ? nil : raw
                    } label: {
                        Text(raw)
                            .font(.body)
                            .foregroundStyle(.white)
                            .underline(open == raw, color: Theme.ok)
                    }
                    .buttonStyle(.plain)
                }
            }
            if let open {
                VStack(alignment: .leading, spacing: 6) {
                    Text(meaning(open))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text)
                        .fixedSize(horizontal: false, vertical: true)
                    Button {
                        GermanVoice.shared.speak(text: String(open.filter { $0.isLetter || "äöüÄÖÜß ".contains($0) }))
                    } label: {
                        Label("Posłuchaj tego słowa", systemImage: "speaker.wave.2.fill")
                            .font(.caption.weight(.semibold))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.ok)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.ok.opacity(0.55), lineWidth: 1))
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
