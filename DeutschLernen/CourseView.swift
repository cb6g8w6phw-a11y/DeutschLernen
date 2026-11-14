import SwiftUI

private struct Beat {
    var pl: String
    var de: String
}

private struct CourseLesson: Identifiable {
    var id: String
    var title: String
    var explain: String
    var again: String
    var words: [Beat]
    var examples: [Beat]
    var help: Beat
    var solo: Beat
    var listenDe: String
    var listenPl: String
    var question: String
    var options: [String]
    var answer: Int
    var check: Beat
    var canSay: String
}

private enum CourseBank {
    static let all: [CourseLesson] = [
        CourseLesson(
            id: "jestem", title: "Jestem i nazywam się",
            explain: "„Jestem” to ich bin, nie ich habe. Imię: ich heiße. Skąd jesteś: ich komme aus. Czasownik stoi na drugim miejscu.",
            again: "Nie mów ich habe Kacper. Imię to ich heiße. Skąd to ich komme aus Polen.",
            words: [Beat(pl: "jestem", de: "ich bin"), Beat(pl: "nazywam się", de: "ich heiße"), Beat(pl: "pochodzę z", de: "ich komme aus"), Beat(pl: "Polska", de: "Polen"), Beat(pl: "tu pracuję", de: "ich arbeite hier")],
            examples: [Beat(pl: "Jestem Kacper i pochodzę z Polski.", de: "Ich bin Kacper und ich komme aus Polen."), Beat(pl: "Nazywam się Kacper. Pracuję tutaj.", de: "Ich heiße Kacper. Ich arbeite hier.")],
            help: Beat(pl: "Nazywam się Kacper.", de: "Ich heiße Kacper."),
            solo: Beat(pl: "Pochodzę z Polski.", de: "Ich komme aus Polen."),
            listenDe: "Wer bist du? Ich heiße Kacper und ich komme aus Polen.",
            listenPl: "Szef pyta, kim jesteś. Podajesz imię i że jesteś z Polski.",
            question: "Skąd jesteś?", options: ["Z Polski", "Z Berlina", "Z urzędu"], answer: 0,
            check: Beat(pl: "Nazywam się Kacper i pochodzę z Polski.", de: "Ich heiße Kacper und ich komme aus Polen."),
            canSay: "Potrafisz się przedstawić: imię i skąd jesteś."
        ),
        CourseLesson(
            id: "czas", title: "Godzina i przerwa",
            explain: "Godzinę mówisz z um: um neun to o dziewiątej. die Pause to przerwa. Zwanzig Minuten to dwadzieścia minut.",
            again: "Najpierw Ich komme albo Die Pause ist, potem um neun. Nie zaczynaj od godziny.",
            words: [Beat(pl: "o dziewiątej", de: "um neun"), Beat(pl: "przerwa", de: "die Pause"), Beat(pl: "dwadzieścia minut", de: "zwanzig Minuten"), Beat(pl: "dziś", de: "heute"), Beat(pl: "zaczynam", de: "ich fange an")],
            examples: [Beat(pl: "Przerwa jest o dziewiątej.", de: "Die Pause ist um neun."), Beat(pl: "Przyjdę za dwadzieścia minut.", de: "Ich bin in zwanzig Minuten da.")],
            help: Beat(pl: "Przerwa jest o dziewiątej.", de: "Die Pause ist um neun."),
            solo: Beat(pl: "Będę za dwadzieścia minut.", de: "Ich bin in zwanzig Minuten da."),
            listenDe: "Wann ist die Pause? Die Pause ist um neun, zwanzig Minuten.",
            listenPl: "Pytają o przerwę. O dziewiątej, dwadzieścia minut.",
            question: "Kiedy jest przerwa?", options: ["O dziewiątej", "O szóstej", "W południe"], answer: 0,
            check: Beat(pl: "Przerwa jest o dziewiątej.", de: "Die Pause ist um neun."),
            canSay: "Potrafisz podać godzinę przerwy."
        ),
        CourseLesson(
            id: "spoznienie", title: "Spóźnienie na zmianę",
            explain: "Poranna zmiana to die Frühschicht. Autobus się spóźnił: Der Bus hat Verspätung. Potem mówisz, za ile będziesz.",
            again: "hat Verspätung znaczy „ma opóźnienie”. Nie ich bin Verspätung. Najpierw przyczyna, potem czas.",
            words: [Beat(pl: "poranna zmiana", de: "die Frühschicht"), Beat(pl: "autobus", de: "der Bus"), Beat(pl: "ma opóźnienie", de: "hat Verspätung"), Beat(pl: "przepraszam", de: "Entschuldigung"), Beat(pl: "będę", de: "ich bin da")],
            examples: [Beat(pl: "Autobus się spóźnił. Będę za dwadzieścia minut.", de: "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.")],
            help: Beat(pl: "Autobus się spóźnił.", de: "Der Bus hat Verspätung."),
            solo: Beat(pl: "Przepraszam, będę za dwadzieścia minut.", de: "Entschuldigung, ich bin in zwanzig Minuten da."),
            listenDe: "Kommst du heute zur Frühschicht? Der Bus hat Verspätung. Ich bin in zwanzig Minuten da. Fang dann an der Rampe an.",
            listenPl: "Pytają o poranną. Autobus ma opóźnienie. Za dwadzieścia minut zaczynasz przy rampie.",
            question: "Co zrobisz po przyjeździe?", options: ["Zacznę przy rampie", "Idę do lekarza", "Kończę zmianę"], answer: 0,
            check: Beat(pl: "Autobus ma opóźnienie. Będę za dwadzieścia minut.", de: "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da."),
            canSay: "Potrafisz usprawiedliwić spóźnienie i podać czas."
        ),
        CourseLesson(
            id: "rodzaj", title: "der, die, das",
            explain: "Rzeczownik bierz razem z rodzajnikiem. der Bus, die Pause, das Formular. Samo słowo bez rodzajnika jest niedokończone.",
            again: "Nie tłumacz rodzaju z polskiego. der Bus, die Pause, das Formular. Rodzajnik jest częścią słowa.",
            words: [Beat(pl: "autobus", de: "der Bus"), Beat(pl: "przerwa", de: "die Pause"), Beat(pl: "formularz", de: "das Formular"), Beat(pl: "szef", de: "der Chef"), Beat(pl: "zmiana", de: "die Schicht")],
            examples: [Beat(pl: "Wypełniam formularz.", de: "Ich fülle das Formular aus."), Beat(pl: "Autobus ma opóźnienie.", de: "Der Bus hat Verspätung.")],
            help: Beat(pl: "Przerwa jest o dziewiątej.", de: "Die Pause ist um neun."),
            solo: Beat(pl: "Wypełniam formularz.", de: "Ich fülle das Formular aus."),
            listenDe: "Haben Sie das Formular? Ja. Ich fülle das Formular aus.",
            listenPl: "W urzędzie pytają o formularz. Mówisz, że go wypełniasz.",
            question: "Jaki rodzajnik ma Formular?", options: ["das", "die", "der"], answer: 0,
            check: Beat(pl: "Szef jest tutaj.", de: "Der Chef ist hier."),
            canSay: "Wkładasz der, die albo das, zamiast mówić samo słowo."
        ),
        CourseLesson(
            id: "przypadek", title: "eine, den, dem",
            explain: "Widzę szefa: den Chef. Pomagam koledze: dem Kollegen, bo helfen chce celownika. Zwolnienie: eine Krankschreibung.",
            again: "sehen bierze den. helfen bierze dem. die zostaje eine, nie einen. einen jest przy der: einen Bus.",
            words: [Beat(pl: "zwolnienie", de: "eine Krankschreibung"), Beat(pl: "widzę szefa", de: "ich sehe den Chef"), Beat(pl: "pomagam koledze", de: "ich helfe dem Kollegen"), Beat(pl: "potrzebuję", de: "ich brauche"), Beat(pl: "jeden autobus", de: "einen Bus")],
            examples: [Beat(pl: "Potrzebuję zwolnienia.", de: "Ich brauche eine Krankschreibung."), Beat(pl: "Widzę szefa.", de: "Ich sehe den Chef.")],
            help: Beat(pl: "Potrzebuję zwolnienia.", de: "Ich brauche eine Krankschreibung."),
            solo: Beat(pl: "Widzę szefa.", de: "Ich sehe den Chef."),
            listenDe: "Was brauchen Sie? Ich brauche eine Krankschreibung.",
            listenPl: "Lekarz pyta, czego potrzebujesz. Zwolnienia.",
            question: "Czego potrzebujesz?", options: ["Zwolnienia", "Kasku", "Klucza"], answer: 0,
            check: Beat(pl: "Pomagam koledze.", de: "Ich helfe dem Kollegen."),
            canSay: "Rozróżniasz eine, den i dem."
        ),
        CourseLesson(
            id: "musze", title: "Muszę i mogę",
            explain: "muss i kann stoją na drugim miejscu. Drugi czasownik idzie na koniec: Ich muss zum Arzt gehen. Nie ich muss gehen zum Arzt.",
            again: "Dwa czasowniki. Ten od musieć albo móc jest drugi, gehen i zahlen zostają na końcu.",
            words: [Beat(pl: "muszę", de: "ich muss"), Beat(pl: "mogę", de: "ich kann"), Beat(pl: "iść do lekarza", de: "zum Arzt gehen"), Beat(pl: "płacić kartą", de: "mit Karte zahlen"), Beat(pl: "zostać w domu", de: "zu Hause bleiben")],
            examples: [Beat(pl: "Muszę iść do lekarza.", de: "Ich muss zum Arzt gehen."), Beat(pl: "Czy mogę zapłacić kartą?", de: "Kann ich mit Karte zahlen?")],
            help: Beat(pl: "Muszę iść do lekarza.", de: "Ich muss zum Arzt gehen."),
            solo: Beat(pl: "Czy mogę zapłacić kartą?", de: "Kann ich mit Karte zahlen?"),
            listenDe: "Ich muss zum Arzt gehen. Heute? Ja. Ich kann morgen wieder arbeiten.",
            listenPl: "Musisz do lekarza. Jutro znowu możesz pracować.",
            question: "Kiedy znowu możesz pracować?", options: ["Jutro", "Za miesiąc", "Wcale"], answer: 0,
            check: Beat(pl: "Muszę iść do lekarza.", de: "Ich muss zum Arzt gehen."),
            canSay: "Układasz muss i kann, a drugi czasownik zostawiasz na końcu."
        )
    ]
}

