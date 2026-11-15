import SwiftUI

private struct Drill: Identifiable {
    let id = UUID()
    let title: String
    let audio: String
    let ask: String
    let options: [String]
    let answer: Int
    let de: String
    let pl: String
}

struct WorkCourseView: View {
    @EnvironmentObject var store: LearningStore
    private let groups: [(String, [Drill])] = [
        ("Polecenia", [
            Drill(title: "Drabina", audio: "Hol bitte die Leiter und bring sie nach hinten.", ask: "Co masz zrobić?", options: ["Przynieś drabinę do tyłu", "Zostaw drabinę", "Idź na przerwę"], answer: 0, de: "Hol bitte die Leiter und bring sie nach hinten.", pl: "Przynieś proszę drabinę i zanieś ją do tyłu."),
            Drill(title: "Koniec", audio: "Ich bin fertig. Was soll ich jetzt machen?", ask: "Które zdanie mówi, że skończyłeś?", options: ["Ich bin fertig.", "Ich komme morgen.", "Das ist die Leiter."], answer: 0, de: "Ich bin fertig. Was soll ich jetzt machen?", pl: "Skończyłem. Co mam teraz zrobić?")
        ]),
        ("Nie rozumiem", [
            Drill(title: "Za szybko", audio: "Können Sie das bitte langsamer sagen?", ask: "Co to za prośba?", options: ["Mów wolniej", "Jestem chory", "Gdzie jest autobus"], answer: 0, de: "Können Sie das bitte langsamer sagen?", pl: "Czy może pan powiedzieć to wolniej?")
        ]),
        ("Godziny i pieniądze", [
            Drill(title: "Wypłata", audio: "Wann kommt das Geld?", ask: "O co pytasz?", options: ["Kiedy będzie wypłata", "Gdzie jest kask", "Czy mogę iść do domu"], answer: 0, de: "Wann kommt das Geld?", pl: "Kiedy będzie wypłata?"),
            Drill(title: "Urlop", audio: "Ich brauche nächste Woche frei.", ask: "Co mówisz?", options: ["Potrzebuję wolnego w przyszłym tygodniu", "Pracuję w sobotę", "Nie mam kasku"], answer: 0, de: "Ich brauche nächste Woche frei.", pl: "Potrzebuję wolnego w przyszłym tygodniu.")
        ]),
        ("Maszyny i bezpieczeństwo", [
            Drill(title: "Kabel", audio: "Pass auf, hier ist ein Kabel.", ask: "Co słyszysz?", options: ["Uważaj, tu jest kabel", "Przerwa jest o dziewiątej", "Przynieś kawę"], answer: 0, de: "Pass auf, hier ist ein Kabel.", pl: "Uważaj, tu jest kabel."),
            Drill(title: "Kask", audio: "Ohne Helm geht hier gar nichts.", ask: "Czego nie wolno?", options: ["Pracy bez kasku", "Przerwy", "Rozmowy z szefem"], answer: 0, de: "Ohne Helm geht hier gar nichts.", pl: "Bez kasku tutaj nic nie da rady.")
        ])
    ]

    var body: some View {
        List {
            ForEach(groups, id: \.0) { name, drills in
                Section(name) {
                    ForEach(drills) { drill in
                        NavigationLink(drill.title) { DrillView(drill: drill) }
                    }
                }
            }
        }
        .navigationTitle("Kurs w pracy")
        .containerBackground(for: .navigation) { Color.black }
    }
}

