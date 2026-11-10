import SwiftUI

struct GrammarItem {
    let title: String
    let prompt: String
    let options: [String]
    let answer: Int
    let why: String
}

enum GrammarBank {
    static let all: [GrammarItem] = [
        GrammarItem(title: "Der, die, das", prompt: "___ Tisch", options: ["der", "die", "das"], answer: 0, why: "Tisch jest rodzaju męskiego: der Tisch."),
        GrammarItem(title: "Der, die, das", prompt: "___ Tür", options: ["der", "die", "das"], answer: 1, why: "Tür jest rodzaju żeńskiego: die Tür."),
        GrammarItem(title: "Der, die, das", prompt: "___ Auto", options: ["der", "die", "das"], answer: 2, why: "Auto jest rodzaju nijakiego: das Auto."),
        GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ 26 Jahre alt.", options: ["bin", "habe", "mache"], answer: 0, why: "Wiek: ich bin … Jahre alt. Nie „ich habe Jahre”."),
        GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ heute Frühschicht.", options: ["bin", "habe", "mache"], answer: 1, why: "Masz zmianę: ich habe Frühschicht."),
        GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ die Palette fertig.", options: ["bin", "habe", "mache"], answer: 2, why: "Robisz coś: ich mache die Palette fertig."),
        GrammarItem(title: "Czas przeszły", prompt: "Gestern ___ ich gearbeitet.", options: ["bin", "habe", "werde"], answer: 1, why: "arbeiten w czasie przeszłym: ich habe gearbeitet."),
        GrammarItem(title: "Czas przeszły", prompt: "Gestern ___ ich zu spät gekommen.", options: ["bin", "habe", "werde"], answer: 0, why: "kommen bierze sein: ich bin gekommen."),
        GrammarItem(title: "Czas przyszły", prompt: "Morgen ___ ich früher kommen.", options: ["habe", "bin", "werde"], answer: 2, why: "Jutro: ich werde früher kommen."),
        GrammarItem(title: "Szyk zdania", prompt: "Dziś pracuję.", options: ["Heute arbeite ich.", "Heute ich arbeite.", "Ich heute arbeite."], answer: 0, why: "Po Heute czasownik jest drugi: Heute arbeite ich.")
    ]
}

struct GrammarView: View {
    @State private var index = 0
    @State private var picked: Int?
    @State private var hits = 0

