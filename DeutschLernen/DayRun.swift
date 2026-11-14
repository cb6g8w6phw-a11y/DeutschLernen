import SwiftUI

/// Jedna lekcja na około 10 minut. Aplikacja sama bierze błędy i nowe zdania.
/// Najpierw wyjaśnia po polsku, potem przykład, potem odpowiedź bez podpowiedzi.
struct DailyRunView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var phase = 0
    @State private var fixes: [FixItem] = []
    @State private var words: [Word] = []
    @State private var cursor = 0
    @State private var taught = false
    @State private var hinted = false
    @State private var typed = ""
    @State private var picked: Int?
    @State private var note = ""
    @State private var parts: [(word: String, ok: Bool)] = []
    @State private var reviewHits = 0
    @State private var phraseHits = 0
    @State private var said = false
    @State private var held = false
    @FocusState private var writing: Bool
    @AppStorage("band") private var band = "A1"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(phaseTitle).font(.title2.bold())
                Text(phaseHint).font(.subheadline).foregroundStyle(Theme.text2)
                switch phase {
                case 0: reviewBlock
                case 1: freshBlock
                case 2: speakBlock
                case 3: checkBlock
                default: summary
                }
            }
            .padding(20)
        }
        .navigationTitle("Dziś")
        .navigationBarTitleDisplayMode(.inline)
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .onAppear(perform: load)
        .onDisappear { mic.stop(); Talk.stop() }
        .onChange(of: mic.listening) { was, now in
            guard phase == 2, was, !now else { return }
            let heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty, let word = words.first else { return }
            let line = word.ex.isEmpty ? word.de : word.ex
            parts = Heard.parts(target: line, heard: heard)
            let ok = !parts.isEmpty && parts.allSatisfy(\.ok)
            said = ok
            store.noteSaid(ok: ok)
            if !ok { HardBook.add(de: line, pl: word.pl) }
        }
    }

    private var phaseTitle: String {
        switch phase {
        case 0: return "Powtórka, około 2 min"
        case 1: return "Nowy zwrot i słuch, około 3 min"
        case 2: return "Mówienie, około 4 min"
        case 3: return "Sprawdzenie, około 1 min"
        default: return "Koniec lekcji"
        }
    }

    private var phaseHint: String {
        switch phase {
        case 0: return "Najpierw dlaczego, potem przykład, na końcu wybór bez podpowiedzi."
        case 1: return "Najpierw po polsku. Niemiecki słyszysz, zanim zaczniesz pisać."
        case 2: return "Jedno pytanie w rozmowie. Poprawka krótko po polsku, dalej po niemiecku."
        case 3: return "Bez podpowiedzi. Jedno trafienie nie znaczy, że zdanie jest opanowane."
        default: return "Opanowane jest dopiero po kilku dniach samodzielnej odpowiedzi."
        }
    }

    @ViewBuilder private var reviewBlock: some View {
        if fixes.isEmpty {
            Text("Nie masz otwartych błędów. Idziemy do nowego zwrotu.")
            Button("Dalej") { advance() }.primaryButton()
        } else if cursor < fixes.count {
            let item = fixes[cursor]
            if !taught {
                Text(item.why).font(.body)
                Text(item.right).font(.title3.bold())
                Text("Tak nie mów: \(item.wrong)").font(.footnote).foregroundStyle(Theme.text2)
                Button { Talk.de(item.right, rate: 0.38) } label: { Label("Posłuchaj wolno", systemImage: "speaker.wave.1") }
                    .buttonStyle(.glass)
                Button("Sprawdź bez podpowiedzi") { taught = true; picked = nil }
                    .primaryButton()
            } else {
                Text("Które zdanie jest dobre?").font(.headline)
                choice(item.wrong, 0, answer: 1)
                choice(item.right, 1, answer: 1)
                if picked != nil {
                    Text(picked == 1 ? "Dobrze. Zostaje, aż powtórzy się to jeszcze raz w inny dzień." : "Jeszcze nie. \(item.why)")
                        .foregroundStyle(Theme.text2)
                    Button("Dalej") { nextFix(ok: picked == 1) }.primaryButton()
                }
            }
        }
    }

    @ViewBuilder private var freshBlock: some View {
        if words.isEmpty {
            Text("Nie mam nowego zdania w tej puli.")
            Button("Do mówienia") { phase = 2 }.primaryButton()
        } else {
            let word = words[min(cursor, words.count - 1)]
            let line = word.ex.isEmpty ? word.de : word.ex
            if !taught {
                Text("Po polsku").font(.caption).foregroundStyle(Theme.text2)
                Text(word.pl).font(.title3.bold())
                Text("Tego używasz w zwykłej sytuacji, nie jako luźnego słówka.").foregroundStyle(Theme.text2)
                Button("Posłuchaj, jeszcze bez tekstu") {
                    Talk.de(line, rate: 0.36)
                    taught = true
                }
                .primaryButton()
            } else if !hinted {
                Text(line).font(.title3.bold())
                Text(word.pl).foregroundStyle(Theme.text2)
                Button { Talk.de(line, rate: 0.36) } label: { Label("Wolniej", systemImage: "tortoise") }.buttonStyle(.glass)
                Button { Talk.de(line, rate: 0.52) } label: { Label("Naturalnie", systemImage: "hare") }.buttonStyle(.glass)
                Text("Napisz zdanie. Podpowiedź: \(line.split(separator: " ").first.map(String.init) ?? "")…")
                    .font(.footnote).foregroundStyle(Theme.text2)
                field()
                Button("Sprawdź z podpowiedzią") { gradeFresh(word, line, hinted: true) }
                    .primaryButton()
                    .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
            } else {
                Text("Teraz sam, bez początku zdania.").font(.headline)
                Text(word.pl)
                field()
                Button("Sprawdź sam") { gradeFresh(word, line, hinted: false) }
                    .primaryButton()
                    .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
            }
        }
    }

    private var speakBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI zada jedno pytanie i poczeka. Jak się pomylisz, usłyszysz krótką poprawkę po polsku i rozmowa jedzie dalej po niemiecku.")
                .foregroundStyle(Theme.text2)
            NavigationLink {
                TutorView(launch: TalkLaunch(
                    id: "dzis",
                    title: "Dzisiejsza rozmowa",
                    who: "Jesteś kierownikiem na budowie. Mówisz prostym A1–A2. Jedno pytanie na raz. Po błędzie krótka poprawka po polsku, potem znowu po niemiecku.",
                    de: "Was machst du heute auf der Arbeit?",
                    pl: "Co dzisiaj robisz w pracy?",
                    say: "Ich arbeite heute auf der Baustelle."
                ))
            } label: {
                Text("Wejdź w rozmowę").primaryButton()
            }
            .buttonStyle(.plain)
            if let word = words.first {
                let line = word.ex.isEmpty ? word.de : word.ex
                Text("Powiedz też zdanie z tej lekcji:").font(.headline)
                Text(word.pl)
                if !parts.isEmpty { SaidWords(parts: parts) }
                Button { mic.toggle() } label: { Label(mic.listening ? "Stop" : "Powiedz", systemImage: "mic.fill") }
                    .buttonStyle(.glassProminent)
                Text(said ? "Zdanie zgodziło się słowo po słowie." : "Bez pełnego nagrania nie zaliczam mówienia.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Button("Dalej do sprawdzenia") { phase = 3; cursor = 0; taught = false; hinted = false; typed = ""; note = "" }
                    .primaryButton()
                Text(line).font(.caption2).foregroundStyle(Theme.text2)
            } else {
                Button("Dalej") { phase = 3 }.primaryButton()
            }
        }
    }

    @ViewBuilder private var checkBlock: some View {
        if let word = words.last {
            let line = word.ex.isEmpty ? word.de : word.ex
            Text("Napisz po niemiecku, bez podglądu.").font(.headline)
            Text(word.pl).font(.title3.bold())
            field()
            Button("Zapisz wynik") { finishCheck(word, line) }
                .primaryButton()
                .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            if held { Text(note).foregroundStyle(Theme.text2) }
        } else {
            Button("Podsumowanie") { phase = 4 }.primaryButton()
        }
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Powtórka: \(reviewHits) z \(fixes.count).")
            Text("Nowe zdanie samodzielnie: \(phraseHits > 0 ? "weszło na dziś" : "jeszcze nie").")
            Text("Mówienie: \(said ? "zdanie się zgodziło" : "niezaliczone, brak pełnego nagrania albo błąd").")
            Text("Jedno kliknięcie albo jeden dobry dzień nie zamyka słowa. Opanowane jest po 3 dniach, kiedy sam je napiszesz.")
                .foregroundStyle(Theme.text2)
            Text("Opanowane dotychczas: \(store.masteredCount).")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
        }
    }

    private func field() -> some View {
        TextField("Po niemiecku", text: $typed, axis: .vertical)
            .lineLimit(2...3)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($writing)
    }

    private func choice(_ title: String, _ index: Int, answer: Int) -> some View {
        Button(title) { if picked == nil { picked = index } }
            .frame(maxWidth: .infinity, minHeight: 52)
            .foregroundStyle(Theme.text)
            .background(fill(index, answer: answer), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func fill(_ index: Int, answer: Int) -> Color {
        guard let picked else { return Theme.card }
        if index == answer { return Theme.ok.opacity(0.8) }
        if index == picked { return Theme.bad.opacity(0.8) }
        return Theme.card
    }

    private func load() {
        guard fixes.isEmpty, words.isEmpty else { return }
        fixes = Array(MistakeReview.nextEight(store: store).prefix(2))
        words = Array(store.nextSession(size: 2, maxNew: 1, level: band == "oba" ? "A2" : band).prefix(2))
    }

    private func nextFix(ok: Bool) {
        if ok { reviewHits += 1 }
        if cursor < fixes.count {
            let item = fixes[cursor]
            if store.journal.mistakes.contains(where: { $0.id == item.id }) {
                store.gradeMistake(item.id, ok: ok)
            }
            store.noteSkill("grammar", ok: ok)
        }
        cursor += 1
        taught = false
        picked = nil
        if cursor >= fixes.count { advance() }
    }

    private func gradeFresh(_ word: Word, _ line: String, hinted: Bool) {
        writing = false
        let ok = Normalizer.same(typed, line)
        if hinted {
            note = ok ? "Z podpowiedzią weszło. Teraz to samo bez początku." : "Jeszcze nie. Tak się pisze: \(line)"
            self.hinted = true
            typed = ""
            if !ok { store.scheduleTomorrow(word) }
        } else if ok {
            phraseHits += 1
            store.grade(word, .easy, produced: true)
            note = "Sam napisałeś. To pierwszy dzień, nie koniec nauki."
            advanceFresh()
        } else {
            store.scheduleTomorrow(word)
            HardBook.add(de: line, pl: word.pl)
            note = "Bez podpowiedzi nie weszło. Zostaje na jutro. Tak: \(line)"
            advanceFresh()
        }
    }

    private func advanceFresh() {
        if cursor + 1 < words.count {
            cursor += 1
            taught = false
            hinted = false
            typed = ""
            note = ""
        } else {
            phase = 2
            typed = ""
            note = ""
        }
    }

    private func finishCheck(_ word: Word, _ line: String) {
        writing = false
        let ok = Normalizer.same(typed, line)
        if ok {
            store.grade(word, .easy, produced: true)
            note = "Pamiętasz. I tak wraca po przerwie, zanim będzie opanowane."
        } else {
            store.scheduleTomorrow(word)
            HardBook.add(de: line, pl: word.pl)
            store.addMistake("\(typed)| \(line)")
            note = "Nie pamiętasz jeszcze. Poprawnie: \(line)"
        }
        store.noteSkill("sentence", ok: ok)
        held = true
        phase = 4
    }

    private func advance() {
        phase = min(phase + 1, 4)
        cursor = 0
        taught = false
        hinted = false
        typed = ""
        picked = nil
        note = ""
    }
}