struct DailySituationsView: View {
    private let groups: [(String, [Drill])] = [
        ("Załatwianie", [
            Drill(title: "Sklep", audio: "Ich möchte das umtauschen. Ich habe den Bon.", ask: "Co chcesz?", options: ["Wymienić towar, masz paragon", "Kupić bilet", "Wezwać lekarza"], answer: 0, de: "Ich möchte das umtauschen. Ich habe den Bon.", pl: "Chcę to wymienić. Mam paragon."),
            Drill(title: "Reklamacja", audio: "Das Gerät geht nicht. Ich möchte es zurückgeben.", ask: "O co chodzi?", options: ["Sprzęt nie działa, chcesz oddać", "Szukasz apteki", "Pytasz o autobus"], answer: 0, de: "Das Gerät geht nicht. Ich möchte es zurückgeben.", pl: "Sprzęt nie działa. Chcę go oddać.")
        ]),
        ("Zdrowie", [
            Drill(title: "Lekarz", audio: "Mir tut der Rücken weh. Ich brauche eine Krankschreibung.", ask: "Czego potrzebujesz?", options: ["Zwolnienia, boli cię plecy", "Nowej opony", "Klucza do mieszkania"], answer: 0, de: "Mir tut der Rücken weh. Ich brauche eine Krankschreibung.", pl: "Boli mnie plecy. Potrzebuję zwolnienia."),
            Drill(title: "Apteka", audio: "Haben Sie etwas gegen Halsschmerzen?", ask: "Czego szukasz?", options: ["Czegoś na ból gardła", "Chleba", "Biletu"], answer: 0, de: "Haben Sie etwas gegen Halsschmerzen?", pl: "Ma pan coś na ból gardła?")
        ]),
        ("Dzień", [
            Drill(title: "Dojazd", audio: "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.", ask: "Co mówisz?", options: ["Autobus się spóźnia, będziesz za 20 minut", "Zostajesz w domu", "Nie masz pracy"], answer: 0, de: "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.", pl: "Autobus ma opóźnienie. Będę za dwadzieścia minut."),
            Drill(title: "Warsztat", audio: "Vorne klopft es, wenn ich über ein Schlagloch fahre.", ask: "Co jest z autem?", options: ["Z przodu stuka na dziurze", "Nie ma paliwa", "Jest nowy"], answer: 0, de: "Vorne klopft es, wenn ich über ein Schlagloch fahre.", pl: "Z przodu stuka, gdy wjadę w dziurę."),
            Drill(title: "Sąsiad", audio: "Können Sie die Musik etwas leiser machen?", ask: "O co prosi?", options: ["Żeby ściszyć muzykę", "Żeby pożyczyć wiertarkę", "Żeby otworzyć okno"], answer: 0, de: "Können Sie die Musik etwas leiser machen?", pl: "Czy może pan trochę ściszyć muzykę?"),
            Drill(title: "Znajomi", audio: "Hast du heute Abend Zeit?", ask: "O co pyta?", options: ["Czy masz czas wieczorem", "Czy jesteś w pracy", "Czy masz kask"], answer: 0, de: "Hast du heute Abend Zeit?", pl: "Masz dziś wieczorem czas?")
        ])
    ]

    var body: some View {
        List {
            ForEach(groups, id: \.0) { name, drills in
                Section(name) {
                    ForEach(drills) { drill in
                        NavigationLink(drill.title) { DrillView(drill: drill) }
                    }
                }
            }
            Section("Reszta narzędzi") {
                NavigationLink("Tematy, SOS i głos") { LifeView() }
            }
        }
        .navigationTitle("Codzienne życie")
        .containerBackground(for: .navigation) { Color.black }
    }
}

private struct DrillView: View {
    @EnvironmentObject var store: LearningStore
    let drill: Drill
    @State private var played = false
    @State private var picked: Int?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(drill.title).font(.largeTitle.bold())
                Button {
                    played = true
                    Talk.de(drill.audio, rate: 0.48)
                } label: {
                    Label(played ? "Odtwórz jeszcze raz" : "Posłuchaj bez tekstu", systemImage: "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(MatteGlassButton())
                if played {
                    Text(drill.ask).font(.title3.bold())
                    ForEach(drill.options.indices, id: \.self) { i in
                        Button(drill.options[i]) {
                            guard picked == nil else { return }
                            picked = i
                            let ok = i == drill.answer
                            store.noteSkill("listen", ok: ok)
                            if !ok { HardBook.add(de: drill.de, pl: drill.pl) }
                        }
                        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.white)
                        .background(color(i), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                if picked != nil {
                    Text(drill.de).font(.title3.bold())
                    Text(drill.pl).foregroundStyle(Theme.text2)
                    Button("Posłuchaj z tekstem") { Talk.de(drill.de, rate: 0.42) }
                        .buttonStyle(.glass)
                }
            }
            .padding(20)
        }
        .navigationTitle(drill.title)
        .containerBackground(for: .navigation) { Color.black }
        .onDisappear { Talk.stop() }
    }

    private func color(_ i: Int) -> Color {
        guard let picked else { return Color.white.opacity(0.08) }
        if i == drill.answer { return Theme.ok.opacity(0.8) }
        if i == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }
}

struct PronounceView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var index = 0
    @State private var parts: [(word: String, ok: Bool)] = []
    @State private var heard = ""

    private let lines = [
        ("Ich habe das nicht verstanden.", "Nie zrozumiałem tego."),
        ("Kannst du das bitte wiederholen?", "Czy możesz to powtórzyć?"),
        ("Ich bin gleich fertig.", "Zaraz skończę."),
        ("Kannst du mir kurz helfen?", "Możesz mi na chwilę pomóc?")
    ]