struct CourseView: View {
    @EnvironmentObject var store: LearningStore
    @State private var index = 0
    @State private var step = 0
    @State private var typed = ""
    @State private var built: [String] = []
    @State private var note = ""
    @State private var alt = false
    @State private var heard = false
    @State private var picked: Int?
    @State private var passed: [String] = []
    @State private var misses: [String] = []
    @State private var recall = ""
    @State private var recallDone = true
    @FocusState private var writing: Bool

    private var lesson: CourseLesson { CourseBank.all[min(index, CourseBank.all.count - 1)] }
    private var names: [String] { ["Wyjaśnienie", "Słowa", "Przykłady", "Z pomocą", "Sam", "Słuch", "Sprawdzenie", "Umiesz"] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Lekcja \(index + 1) z \(CourseBank.all.count) · \(names[min(step, 7)])")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ProgressView(value: Double(step + 1), total: 8).tint(Theme.accent)
                Text(lesson.title).font(.title2.bold())
                content
            }
            .padding(20)
            .padding(.bottom, 40)
        }
        .navigationTitle("Lekcja")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            passed = UserDefaults.standard.stringArray(forKey: "coursePassed") ?? []
            misses = UserDefaults.standard.stringArray(forKey: "courseMiss") ?? []
            if let open = CourseBank.all.firstIndex(where: { !passed.contains($0.id) }) {
                index = open
                recallDone = open == 0
            }
        }
        .onDisappear { Talk.stop() }
    }

    @ViewBuilder private var content: some View {
        if index > 0, !recallDone {
            recallBox
        } else {
            switch step {
            case 0: explain
            case 1: words
            case 2: examples
            case 3: help
            case 4: write(lesson.solo, next: 5)
            case 5: listen
            case 6: write(lesson.check, next: 7)
            default: finish
            }
        }
    }

    private var explain: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(alt ? lesson.again : lesson.explain)
            Button("Pokaż słowa") { step = 1 }.primaryButton()
        }
    }

    private var words: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(lesson.words, id: \.de) { word in
                Button { Talk.de(word.de, rate: 0.42) } label: {
                    HStack {
                        Text(word.de).font(.headline)
                        Spacer()
                        Text(word.pl).font(.subheadline).foregroundStyle(Theme.text2)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            Button("Pokaż zdania") { step = 2 }.primaryButton()
        }
    }

    private var examples: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(lesson.examples, id: \.de) { line in
                Button { Talk.de(line.de, rate: 0.42) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(line.de).font(.headline)
                        Text(line.pl).font(.subheadline).foregroundStyle(Theme.text2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            Button("Ćwiczenie z pomocą") {
                built = []
                note = ""
                step = 3
            }
            .primaryButton()
        }
    }

    private var help: some View {
        let parts = lesson.help.de
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .split(separator: " ")
            .map(String.init)
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedDescending }
        return VStack(alignment: .leading, spacing: 10) {
            Text("Ułóż zdanie. Kafelki są pomocą.").font(.subheadline).foregroundStyle(Theme.text2)
            Text(lesson.help.pl).font(.title3.bold())
            Text(built.isEmpty ? "Stuknij kafelki po kolei" : built.joined(separator: " "))
                .font(.title3.bold())
                .foregroundStyle(built.isEmpty ? Theme.text2 : Theme.text)
                .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
                .padding(12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 8)], spacing: 8) {
                ForEach(Array(parts.enumerated()), id: \.offset) { _, part in
                    Button(part) {
                        built.append(part)
                        note = ""
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Theme.accent, in: Capsule())
                }
            }
            HStack {
                Button("Cofnij") { if !built.isEmpty { built.removeLast(); note = "" } }
                    .buttonStyle(.glass)
                Button("Od nowa") { built = []; note = "" }
                    .buttonStyle(.glass)
            }
            if !note.isEmpty { Text(note).font(.footnote).foregroundStyle(Theme.bad) }
            Button("Sprawdź układ") {
                let said = built.joined(separator: " ")
                if close(said, lesson.help.de) {
                    typed = ""
                    alt = false
                    note = ""
                    step = 4
                } else {
                    note = said.isEmpty
                        ? "Najpierw stuknij kafelki. Kropki na końcu nie trzeba."
                        : "Widzę „\(said)”. Ułóż jeszcze raz w kolejności zdania."
                    built = []
                    keep(lesson.help)
                }
            }
            .primaryButton()
        }
    }

    private func write(_ beat: Beat, next: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bez kafelków. Napisz sam.").font(.subheadline).foregroundStyle(Theme.text2)
            Text(beat.pl).font(.title3.bold())
            TextField("Po niemiecku", text: $typed, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($writing)
            Button("Sprawdź") {
                if close(typed, beat.de) {
                    if next == 7 {
                        if !passed.contains(lesson.id) { passed.append(lesson.id) }
                        UserDefaults.standard.set(passed, forKey: "coursePassed")
                        store.grade(word(beat), .easy, produced: true)
                    }
                    alt = false
                    typed = ""
                    heard = false
                    picked = nil
                    step = next
                    writing = false
                } else {
                    alt = true
                    typed = ""
                    keep(beat)
                }
            }
            .primaryButton()
            .disabled(typed.trimmingCharacters(in: .whitespaces).isEmpty)
            if alt {
                Text(lesson.again).foregroundStyle(Theme.text2)
                Text("Jedno spojrzenie: \(beat.de). Potem napisz to sam.").font(.footnote)
            }
        }
    }

    private var listen: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Najpierw samo ucho.").font(.subheadline).foregroundStyle(Theme.text2)
            Button { Talk.de(lesson.listenDe, rate: 0.42) } label: { Label("Odtwórz", systemImage: "speaker.wave.2.fill") }
                .buttonStyle(.glass)
            if !heard {
                Button("Słyszałem") { heard = true }.primaryButton()
            } else {
                Text(lesson.listenDe).font(.headline)
                Text(lesson.listenPl).foregroundStyle(Theme.text2)
                Text(lesson.question).font(.headline)
                ForEach(lesson.options.indices, id: \.self) { i in
                    Button(lesson.options[i]) {
                        guard picked == nil else { return }
                        picked = i
                        if i != lesson.answer { keep(Beat(pl: lesson.question, de: lesson.options[lesson.answer])) }
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .foregroundStyle(.white)
                    .background(fill(i), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                if picked != nil {
                    Button("Sprawdzenie bez podpowiedzi") {
                        typed = ""
                        alt = false
                        step = 6
                    }
                    .primaryButton()
                }
            }
        }
    }

    private var finish: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(lesson.canSay)
            Text(lesson.check.de).font(.title3.bold())
            Text(lesson.check.pl).foregroundStyle(Theme.text2)
            Text("To zdanie wraca jutro, potem za 3, 7 i 14 dni. Samo rozpoznanie go nie zalicza.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            if !misses.isEmpty {
                Text("Do powtórki: \(misses.suffix(3).joined(separator: " · "))")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
            if index + 1 < CourseBank.all.count {
                Button("Następna lekcja") { open(index + 1) }.primaryButton()
            } else {
                Text("Koniec tej ścieżki. Trudniejsze tematy dochodzą, gdy te zdania piszesz sam.")
            }
        }
    }

    private var recallBox: some View {
        let previous = CourseBank.all[index - 1]
        return VStack(alignment: .leading, spacing: 10) {
            Text("Najpierw zdanie z poprzedniej lekcji").font(.subheadline).foregroundStyle(Theme.text2)
            Text(previous.check.pl).font(.title3.bold())
            TextField("Po niemiecku", text: $recall, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            Button("Sprawdź") {
                if close(recall, previous.check.de) {
                    recallDone = true
                    alt = false
                } else {
                    alt = true
                    keep(previous.check)
                }
            }
            .primaryButton()
            if alt { Text("\(previous.again) Wzorzec: \(previous.check.de)").foregroundStyle(Theme.text2) }
        }
    }

    private func fill(_ i: Int) -> Color {
        guard let picked else { return Theme.card }
        if i == lesson.answer { return Theme.ok.opacity(0.85) }
        if i == picked { return Theme.bad.opacity(0.85) }
        return Theme.card
    }

    private func open(_ next: Int) {
        index = next
        step = 0
        typed = ""
        built = []
        note = ""
        alt = false
        heard = false
        picked = nil
        recall = ""
        recallDone = next == 0
    }

    private func keep(_ beat: Beat) {
        if !misses.contains(beat.pl) { misses.append(beat.pl) }
        UserDefaults.standard.set(misses, forKey: "courseMiss")
        store.grade(word(beat), .hard, produced: false)
        Haptic.bad()
    }

    private func word(_ beat: Beat) -> Word {
        Word(de: beat.de, pl: beat.pl, ex: beat.de, exPl: beat.pl, topic: "Lekcja", level: "A1")
    }

    private func close(_ typed: String, _ expected: String) -> Bool {
        if Normalizer.same(typed, expected) { return true }
        let said = Normalizer.clean(typed)
        let keys = Normalizer.clean(expected).split(separator: " ").map(String.init).filter { $0.count > 2 }
        guard !keys.isEmpty else { return false }
        let hit = keys.filter { said.contains($0) }.count
        return Double(hit) / Double(keys.count) >= 0.7
    }
}

private struct FlexibleChips: View {
    let parts: [String]
    let tap: (String) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(parts, id: \.self) { part in
                    Button(part) { tap(part) }
                        .buttonStyle(.glass)
                }
            }
        }
    }
}
