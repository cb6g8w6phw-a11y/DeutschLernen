import SwiftUI

struct GrammarItem {
    let title: String
    let prompt: String
    let options: [String]
    let answer: Int
    let why: String
}

enum GrammarBank {
    static let all: [GrammarItem] = DailyPack.grammar
}

struct GrammarView: View {
    @State private var deck: [GrammarItem] = []
    @State private var index = 0
    @State private var picked: Int?
    @State private var hits = 0

    private var item: GrammarItem { deck.indices.contains(index) ? deck[index] : GrammarBank.all[0] }
    private var finished: Bool { !deck.isEmpty && index >= deck.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if finished {
                Text("Gotowe")
                    .font(.largeTitle.bold())
                Text("Trafione \(hits) z \(deck.count).")
                Button("Jeszcze raz") {
                    deck = GrammarBank.all.shuffled()
                    index = 0
                    picked = nil
                    hits = 0
                }
                .primaryButton()
            } else {
                Text(item.title).font(.caption).foregroundStyle(Theme.text2)
                Text("\(index + 1) z \(deck.count)")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Text(item.prompt).font(.title2.bold())
                ForEach(item.options.indices, id: \.self) { i in
                    Button(item.options[i]) { pick(i) }
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .foregroundStyle(.white)
                        .background(fill(i), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                if picked != nil {
                    Text(item.why).foregroundStyle(Theme.text2)
                    Button(index + 1 >= deck.count ? "Zakończ" : "Dalej") {
                        index += 1
                        picked = nil
                    }
                    .primaryButton()
                }
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Gramatyka")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            if deck.isEmpty { deck = GrammarBank.all.shuffled() }
        }
    }

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        if i == item.answer {
            hits += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func fill(_ i: Int) -> Color {
        guard let picked else { return Theme.card }
        if i == item.answer { return Theme.ok.opacity(0.8) }
        if i == picked { return Color(hex: "FF453A").opacity(0.8) }
        return Theme.card
    }
}

struct FixItem: Identifiable {
    let id: String
    let wrong: String
    let right: String
    let why: String
}

struct MistakeReview: View {
    @EnvironmentObject var store: LearningStore
    @State private var round: [FixItem] = []
    @State private var index = 0
    @State private var picked: Int?
    @State private var hits = 0
    @State private var note = ""

    private static let classics: [FixItem] = [
        FixItem(id: "alter", wrong: "Ich habe 26 Jahre.", right: "Ich bin 26 Jahre alt.", why: "Wiek: ich bin … Jahre alt."),
        FixItem(id: "zeit", wrong: "Ich bin 8 Uhr.", right: "Es ist 8 Uhr.", why: "Godzina: es ist 8 Uhr."),
        FixItem(id: "wo", wrong: "Ich gehe zu Arbeit.", right: "Ich gehe zur Arbeit.", why: "Do pracy: zur Arbeit."),
        FixItem(id: "heim", wrong: "Ich gehe nach Hause zu.", right: "Ich gehe nach Hause.", why: "Do domu: nach Hause. Bez „zu”."),
        FixItem(id: "arzt", wrong: "Ich muss zum Arzt gehen morgen.", right: "Ich muss morgen zum Arzt gehen.", why: "Czas stoi przed resztą: morgen zum Arzt."),
        FixItem(id: "perfekt", wrong: "Ich habe gegangen.", right: "Ich bin gegangen.", why: "gehen bierze sein: ich bin gegangen."),
        FixItem(id: "artikel", wrong: "Ich brauche ein Schaufel.", right: "Ich brauche eine Schaufel.", why: "die Schaufel, więc eine."),
        FixItem(id: "bitte", wrong: "Geben Sie mir das.", right: "Geben Sie mir das bitte.", why: "W pracy dodaj bitte."),
        FixItem(id: "nicht", wrong: "Ich arbeite heute nicht die Frühschicht.", right: "Ich arbeite heute nicht in der Frühschicht.", why: "Na zmianie: in der Frühschicht."),
        FixItem(id: "kennen", wrong: "Ich weiß ihn.", right: "Ich kenne ihn.", why: "Znać osobę: kennen. wissen to wiedzieć fakt."),
        FixItem(id: "uhr", wrong: "Um sechs Uhr dreißig.", right: "Um halb sieben.", why: "6:30 mówisz um halb sieben."),
        FixItem(id: "geld", wrong: "Ich habe kein Geld nicht.", right: "Ich habe kein Geld.", why: "Raz wystarczy: kein. Nie dodawaj nicht.")
    ]

    private var item: FixItem? { index < round.count ? round[index] : nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let item {
                Text("Zostaje, aż trafisz 2 razy. Potem znika.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                Text("\(index + 1) z \(round.count)").font(.footnote).foregroundStyle(Theme.text2)
                Text("Które zdanie jest dobre?").font(.headline)
                Button(item.wrong) { choose(0, item) }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .padding(.horizontal, 12)
                    .background(fill(0), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                Button(item.right) { choose(1, item) }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .padding(.horizontal, 12)
                    .background(fill(1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                if picked != nil {
                    Text(item.why).foregroundStyle(Theme.text2)
                    if !note.isEmpty { Text(note).font(.footnote).foregroundStyle(Theme.text2) }
                    Button("Posłuchaj poprawnego") { Talk.de(item.right) }
                        .ghostButton()
                    Button("Dalej") {
                        index += 1
                        picked = nil
                        note = ""
                    }
                    .primaryButton()
                }
            } else {
                Text(round.isEmpty ? "Na razie nie masz błędów do nauki." : "Te błędy są opanowane.")
                Text("Trafione w tej rundzie: \(hits).")
                Button("Sprawdź, co jeszcze zostało") { reload(reshuffle: true) }
                    .primaryButton()
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Błędy")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { if round.isEmpty { reload(reshuffle: false) } }
    }

    private func reload(reshuffle: Bool) {
        var rows = DailyPack.fixes.filter { classicHits($0.id) < 2 }
        for slip in store.journal.mistakes where !slip.fix.isEmpty && slip.hits < 2 {
            rows.append(FixItem(id: slip.id, wrong: slip.text, right: slip.fix, why: "Twój błąd. Zostaje, aż trafisz dwa razy."))
        }
        round = reshuffle ? rows.shuffled() : rows
        index = 0
        picked = nil
        note = ""
    }

    private func choose(_ i: Int, _ item: FixItem) {
        guard picked == nil else { return }
        picked = i
        let ok = i == 1
        if ok {
            hits += 1
            UserDefaults.standard.set(LearningStore.dayKey(), forKey: "didFixDay")
            Talk.de(item.right)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        if store.journal.mistakes.contains(where: { $0.id == item.id }) {
            store.gradeMistake(item.id, ok: ok)
            if let left = store.journal.mistakes.first(where: { $0.id == item.id })?.hits {
                note = ok ? "Zostaje. Trafienie \(left) z 2." : "Źle, więc licznik od zera. Zostaje."
                round.append(item)
            } else {
                note = "Opanowane. Już nie wraca."
            }
        } else {
            var map = classicHitsMap()
            map[item.id] = ok ? (map[item.id] ?? 0) + 1 : 0
            if let data = try? JSONEncoder().encode(map) {
                UserDefaults.standard.set(data, forKey: "classicHits")
            }
            let left = map[item.id] ?? 0
            note = ok ? (left >= 2 ? "Opanowane. Już nie wraca." : "Zostaje. Trafienie \(left) z 2.") : "Źle, więc licznik od zera. Zostaje."
            if !ok || left < 2 { round.append(item) }
        }
    }

    private func classicHits(_ id: String) -> Int { classicHitsMap()[id] ?? 0 }

    private func classicHitsMap() -> [String: Int] {
        guard let data = UserDefaults.standard.data(forKey: "classicHits"),
              let map = try? JSONDecoder().decode([String: Int].self, from: data) else { return [:] }
        return map
    }

    private func fill(_ i: Int) -> Color {
        guard let picked else { return Theme.card }
        if i == 1 { return Theme.ok.opacity(0.75) }
        if i == picked { return Color(hex: "FF453A").opacity(0.75) }
        return Theme.card
    }
}

struct DictationView: View {
    @State private var deck: [(de: String, pl: String)] = []
    @State private var index = 0
    @State private var input = ""
    @State private var note = ""

    private var line: (de: String, pl: String) { deck.indices.contains(index) ? deck[index] : ("", "") }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Posłuchaj zdania i zapisz je po niemiecku.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            Text("\(min(index + 1, max(deck.count, 1))) z \(deck.count) · pula 100")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            VoiceControls(text: line.de)
            Button("Odtwórz dyktando") { Talk.de(line.de) }
                .primaryButton()
            PaceButtons()
            TextField("Zapisz, co usłyszałeś", text: $input, axis: .vertical)
                .lineLimit(2...4)
                .padding(12)
                .themedCard(radius: 16)
            Button("Sprawdź") { check() }
                .primaryButton()
            if !note.isEmpty {
                Text(note).font(.headline)
                Text(line.pl).foregroundStyle(Theme.text2)
            }
            if index + 1 < deck.count, note.hasPrefix("Dobrze") {
                Button("Następne") {
                    let next = deck[index + 1]
                    index += 1
                    input = ""
                    note = ""
                    Talk.de(next.de)
                }
                .ghostButton()
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Dyktando")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear {
            if deck.isEmpty {
                deck = DailyPack.lines.shuffled()
                Talk.de(deck[0].de)
            }
        }
        .onDisappear { Talk.stop() }
    }

    private func check() {
        let heard = input.lowercased().filter { $0.isLetter || $0.isNumber || $0 == " " }
        let wanted = line.de.lowercased().filter { $0.isLetter || $0.isNumber || $0 == " " }
        if heard.split(separator: " ").joined(separator: " ") == wanted.split(separator: " ").joined(separator: " ") {
            note = "Dobrze."
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            note = "Jeszcze nie. Poprawnie: \(line.de)"
            Talk.de(line.de)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
