import SwiftUI

struct Drill: Identifiable {
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
            Drill(title: "Drabina", audio: "Hol bitte die Leiter und bring sie nach hinten.", ask: "Co masz zrobić?", options: ["Zanieś drabinę do przodu", "Przynieś drabinę do tyłu", "Zostaw drabinę na dachu"], answer: 1, de: "Hol bitte die Leiter und bring sie nach hinten.", pl: "Przynieś proszę drabinę i zanieś ją do tyłu."),
            Drill(title: "Łopata", audio: "Hol die Schaufel und komm zur Grube.", ask: "Dokąd z łopatą?", options: ["Do wykopu", "Do biura", "Na rampę"], answer: 0, de: "Hol die Schaufel und komm zur Grube.", pl: "Weź łopatę i przyjdź do wykopu."),
            Drill(title: "Wiertarka", audio: "Bring die Bohrmaschine zum Gerüst, nicht in den Keller.", ask: "Gdzie ma być wiertarka?", options: ["W piwnicy", "Na rusztowaniu", "W aucie"], answer: 1, de: "Bring die Bohrmaschine zum Gerüst, nicht in den Keller.", pl: "Zanieś wiertarkę na rusztowanie, nie do piwnicy."),
            Drill(title: "Śruby", audio: "Wir brauchen noch acht Schrauben, nicht vier.", ask: "Ile śrub?", options: ["Cztery", "Osiem", "Dwadzieścia"], answer: 1, de: "Wir brauchen noch acht Schrauben, nicht vier.", pl: "Potrzebujemy jeszcze ośmiu śrub, nie czterech."),
            Drill(title: "Koniec", audio: "Ich bin fertig. Was soll ich jetzt machen?", ask: "Co mówisz na końcu?", options: ["Ich komme morgen.", "Das ist die Leiter.", "Ich bin fertig."], answer: 2, de: "Ich bin fertig. Was soll ich jetzt machen?", pl: "Skończyłem. Co mam teraz zrobić?")
        ]),
        ("Narzędzia", [
            Drill(title: "Młotek", audio: "Der Hammer liegt im Container, Fach zwei.", ask: "Gdzie jest młotek?", options: ["W aucie, półka jeden", "W kontenerze, półka dwa", "Na rusztowaniu"], answer: 1, de: "Der Hammer liegt im Container, Fach zwei.", pl: "Młotek leży w kontenerze, półka dwa."),
            Drill(title: "Poziomica", audio: "Prüf die Wasserwaage, bevor du die Reihe klebst.", ask: "Co najpierw?", options: ["Przykleić rząd", "Sprawdzić poziomicę", "Pomalować ścianę"], answer: 1, de: "Prüf die Wasserwaage, bevor du die Reihe klebst.", pl: "Sprawdź poziomicę, zanim przykleisz rząd."),
            Drill(title: "Akumulator", audio: "Die Bohrmaschine läuft nicht. Der Akku ist leer.", ask: "Czemu wiertarka stoi?", options: ["Brak tarczy", "Pusty akumulator", "Zły kabel"], answer: 1, de: "Die Bohrmaschine läuft nicht. Der Akku ist leer.", pl: "Wiertarka nie działa. Akumulator jest pusty.")
        ]),
        ("Materiały", [
            Drill(title: "Cement", audio: "Wir brauchen noch zehn Sack Zement.", ask: "Ile cementu?", options: ["Dwa worki", "Dziesięć worków", "Jedna paleta piasku"], answer: 1, de: "Wir brauchen noch zehn Sack Zement.", pl: "Potrzebujemy jeszcze dziesięciu worków cementu."),
            Drill(title: "Beton", audio: "Der Beton ist schon zu fest. Nicht mehr gießen.", ask: "Co z betonem?", options: ["Można jeszcze lać", "Jest już za twardy", "Jeszcze nie przyjechał"], answer: 1, de: "Der Beton ist schon zu fest. Nicht mehr gießen.", pl: "Beton jest już za twardy. Nie lać więcej."),
            Drill(title: "Płytki", audio: "Die Fliesen sind die falsche Farbe.", ask: "Co jest nie tak?", options: ["Zły rozmiar", "Zły kolor", "Za mało kleju"], answer: 1, de: "Die Fliesen sind die falsche Farbe.", pl: "Płytki są w złym kolorze.")
        ]),
        ("Wymiary", [
            Drill(title: "Głębokość", audio: "Mach das Loch achtzig Zentimeter tief, nicht sechzig.", ask: "Jak głęboko?", options: ["60 cm", "80 cm", "100 cm"], answer: 1, de: "Mach das Loch achtzig Zentimeter tief, nicht sechzig.", pl: "Zrób dół na osiemdziesiąt centymetrów, nie na sześćdziesiąt."),
            Drill(title: "Odstęp", audio: "Stell die Balken im Abstand von vierzig Zentimetern.", ask: "Co ile belki?", options: ["Co 20 cm", "Co 40 cm", "Co 80 cm"], answer: 1, de: "Stell die Balken im Abstand von vierzig Zentimetern.", pl: "Ustaw belki co czterdzieści centymetrów."),
            Drill(title: "Strona", audio: "Wir fangen links an, dann rechts.", ask: "Od której strony?", options: ["Od prawej", "Od lewej", "Od środka"], answer: 1, de: "Wir fangen links an, dann rechts.", pl: "Zaczynamy z lewej, potem z prawej.")
        ]),
        ("Nie rozumiem", [
            Drill(title: "Za szybko", audio: "Können Sie das bitte langsamer sagen?", ask: "O co prosisz?", options: ["Żeby powtórzył głośniej", "Żeby powiedział wolniej", "Żeby napisał po polsku"], answer: 1, de: "Können Sie das bitte langsamer sagen?", pl: "Czy może pan powiedzieć to wolniej?"),
            Drill(title: "Jeszcze raz", audio: "Ich habe das nicht verstanden. Können Sie das wiederholen?", ask: "Czego nie zrozumiałeś?", options: ["Ostatniego zdania", "Godziny przerwy", "Numeru bramy"], answer: 0, de: "Ich habe das nicht verstanden. Können Sie das wiederholen?", pl: "Nie zrozumiałem. Czy może pan powtórzyć?"),
            Drill(title: "Która strona", audio: "Meinen Sie links oder rechts?", ask: "O co dopytujesz?", options: ["O godzinę", "O stronę", "O narzędzie"], answer: 1, de: "Meinen Sie links oder rechts?", pl: "Ma pan na myśli lewą czy prawą?")
        ]),
        ("Godziny i pieniądze", [
            Drill(title: "Wypłata", audio: "Wann kommt das Geld diesen Monat?", ask: "O co pytasz?", options: ["Kiedy jest przerwa", "Kiedy będzie wypłata", "Kiedy koniec zmiany"], answer: 1, de: "Wann kommt das Geld diesen Monat?", pl: "Kiedy w tym miesiącu będzie wypłata?"),
            Drill(title: "Nadgodziny", audio: "Ich habe zwölf Überstunden, nicht acht.", ask: "Ile nadgodzin zgłaszasz?", options: ["Osiem", "Dziesięć", "Dwanaście"], answer: 2, de: "Ich habe zwölf Überstunden, nicht acht.", pl: "Mam dwanaście nadgodzin, nie osiem."),
            Drill(title: "Urlop", audio: "Ich brauche nächste Woche drei Tage frei.", ask: "Czego potrzebujesz?", options: ["Jednego dnia w tym tygodniu", "Trzech dni w przyszłym tygodniu", "Całego sierpnia"], answer: 1, de: "Ich brauche nächste Woche drei Tage frei.", pl: "W przyszłym tygodniu potrzebuję trzech dni wolnego."),
            Drill(title: "Zmiana", audio: "Die Frühschicht beginnt um sechs, nicht um sieben.", ask: "O której start?", options: ["O szóstej", "O siódmej", "O ósmej"], answer: 0, de: "Die Frühschicht beginnt um sechs, nicht um sieben.", pl: "Poranna zmiana zaczyna się o szóstej, nie o siódmej.")
        ]),
        ("Maszyny i bezpieczeństwo", [
            Drill(title: "Kabel", audio: "Pass auf, hier ist ein offenes Kabel.", ask: "Na co uważać?", options: ["Na mokrą podłogę", "Na odsłonięty kabel", "Na luźną drabinę"], answer: 1, de: "Pass auf, hier ist ein offenes Kabel.", pl: "Uważaj, tu jest odsłonięty kabel."),
            Drill(title: "Kask", audio: "Ohne Helm darfst du nicht aufs Gerüst.", ask: "Czego nie wolno bez kasku?", options: ["Wejść na rusztowanie", "Iść na przerwę", "Jeździć busem"], answer: 0, de: "Ohne Helm darfst du nicht aufs Gerüst.", pl: "Bez kasku nie wolno na rusztowanie."),
            Drill(title: "Wózek", audio: "Fahr nicht mit dem Stapler, wenn die Batterie rot ist.", ask: "Kiedy nie jechać wózkiem?", options: ["Gdy bateria jest zielona", "Gdy bateria jest czerwona", "Gdy jest przerwa"], answer: 1, de: "Fahr nicht mit dem Stapler, wenn die Batterie rot ist.", pl: "Nie jedź wózkiem, gdy bateria jest czerwona."),
            Drill(title: "Szlifierka", audio: "Ohne Brille keine Flex.", ask: "Czego brakuje do szlifierki?", options: ["Rękawic", "Okularów", "Kasku"], answer: 1, de: "Ohne Brille keine Flex.", pl: "Bez okularów nie ma szlifierki."),
            Drill(title: "Brama", audio: "Der Lkw steht an Tor drei. Bitte entladen.", ask: "Przy której bramie?", options: ["Przy bramie dwa", "Przy bramie trzy", "Przy bramie cztery"], answer: 1, de: "Der Lkw steht an Tor drei. Bitte entladen.", pl: "Ciężarówka stoi przy bramie trzy. Rozładuj.")
        ]),
        ("Koniec dnia", [
            Drill(title: "Sprzątanie", audio: "Kehr die Rampe, bevor du gehst.", ask: "Co przed wyjściem?", options: ["Zamknąć biuro", "Zamieść rampę", "Zatankować auto"], answer: 1, de: "Kehr die Rampe, bevor du gehst.", pl: "Zamieć rampę, zanim wyjdziesz."),
            Drill(title: "Jutro", audio: "Morgen machen wir die rechte Seite.", ask: "Co jutro?", options: ["Lewą stronę", "Prawą stronę", "Dach"], answer: 1, de: "Morgen machen wir die rechte Seite.", pl: "Jutro robimy prawą stronę."),
            Drill(title: "Zgłoszenie", audio: "Ich habe das Werkzeug schon zurückgebracht.", ask: "Co z narzędziami?", options: ["Zostały na placu", "Są już oddane", "Leżą w aucie"], answer: 1, de: "Ich habe das Werkzeug schon zurückgebracht.", pl: "Narzędzia już oddałem.")
        ])
    ]

    var body: some View {
        List {
            ForEach(groups, id: \.0) { name, drills in
                let all = drills + WorkListen.more(name)
                Section(name) {
                    NavigationLink("Po kolei, \(all.count) przykładów") { DrillRun(title: name, drills: all) }
                    ForEach(all) { drill in
                        NavigationLink(drill.title) { DrillView(drill: drill) }
                    }
                }
            }
            Section("Dialogi z budowy") {
                ForEach(SiteTalk.topics, id: \.self) { topic in
                    NavigationLink(topic) { SiteTopicView(topic: topic) }
                }
            }
        }
        .navigationTitle("Kurs w pracy")
        .containerBackground(for: .navigation) { Color.black }
    }
}