    private var item: GrammarItem { GrammarBank.all[min(index, GrammarBank.all.count - 1)] }
    private var finished: Bool { index >= GrammarBank.all.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if finished {
                Text("Gotowe")
                    .font(.largeTitle.bold())
                Text("Trafione \(hits) z \(GrammarBank.all.count).")
                Button("Jeszcze raz") {
                    index = 0
                    picked = nil
                    hits = 0
                }
                .primaryButton()
            } else {
                Text(item.title).font(.caption).foregroundStyle(Theme.text2)
                Text("\(index + 1) z \(GrammarBank.all.count)")
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
                    Button(index + 1 >= GrammarBank.all.count ? "Zakończ" : "Dalej") {
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
    @State private var index = 0
    @State private var picked: Int?
    @State private var hits = 0

    private var items: [FixItem] {
        var rows = [
            FixItem(id: "alter", wrong: "Ich habe 26 Jahre.", right: "Ich bin 26 Jahre alt.", why: "Wiek mówi się z sein: ich bin … Jahre alt."),
            FixItem(id: "zeit", wrong: "Ich bin 8 Uhr.", right: "Es ist 8 Uhr.", why: "Godzina: es ist 8 Uhr. Nie „ich bin 8 Uhr”."),
            FixItem(id: "wo", wrong: "Ich gehe zu Arbeit.", right: "Ich gehe zur Arbeit.", why: "Do pracy: zur Arbeit.")
        ]
        for slip in store.journal.mistakes.prefix(8) where !slip.fix.isEmpty {
            rows.append(FixItem(id: slip.id, wrong: slip.text, right: slip.fix, why: "To Twój błąd z rozmowy."))
        }
        return rows
    }

    private var finished: Bool { index >= items.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if items.isEmpty || finished {
                Text(finished ? "Te błędy są na dziś odhaczone." : "Jeszcze nie ma Twoich błędów. Zrób te trzy klasyczne.")
                if finished {
                    Text("Trafione \(hits) z \(items.count).")
                }
                Button("Od nowa") {
                    index = 0
                    picked = nil
                    hits = 0
                }
                .primaryButton()
            } else {
                let item = items[index]
                Text("Które zdanie jest dobre?").font(.headline)
                Button(item.wrong) { choose(0, item) }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .padding(.horizontal, 12)
                    .background(fill(0, item), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                Button(item.right) { choose(1, item) }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .padding(.horizontal, 12)
                    .background(fill(1, item), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                if picked != nil {
                    Text(item.why).foregroundStyle(Theme.text2)
                    Button("Posłuchaj poprawnego") { Talk.de(item.right) }
                        .ghostButton()
                    Button("Dalej") {
                        index += 1
                        picked = nil
                    }
                    .primaryButton()
                }
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Błędy")
        .containerBackground(for: .navigation) { NightGlow() }
    }

    private func choose(_ i: Int, _ item: FixItem) {
        guard picked == nil else { return }
        picked = i
        if i == 1 {
            hits += 1
            UserDefaults.standard.set(LearningStore.dayKey(), forKey: "didFixDay")
            Talk.de(item.right)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func fill(_ i: Int, _ item: FixItem) -> Color {
        guard let picked else { return Theme.card }
        if i == 1 { return Theme.ok.opacity(0.75) }
        if i == picked { return Color(hex: "FF453A").opacity(0.75) }
        return Theme.card
    }
}

struct DictationView: View {
    private let lines: [(de: String, pl: String)] = [
        ("Ich bin krank.", "Jestem chory."),
        ("Ich habe heute Frühschicht.", "Mam dziś poranną zmianę."),
        ("Der Chef ist noch nicht da.", "Szefa jeszcze nie ma."),
        ("Ich brauche eine Pause.", "Potrzebuję przerwy."),
        ("Können Sie das bitte wiederholen?", "Może pan to powtórzyć?")
    ]
    @State private var index = 0
    @State private var input = ""
    @State private var note = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Posłuchaj zdania i zapisz je po niemiecku.")
                .font(.subheadline)
                .foregroundStyle(Theme.text2)
            Text("\(index + 1) z \(lines.count)")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            VoiceControls(text: lines[index].de)
            Button("Odtwórz dyktando") { Talk.de(lines[index].de) }
                .primaryButton()
            PaceButtons()
            GenderButtons()
            TextField("Zapisz, co usłyszałeś", text: $input, axis: .vertical)
                .lineLimit(2...4)
                .padding(12)
                .themedCard(radius: 16)
            Button("Sprawdź") { check() }
                .primaryButton()
            if !note.isEmpty {
                Text(note).font(.headline)
                Text(lines[index].pl).foregroundStyle(Theme.text2)
            }
            if index + 1 < lines.count, note.hasPrefix("Dobrze") {
                Button("Następne") {
                    index += 1
                    input = ""
                    note = ""
                    Talk.de(lines[index].de)
                }
                .ghostButton()
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Dyktando")
        .containerBackground(for: .navigation) { NightGlow() }
        .onAppear { Talk.de(lines[0].de) }
        .onDisappear { Talk.stop() }
    }

    private func check() {
        let heard = input.lowercased().filter { $0.isLetter || $0.isNumber || $0 == " " }
        let wanted = lines[index].de.lowercased().filter { $0.isLetter || $0.isNumber || $0 == " " }
        if heard.split(separator: " ").joined(separator: " ") == wanted.split(separator: " ").joined(separator: " ") {
            note = "Dobrze."
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            note = "Jeszcze nie. Poprawnie: \(lines[index].de)"
            Talk.de(lines[index].de)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
