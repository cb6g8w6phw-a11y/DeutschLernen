import SwiftUI

struct GamesHome: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Krótkie rundy z Twoich słówek. Dobra odpowiedź wchodzi do powtórek.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                NavigationLink { MatchGame() } label: {
                    gameRow("Pary", "Połącz niemieckie z polskim.", "square.grid.2x2", Theme.accent)
                }
                .buttonStyle(.plain)
                NavigationLink { OrderGame() } label: {
                    gameRow("Ułóż zdanie", "Ustaw słowa w dobrej kolejności.", "text.line.first.and.arrowtriangle.forward", Theme.orange)
                }
                .buttonStyle(.plain)
                NavigationLink { SpeedGame() } label: {
                    gameRow("45 sekund", "Ile trafisz, zanim czas spadnie.", "timer", Color(hex: "5AC8FA"))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .padding(.bottom, 40)
        }
        .navigationTitle("Gry")
        .containerBackground(for: .navigation) { NightGlow() }
    }

    private func gameRow(_ title: String, _ text: String, _ icon: String, _ tint: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(tint, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(Theme.text)
                Text(text).font(.subheadline).foregroundStyle(Theme.text2)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
        }
        .padding(14)
        .themedCard()
    }
}

struct MatchGame: View {
    @EnvironmentObject var store: LearningStore
    @State private var cards: [PairCard] = []
    @State private var first: UUID?
    @State private var locked: Set<UUID> = []
    @State private var wrong: Set<UUID> = []
    @State private var hits = 0
    @State private var moves = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trafione \(hits) z 4. Ruchy: \(moves)")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(cards) { card in
                    Button { tap(card) } label: {
                        Text(card.text)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.text)
                            .frame(maxWidth: .infinity, minHeight: 88)
                            .padding(8)
                            .background(fill(card), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(locked.contains(card.id))
                }
            }
            if hits == 4 {
                Text("Komplet. Te cztery słowa są zapisane.")
                    .font(.headline)
                Button("Nowa runda") { deal() }.primaryButton()
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Pary")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { if cards.isEmpty { deal() } }
    }

    private func fill(_ card: PairCard) -> Color {
        if locked.contains(card.id) { return Theme.ok.opacity(0.45) }
        if wrong.contains(card.id) { return Color(hex: "FF453A").opacity(0.45) }
        if first == card.id { return Theme.accent.opacity(0.55) }
        return Theme.card
    }

    private func deal() {
        let pack = Array(store.words.shuffled().prefix(4))
        var next: [PairCard] = []
        for word in pack {
            next.append(PairCard(text: word.de, key: word.de, word: word))
            next.append(PairCard(text: word.pl, key: word.de, word: word))
        }
        cards = next.shuffled()
        first = nil
        locked = []
        wrong = []
        hits = 0
        moves = 0
    }

    private func tap(_ card: PairCard) {
        guard !locked.contains(card.id) else { return }
        if let open = first, let other = cards.first(where: { $0.id == open }) {
            if other.id == card.id { return }
            moves += 1
            if other.key == card.key, other.id != card.id {
                locked.insert(open)
                locked.insert(card.id)
                hits += 1
                store.grade(card.word, .easy)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                first = nil
            } else {
                wrong = [open, card.id]
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                first = nil
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    wrong = []
                }
            }
        } else {
            wrong = []
            first = card.id
        }
    }
}

struct PairCard: Identifiable {
    let id = UUID()
    let text: String
    let key: String
    let word: Word
}

struct OrderGame: View {
    @EnvironmentObject var store: LearningStore
    @State private var word: Word?
    @State private var pool: [Piece] = []
    @State private var built: [Piece] = []
    @State private var note = ""
    @State private var done = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(word?.pl ?? "Ładuję zdanie")
                .font(.title3.weight(.semibold))
            Text(word?.exPl ?? "")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            FlowPieces(pieces: built) { piece in
                guard !done else { return }
                built.removeAll { $0.id == piece.id }
                pool.append(piece)
            }
            FlowPieces(pieces: pool) { piece in
                guard !done else { return }
                pool.removeAll { $0.id == piece.id }
                built.append(piece)
            }
            if !note.isEmpty {
                Text(note).font(.headline).foregroundStyle(done ? Theme.ok : Color(hex: "FF453A"))
            }
            if done {
                Button("Następne zdanie") { load() }.primaryButton()
            } else {
                Button("Sprawdź") { check() }
                    .primaryButton()
                    .disabled(!pool.isEmpty)
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Ułóż zdanie")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { if word == nil { load() } }
    }

    private func load() {
        let pick = store.words.shuffled().first { sentenceWords($0.ex).count >= 3 && sentenceWords($0.ex).count <= 8 }
        word = pick ?? store.words.first
        let parts = sentenceWords(word?.ex ?? "").map { Piece(text: $0) }.shuffled()
        pool = parts
        built = []
        note = ""
        done = false
    }

    private func check() {
        let answer = built.map(\.text).joined(separator: " ")
        let wanted = sentenceWords(word?.ex ?? "").joined(separator: " ")
        if answer.compare(wanted, options: .caseInsensitive) == .orderedSame, let word {
            note = "Dobrze."
            done = true
            store.grade(word, .easy)
            Talk.de(word.ex)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            note = "Jeszcze nie. Popraw kolejność."
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func sentenceWords(_ text: String) -> [String] {
        text.replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .split(separator: " ")
            .map(String.init)
    }
}

struct Piece: Identifiable {
    let id = UUID()
    let text: String
}

struct FlowPieces: View {
    let pieces: [Piece]
    var tap: (Piece) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(pieces) { piece in
                    Button(piece.text) { tap(piece) }
                        .buttonStyle(.bordered)
                        .tint(Theme.accent)
                        .frame(minHeight: 44)
                }
            }
            .padding(.vertical, 4)
        }
        .frame(minHeight: 52)
    }
}

struct SpeedGame: View {
    @EnvironmentObject var store: LearningStore
    @State private var left = 45
    @State private var hits = 0
    @State private var misses = 0
    @State private var word: Word?
    @State private var options: [Word] = []
    @State private var running = false
    @State private var clock: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(left) s")
                .font(.largeTitle.bold())
            Text("Trafione \(hits), pudła \(misses)")
                .foregroundStyle(Theme.text2)
            if !running {
                Text(left == 0 ? "Koniec rundy." : "Widzisz polski sens. Stuknij niemieckie słowo.")
                    .font(.body)
                Button(left == 0 ? "Jeszcze raz" : "Start") { start() }.primaryButton()
            } else if let word {
                Text(word.pl)
                    .font(.title.weight(.bold))
                ForEach(options) { option in
                    Button(option.de) { choose(option) }
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .foregroundStyle(Theme.text)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("45 sekund")
        .containerBackground(for: .navigation) { NightGlow() }
        .onDisappear { clock?.cancel() }
    }

    private func start() {
        hits = 0
        misses = 0
        left = 45
        running = true
        next()
        clock?.cancel()
        clock = Task {
            while !Task.isCancelled, left > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                left -= 1
            }
            running = false
        }
    }

    private func next() {
        let pack = store.words.shuffled()
        guard let first = pack.first else { return }
        word = first
        options = (Array(pack.prefix(3))).shuffled()
        if !options.contains(where: { $0.de == first.de }) {
            options = (Array(pack.dropFirst().prefix(2)) + [first]).shuffled()
        }
    }

    private func choose(_ option: Word) {
        guard running, let word else { return }
        if option.de == word.de {
            hits += 1
            store.grade(word, .mid)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            misses += 1
            store.grade(word, .hard)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        next()
    }
}