struct DailySituationsView: View {
    var body: some View {
        List {
            ForEach(LifeListen.groups, id: \.0) { name, topics in
                Section(name) {
                    ForEach(topics, id: \.0) { title, drills in
                        NavigationLink("\(title), \(drills.count) przykładów") { DrillRun(title: title, drills: drills) }
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
    @State private var shown: [String] = []

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
                    ForEach(shown.indices, id: \.self) { i in
                        Button(shown[i]) {
                            guard picked == nil else { return }
                            picked = i
                            let ok = shown[i] == drill.options[drill.answer]
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
        .onAppear { if shown.isEmpty { shown = drill.options.shuffled() } }
        .onDisappear { Talk.stop() }
    }

    private func color(_ i: Int) -> Color {
        guard let picked, shown.indices.contains(i) else { return Color.white.opacity(0.08) }
        if shown[i] == drill.options[drill.answer] { return Theme.ok.opacity(0.8) }
        if i == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
    }
}

private struct DrillRun: View {
    @EnvironmentObject var store: LearningStore
    let title: String
    let drills: [Drill]
    @State private var order: [Int] = []
    @State private var cursor = 0
    @State private var played = false
    @State private var picked: Int?
    @State private var shown: [String] = []

    private var drill: Drill? {
        guard cursor < order.count else { return nil }
        return drills[order[cursor]]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let drill {
                    Text("Przykład \(cursor + 1) z \(order.count)")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
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
                        ForEach(shown.indices, id: \.self) { i in
                            Button(shown[i]) {
                                guard picked == nil else { return }
                                picked = i
                                let ok = shown[i] == drill.options[drill.answer]
                                store.noteSkill("listen", ok: ok)
                                if !ok { HardBook.add(de: drill.de, pl: drill.pl) }
                            }
                            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.white)
                            .background(tone(i, drill), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    if picked != nil {
                        Text(drill.de).font(.title3.bold())
                        Text(drill.pl).foregroundStyle(Theme.text2)
                        Button("Posłuchaj z tekstem") { Talk.de(drill.de, rate: 0.42) }
                            .buttonStyle(.glass)
                        Button(cursor + 1 < order.count ? "Następny przykład" : "Od nowa, inna kolejność") {
                            if cursor + 1 < order.count {
                                cursor += 1
                            } else {
                                order.shuffle()
                                cursor = 0
                            }
                            layout()
                        }
                        .primaryButton()
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle(title)
        .containerBackground(for: .navigation) { Color.black }
        .onAppear {
            if order.isEmpty {
                order = Array(drills.indices).shuffled()
                layout()
            }
        }
        .onDisappear { Talk.stop() }
    }

    private func layout() {
        played = false
        picked = nil
        shown = drill?.options.shuffled() ?? []
    }

    private func tone(_ i: Int, _ drill: Drill) -> Color {
        guard let picked, shown.indices.contains(i) else { return Color.white.opacity(0.08) }
        if shown[i] == drill.options[drill.answer] { return Theme.ok.opacity(0.8) }
        if i == picked { return Theme.bad.opacity(0.8) }
        return Color.white.opacity(0.08)
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
                        .background(tone(i), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    if let picked, picked != items[index].answer {
                        VocabHintCard(card: .line(items[index].ask, items[index].options[items[index].answer]))
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

    private func tone(_ i: Int) -> Color {
        guard let picked else { return Color.white.opacity(0.08) }
        if i == items[index].answer { return Theme.ok.opacity(0.85) }
        if i == picked { return Theme.bad.opacity(0.75) }
        return Color.white.opacity(0.08)
    }
}