    private var line: (String, String) { lines[index % lines.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("To nie jest ocena akcentu. Pokazuję tylko słowa, które mikrofon naprawdę rozpoznał.")
                    .foregroundStyle(Theme.text2)
                VoiceSexButtons()
                PaceButtons()
                Text(line.1).font(.headline)
                Text(line.0).font(.title2.bold())
                Button { Talk.de(line.0, rate: 0.42) } label: { Label("Posłuchaj wzoru", systemImage: "speaker.wave.2") }
                    .buttonStyle(.glass)
                Button { mic.toggle() } label: {
                    Label(mic.listening ? "Stop" : "Powiedz to samo", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MatteGlassButton())
                if mic.listening { Text(mic.text.isEmpty ? "Słucham…" : mic.text) }
                if !parts.isEmpty {
                    ForEach(parts.indices, id: \.self) { i in
                        Text(parts[i].ok ? parts[i].word : "nie złapał: \(parts[i].word)")
                            .foregroundStyle(parts[i].ok ? Theme.ok : Theme.bad)
                    }
                    let hit = parts.filter(\.ok).count
                    Text("Mikrofon złapał \(hit) z \(parts.count) słów. Reszta mogła zginąć przez hałas, nie przez język.")
                        .foregroundStyle(Theme.text2)
                    Text("Usłyszałem: \(heard)").font(.footnote).foregroundStyle(Theme.text2)
                }
                Button(index + 1 >= lines.count ? "Od początku" : "Następne zdanie") {
                    mic.stop()
                    parts = []
                    heard = ""
                    index = index + 1 >= lines.count ? 0 : index + 1
                }
                .buttonStyle(.glass)
            }
            .padding(20)
        }
        .navigationTitle("Wymowa")
        .containerBackground(for: .navigation) { Color.black }
        .onChange(of: mic.listening) { was, now in
            guard was, !now else { return }
            heard = mic.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !heard.isEmpty else { return }
            parts = Heard.parts(target: line.0, heard: heard)
            let ok = !parts.isEmpty && parts.allSatisfy(\.ok)
            store.noteSaid(ok: ok)
            if !ok { HardBook.add(de: line.0, pl: line.1) }
        }
        .onDisappear { mic.stop(); Talk.stop() }
    }
}

struct PlacementView: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("placementBand") private var band = ""
    @AppStorage("placementScore") private var score = 0
    @State private var index = 0
    @State private var points = 0
    @State private var picked: Int?

    private let items: [(ask: String, options: [String], answer: Int)] = [
        ("Was soll ich jetzt machen?", ["Co mam teraz zrobić?", "Gdzie jest autobus?", "Jestem chory."], 0),
        ("Der Bus hat Verspätung.", ["Autobus ma opóźnienie.", "Kask jest nowy.", "Chcę kawę."], 0),
        ("Ich brauche eine Krankschreibung.", ["Potrzebuję zwolnienia.", "Idę na przerwę.", "To jest drabina."], 0),
        ("Können Sie das bitte wiederholen?", ["Czy może pan powtórzyć?", "Jestem na budowie.", "Mam na imię Kacper."], 0),
        ("Ohne Helm geht hier gar nichts.", ["Bez kasku nic tu nie da rady.", "Przerwa jest długa.", "Mieszkam obok."], 0),
        ("Ich bin gleich fertig.", ["Zaraz skończę.", "Nie mam czasu wczoraj.", "To jest mój szef."], 0)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if !band.isEmpty && index >= items.count {
                    Text("Test na start: \(band)")
                        .font(.largeTitle.bold())
                    Text("\(score) z \(items.count). To nie jest egzamin państwowy. Poziom na statystykach i tak liczy się z opanowanych słów, nie z tych sześciu pytań.")
                        .foregroundStyle(Theme.text2)
                    Button("Zrób jeszcze raz") {
                        index = 0
                        points = 0
                        picked = nil
                        band = ""
                    }
                    .buttonStyle(.glass)
                } else if index < items.count {
                    Text("\(index + 1) z \(items.count)").font(.footnote).foregroundStyle(Theme.text2)
                    Text(items[index].ask).font(.title2.bold())
                    ForEach(items[index].options.indices, id: \.self) { i in
                        Button(items[index].options[i]) {
                            guard picked == nil else { return }
                            picked = i
                            if i == items[index].answer { points += 1 }
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundStyle(.white)
                        .background(i == picked ? Theme.accent : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    if picked != nil {
                        Button("Dalej") {
                            if index + 1 >= items.count {
                                score = points
                                band = points <= 2 ? "A1" : (points <= 4 ? "A2" : "A2, próg B1")
                                store.noteSkill("vocab", ok: points >= 4)
                            }
                            picked = nil
                            index += 1
                        }
                        .primaryButton()
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Test na start")
        .containerBackground(for: .navigation) { Color.black }
    }
}
