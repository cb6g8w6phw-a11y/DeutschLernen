import SwiftUI

enum PracticeData {
    static let quick: [Scenario] = [
        Scenario(id: "wynajem", title: "Wynajem mieszkania", role: "wynajmujący",
                 task: "Oglądasz pokój. Pytasz o czynsz, kaucję i kiedy możesz się wprowadzić.",
                 opener: "Der Raum ist frei ab nächstem Monat. Was möchten Sie wissen?"),
        Scenario(id: "lekarz-szybko", title: "Kontakt z lekarzem", role: "rejestracja",
                 task: "Chcesz wizytę dziś albo jutro, bo boli cię gardło i potrzebujesz zwolnienia.",
                 opener: "Praxis Dr. Klein, guten Tag. Wie kann ich Ihnen helfen?"),
        Scenario(id: "zakupy", title: "Zakupy spożywcze", role: "kasjer",
                 task: "Przy kasie brakuje ci drobnych. Pytasz, czy możesz zapłacić kartą, i prosisz o torbę.",
                 opener: "Zusammen oder getrennt? Haben Sie eine Karte?"),
        Scenario(id: "sasiad", title: "Rozmowa z sąsiadem", role: "sąsiad",
                 task: "Muzyka jest za głośno po 22. Poproś spokojnie, żeby ją ściszył.",
                 opener: "Oh, hallo. Ist die Musik zu laut?")
    ]

    struct Item: Identifiable, Hashable {
        var id: String
        var title: String
        var launch: TalkLaunch
    }

    struct Group: Identifiable {
        var id: String
        var title: String
        var symbol: String
        var tint: Color
        var items: [Item]
    }

    static let groups: [Group] = [
        Group(id: "zycie", title: "Styl życia", symbol: "fork.knife", tint: .white, items: [
            talk("restauracja", "Restauracja", "Jesteś kelnerem w restauracji.", "Guten Abend. Haben Sie reserviert?", "Dobry wieczór. Ma pan rezerwację?", "Ja, einen Tisch für zwei, bitte."),
            talk("kawa", "Kawiarnia", "Jesteś baristą.", "Was darf es sein?", "Co podać?", "Einen Kaffee zum Mitnehmen, bitte."),
            talk("fryzjer", "Fryzjer", "Jesteś fryzjerem.", "Was machen wir heute?", "Co dzisiaj robimy?", "Nur die Spitzen schneiden, bitte.")
        ]),
        Group(id: "kultura", title: "Sztuka i kultura", symbol: "theatermasks", tint: .white, items: [
            talk("kino", "Kino", "Sprzedajesz bilety do kina.", "Welchen Film möchten Sie sehen?", "Jaki film chce pan zobaczyć?", "Zwei Karten für den Film um acht, bitte."),
            talk("muzeum", "Muzeum", "Jesteś w kasie muzeum.", "Einmalig oder die Jahreskarte?", "Jednorazowo czy karnet?", "Einmalig, bitte. Gibt es eine Ermäßigung?"),
            talk("swieta", "Święta", "Jesteś sąsiadem na spotkaniu świątecznym.", "Frohe Weihnachten! Bleiben Sie zum Essen?", "Wesołych świąt! Zostaje pan na jedzenie?", "Danke, gerne. Kann ich etwas mitbringen?")
        ]),
        Group(id: "ruch", title: "Aktywny tryb życia", symbol: "figure.run", tint: .white, items: [
            talk("silownia", "Siłownia", "Jesteś recepcjonistą na siłowni.", "Haben Sie schon einen Vertrag?", "Ma pan już umowę?", "Nein, ich möchte eine Probestunde."),
            talk("bieganie", "Bieganie", "Jesteś kolegą na bieżni.", "Wie viele Kilometer läufst du heute?", "Ile kilometrów dzisiaj biegasz?", "Ich laufe heute fünf Kilometer."),
            talk("rower", "Rower", "Jesteś w serwisie rowerowym.", "Was ist mit dem Rad?", "Co z rowerem?", "Die Schaltung springt. Können Sie das heute noch machen?")
        ]),
        Group(id: "media", title: "Rozrywka", symbol: "tv.fill", tint: .white, items: [
            talk("film", "Film w domu", "Jesteś współlokatorem.", "Welchen Film schauen wir?", "Jaki film oglądamy?", "Etwas Kurzes, ich muss morgen früh raus."),
            talk("mecz", "Mecz", "Jesteś kolegą przed meczem.", "Gehst du heute zum Spiel?", "Idziesz dzisiaj na mecz?", "Ja, aber ich muss um zehn zu Hause sein."),
            talk("muzyka", "Koncert", "Sprzedajesz bilety.", "Stehplatz oder Sitzplatz?", "Miejsca stojące czy siedzące?", "Zwei Stehplätze, bitte.")
        ]),
        Group(id: "praca", title: "Produktywność", symbol: "briefcase", tint: .white, items: [
            talk("praca", "Komunikacja w pracy", "Jesteś kierownikiem zmiany.", "Hast du den Auftrag verstanden?", "Rozumiesz zlecenie?", "Ja. Ich fange mit der linken Seite an."),
            talk("mail", "Mail do szefa", "Jesteś szefem i właśnie dostałeś wiadomość.", "Ich habe deine Nachricht gelesen. Was genau fehlt?", "Przeczytałem wiadomość. Czego dokładnie brakuje?", "Uns fehlt Material für heute."),
            talk("spotkanie", "Spotkanie", "Prowadzisz krótkie spotkanie zespołu.", "Was steht heute an?", "Co jest dzisiaj do zrobienia?", "Zuerst die Lieferung, dann die Montage.")
        ])
    ]

    static let modes: [(String, String, String, Color, TalkLaunch)] = [
        ("Dyskusja", "bubble.left.and.bubble.right.fill", "dyskusja", .white,
         TalkLaunch(id: "dyskusja", title: "Dyskusja", who: "Prowadzisz luźną rozmowę po niemiecku o dniu ucznia. Jedno pytanie na raz.", de: "Worüber willst du heute reden?", pl: "O czym chcesz dziś pogadać?", say: "Über die Arbeit und den Feierabend.")),
        ("Odgrywanie ról", "theatermasks.fill", "rola", .white,
         TalkLaunch(id: "rola", title: "Odgrywanie ról", who: "Grasz rolę kierownika. Uczeń ma powiedzieć, że się spóźni.", de: "Wo bleiben Sie? Die Schicht hat schon angefangen.", pl: "Gdzie pan jest? Zmiana już się zaczęła.", say: "Entschuldigung, der Bus kam nicht. Ich bin in zwanzig Minuten da.")),
        ("Debata", "hammer.fill", "debata", .white,
         TalkLaunch(id: "debata", title: "Debata", who: "Bronisz tezy, że zmiana powinna zaczynać się o szóstej. Uczeń może się nie zgodzić. Krótko, bez wykładu.", de: "Ich finde, wir sollten um sechs anfangen. Was meinst du?", pl: "Uważam, że powinniśmy zaczynać o szóstej. Co ty na to?", say: "Um sechs ist mir zu früh. Um sieben wäre besser.")),
        ("Wywiad", "person.crop.rectangle", "wywiad", .white,
         TalkLaunch(id: "wywiad", title: "Wywiad", who: "Jesteś rekruterem w magazynie. Pytasz o doświadczenie, zmianę i kiedy może zacząć.", de: "Erzählen Sie kurz: Wo haben Sie schon gearbeitet?", pl: "Proszę krótko: gdzie pan już pracował?", say: "Ich habe im Lager und auf der Baustelle gearbeitet."))
    ]

    private static func talk(_ id: String, _ title: String, _ who: String, _ de: String, _ pl: String, _ say: String) -> Item {
        Item(id: id, title: title, launch: TalkLaunch(id: id, title: title, who: who, de: de, pl: pl, say: say))
    }
}

struct PracticeSlot: Codable, Identifiable, Equatable {
    var id: String
    var onHome: Bool
}

struct PracticeView: View {
    @EnvironmentObject var store: LearningStore
    @State private var streak = false
    @State private var arranging = false
    @State private var slots: [PracticeSlot] = PracticeLayout.load()

    private var home: [PracticeSlot] { slots.filter(\.onHome) }
    private var rest: [PracticeSlot] { slots.filter { !$0.onHome } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Ćwicz")
                            .font(.largeTitle.bold())
                        Spacer()
                        Button { arranging = true } label: {
                            Text("Kafelki")
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 14)
                                .frame(minHeight: 36)
                        }
                        .buttonStyle(.glass)
                        Button { streak = true } label: { streakPill }
                            .buttonStyle(.plain)
                    }
                    Text("Na wierzchu tylko to, czego używasz. Reszta jest niżej.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.text2)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(home) { slot in
                            practiceLink(slot.id)
                        }
                    }
                    if !rest.isEmpty {
                        Text("Reszta")
                            .font(.headline)
                        VStack(spacing: 8) {
                            ForEach(rest) { slot in
                                practiceLink(slot.id, wide: true)
                            }
                        }
                    }
                    NavigationLink {
                        PracticeMore()
                    } label: {
                        HStack {
                            Text("Scenariusze: restauracja, praca, kultura")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(Theme.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
            .toolbar(.hidden, for: .navigationBar)
            .containerBackground(for: .navigation) { NightGlow() }
            .sheet(isPresented: $streak) { StreakSheet() }
            .sheet(isPresented: $arranging) {
                ArrangeTiles(slots: $slots)
            }
            .onChange(of: slots) { _, next in PracticeLayout.save(next) }
        }
    }

    private var streakPill: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
            Text("\(max(store.streak, 1))")
        }
        .font(.headline)
        .foregroundStyle(Theme.orange)
        .padding(.horizontal, 12)
        .frame(minHeight: 44)
        .background(Theme.card, in: Capsule())
    }

    @ViewBuilder
    private func practiceLink(_ id: String, wide: Bool = false) -> some View {
        let meta = PracticeLayout.meta(id)
        NavigationLink { PracticeLayout.destination(id) } label: {
            HStack(spacing: 8) {
                Image(systemName: meta.symbol)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 22)
                Text(meta.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)
                if wide { Spacer(minLength: 0) }
            }
            .frame(maxWidth: .infinity, minHeight: wide ? 44 : 64, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .buttonStyle(.glass)
    }
}

enum PracticeLayout {
    static let seed: [PracticeSlot] = [
        PracticeSlot(id: "rozmowa", onHome: true),
        PracticeSlot(id: "zycie", onHome: true),
        PracticeSlot(id: "pisanie", onHome: true),
        PracticeSlot(id: "lekarz", onHome: true),
        PracticeSlot(id: "praca", onHome: true),
        PracticeSlot(id: "wiadomosci", onHome: false),
        PracticeSlot(id: "rola", onHome: false),
        PracticeSlot(id: "dyskusja", onHome: false),
        PracticeSlot(id: "wynajem", onHome: false),
        PracticeSlot(id: "zakupy", onHome: false),
        PracticeSlot(id: "sasiad", onHome: false)
    ]

    static func load() -> [PracticeSlot] {
        let known = Set(seed.map(\.id))
        guard let data = UserDefaults.standard.data(forKey: "practiceLayout"),
              let saved = try? JSONDecoder().decode([PracticeSlot].self, from: data) else { return seed }
        var rows = saved.filter { known.contains($0.id) }
        for item in seed where !rows.contains(where: { $0.id == item.id }) {
            rows.append(item)
        }
        return rows
    }

    static func save(_ slots: [PracticeSlot]) {
        if let data = try? JSONEncoder().encode(slots) {
            UserDefaults.standard.set(data, forKey: "practiceLayout")
        }
    }

    static func meta(_ id: String) -> (title: String, symbol: String) {
        switch id {
        case "rozmowa": return ("Rozmowa", "mic.fill")
        case "zycie": return ("Z życia", "plus.circle.fill")
        case "pisanie": return ("Pisanie", "square.and.pencil")
        case "lekarz": return ("Lekarz", "cross.case.fill")
        case "praca": return ("Praca", "briefcase.fill")
        case "wiadomosci": return ("Wiadomości", "newspaper")
        case "rola": return ("Rola", "theatermasks")
        case "dyskusja": return ("Dyskusja", "bubble.left.and.bubble.right")
        case "wynajem": return ("Wynajem", "house.fill")
        case "zakupy": return ("Zakupy", "cart.fill")
        case "sasiad": return ("Sąsiad", "person.2.fill")
        default: return (id, "circle")
        }
    }

    @ViewBuilder
    static func destination(_ id: String) -> some View {
        switch id {
        case "zycie":
            CaptureView()
        case "pisanie":
            WriteLearnView()
        case "wiadomosci":
            NewsListView()
        case "lekarz":
            SceneChatView(scenario: PracticeData.quick[1])
        case "wynajem":
            SceneChatView(scenario: PracticeData.quick[0])
        case "zakupy":
            SceneChatView(scenario: PracticeData.quick[2])
        case "sasiad":
            SceneChatView(scenario: PracticeData.quick[3])
        case "praca":
            TutorView(launch: PracticeData.groups[4].items[0].launch)
        case "rola":
            TutorView(launch: PracticeData.modes[1].4)
        case "dyskusja":
            TutorView(launch: PracticeData.modes[0].4)
        default:
            TutorView(launch: TalkLaunch(
                id: "wolna",
                title: "Swobodna rozmowa",
                who: "Gadasz swobodnie po niemiecku. Jedno pytanie na raz.",
                de: "Na, worüber hast du Lust zu reden?",
                pl: "No, o czym masz ochotę pogadać?",
                say: "Über meinen Tag auf der Arbeit."
            ))
        }
    }
}

struct ArrangeTiles: View {
    @Binding var slots: [PracticeSlot]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(slots) { slot in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(PracticeLayout.meta(slot.id).title)
                            Text(slot.onHome ? "Na głównej" : "W reszcie")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(slot.onHome ? "Schowaj" : "Na główną") { toggle(slot.id) }
                            .font(.caption.weight(.semibold))
                    }
                }
                .onMove(perform: move)
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("Ułóż kafelki")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func move(_ source: IndexSet, _ destination: Int) {
        slots.move(fromOffsets: source, toOffset: destination)
    }

    private func toggle(_ id: String) {
        guard let index = slots.firstIndex(where: { $0.id == id }) else { return }
        if slots[index].onHome, slots.filter(\.onHome).count <= 2 { return }
        slots[index].onHome.toggle()
    }
}

struct PracticeMore: View {
    var body: some View {
        List {
            Section("Szybkie") {
                ForEach(PracticeData.quick) { scene in
                    NavigationLink(scene.title) { SceneChatView(scenario: scene) }
                }
            }
            ForEach(PracticeData.groups) { group in
                Section(group.title) {
                    ForEach(group.items) { item in
                        NavigationLink(item.title) { TutorView(launch: item.launch) }
                    }
                }
            }
        }
        .navigationTitle("Scenariusze")
        .scrollContentBackground(.hidden)
        .containerBackground(for: .navigation) { NightGlow() }
    }
}


struct ActivityList: View {
    let group: PracticeData.Group

    var body: some View {
        List(group.items) { item in
            NavigationLink {
                TutorView(launch: item.launch)
            } label: {
                Text(item.title).frame(minHeight: 44)
            }
        }
        .navigationTitle(group.title)
        .scrollContentBackground(.hidden)
        .containerBackground(for: .navigation) { NightGlow() }
    }
}

struct MoreTools: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                link("Mini dialogi", "bubble.left.and.bubble.right.fill") { SceneLibraryView() }
                link("Teksty i historie", "book.closed.fill") { TextLibraryView() }
                link("Wzorce gramatyczne", "text.book.closed.fill") { GrammarLibraryView() }
                link("Praca", "helmet") { WorkHubView() }
                link("Postępy", "chart.bar.fill") { StatsView() }
                link("Słówka", "rectangle.stack.fill") { StudyView() }
                link("Gramatyka", "textformat") { GrammarView() }
                link("Pisanie", "square.and.pencil") { WriteLearnView() }
                link("Zeszyt", "book.closed") { NotebookView() }
                link("Egzamin", "checkmark.seal") { ExamView() }
                link("Błędy, 8 najczęstszych", "exclamationmark.bubble") { MistakeReview() }
                link("Wymowa", "waveform") { PronounceView() }
                link("Całe zwroty", "text.bubble") { PhraseView() }
                link("Myślenie po niemiecku", "brain") { ThinkView() }
                link("Opisz obrazek", "photo") { PictureTalk() }
                link("Shadowing", "ear") { ShadowView() }
                link("Jak mówią", "quote.bubble") { StreetView() }
                link("Dyktando", "pencil.line") { DictationView() }
                link("Gry", "gamecontroller") { GamesHome() }
                link("Wiadomości", "newspaper") { NewsListView() }
                link("Z życia", "plus.circle.fill") { CaptureView() }
                link("Plan dnia", "calendar") { DayPlanView() }
                link("Offline", "arrow.down.circle") { OfflineView() }
                link("Ratunek", "exclamationmark.bubble") { RescueView() }
                NavigationLink { CourseView() } label: { row("Ścieżka lekcji", "point.topleft.down.curvedto.point.bottomright.scurvepath") }
                    .buttonStyle(.plain)
            }
            .padding(20)
        }
        .navigationTitle("Więcej")
        .containerBackground(for: .navigation) { NightGlow() }
    }

    private func link<Dest: View>(_ title: String, _ icon: String, @ViewBuilder dest: () -> Dest) -> some View {
        NavigationLink { dest() } label: { row(title, icon) }
            .buttonStyle(.plain)
    }

    private func row(_ title: String, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundStyle(Theme.accent).frame(width: 24)
            Text(title).font(.body.weight(.semibold)).foregroundStyle(Theme.text)
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
        }
        .padding(14)
        .themedCard(radius: 16)
    }
}

struct ProfileView: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("band") private var band = "A1"
    @State private var streak = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    NavigationLink {
                        PlanView()
                    } label: {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Plan nauki").font(.title3.bold())
                                Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
                            }
                            HStack(spacing: 16) {
                                label(icon: "flag.fill", title: "Niemiecki", text: band == "oba" ? "A1–A2" : band, tint: Theme.orange)
                                label(icon: "house.fill", title: "Życie i praca", text: "Codzienność", tint: Theme.ok)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .themedCard()
                    }
                    .buttonStyle(.plain)
                    Button { streak = true } label: { weekCard }
                        .buttonStyle(.plain)
                    NavigationLink {
                        TutorView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Mój tutor").font(.title3.bold())
                                    Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
                                }
                                Text("Marek").font(.body)
                                Text("Praca i codzienność").font(.subheadline).foregroundStyle(Theme.text2)
                            }
                            Spacer()
                            TutorAvatar(size: 84)
                        }
                        .padding(16)
                        .themedCard()
                    }
                    .buttonStyle(.plain)
                    ShareLink(item: "Uczę się niemieckiego do pracy i codzienności.") {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .frame(width: 44, height: 44)
                                .background(Theme.accent, in: Circle())
                            VStack(alignment: .leading) {
                                Text("Zaproś znajomego").font(.headline)
                                Text("Uczcie się razem").font(.caption).foregroundStyle(Theme.text2)
                            }
                            Spacer()
                        }
                        .foregroundStyle(Theme.text)
                        .padding(14)
                        .themedCard()
                    }
                    NavigationLink {
                        MoreTools()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Więcej").font(.headline)
                                Text("Postępy, pisanie, egzamin, offline i reszta")
                                    .font(.caption)
                                    .foregroundStyle(Theme.text2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
                        }
                        .foregroundStyle(Theme.text)
                        .padding(14)
                        .themedCard()
                    }
                    .buttonStyle(.plain)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ukończone sesje  \(doneCount)")
                            .font(.title3.bold())
                        if done.isEmpty {
                            Text("Jak skończysz lekcję albo scenę, pojawi się tutaj.")
                                .font(.subheadline)
                                .foregroundStyle(Theme.text2)
                        }
                        ForEach(done, id: \.title) { row in
                            HStack {
                                Image(systemName: row.icon)
                                    .frame(width: 40, height: 40)
                                    .background(Theme.accent, in: Circle())
                                VStack(alignment: .leading) {
                                    Text(row.title).font(.body.weight(.semibold))
                                    Text(row.kind).font(.caption).foregroundStyle(Theme.text2)
                                }
                                Spacer()
                                Text("Dziś").font(.caption).foregroundStyle(Theme.text2)
                            }
                        }
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Text("Ustawienia i klucz").frame(minHeight: 44)
                        }
                    }
                    .padding(16)
                    .themedCard()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .containerBackground(for: .navigation) { NightGlow() }
            .sheet(isPresented: $streak) { StreakSheet() }
        }
    }

    private var doneCount: Int { done.count }

    private var done: [(title: String, kind: String, icon: String)] {
        var rows: [(String, String, String)] = []
        if store.reviewsToday > 0 {
            rows.append(("Powtórki słówek", "Lekcja", "rectangle.stack.fill"))
        }
        if store.journal.listenTries > 0 {
            rows.append(("Słuchanie", "Lekcja", "ear.fill"))
        }
        for id in store.journal.scenes {
            let title = Scenarios.all.first { $0.id == id }?.title
                ?? PracticeData.quick.first { $0.id == id }?.title
                ?? id
            rows.append((title, "Scena", "person.2.fill"))
        }
        return rows
    }

    private var weekCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Seria").font(.title3.bold())
                Image(systemName: "chevron.right").foregroundStyle(Theme.text2)
            }
            HStack {
                ForEach(Week.days(store), id: \.label) { day in
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(day.done ? Theme.orange : Theme.track)
                                .frame(width: 32, height: 32)
                            if day.done {
                                Image(systemName: "checkmark")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                        }
                        Text(day.label)
                            .font(.caption2)
                            .foregroundStyle(day.today ? Theme.orange : Theme.text2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AKTUALNA PASSA").font(.caption2).foregroundStyle(Theme.text2)
                    Label("\(store.streak) \(store.streak == 1 ? "dzień" : "dni")", systemImage: "flame.fill")
                        .foregroundStyle(Theme.orange)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text("NAJLEPSZA SERIA").font(.caption2).foregroundStyle(Theme.text2)
                    Label("\(max(store.journal.bestStreak, store.streak)) \(max(store.journal.bestStreak, store.streak) == 1 ? "dzień" : "dni")", systemImage: "flame.fill")
                        .foregroundStyle(Theme.orange)
                }
            }
        }
        .padding(16)
        .themedCard()
    }

    private func label(icon: String, title: String, text: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.2), in: Circle())
            VStack(alignment: .leading) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(text).font(.caption).foregroundStyle(Theme.text2)
            }
        }
    }
}

struct PlanView: View {
    @AppStorage("band") private var band = "A1"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Niemiecki do pracy i codzienności.")
                .font(.body)
                .foregroundStyle(Theme.text2)
            Picker("Poziom", selection: $band) {
                Text("A1").tag("A1")
                Text("A2").tag("A2")
                Text("A1–A2").tag("oba")
                Text("B1").tag("B1")
                Text("B2").tag("B2")
            }
            .pickerStyle(.menu)
            Text("W bazie jest 10 000 najczęstszych słów: A1 1500, A2 2000, B1 3000, B2 3500. Sesja bierze tylko Twój poziom.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Spacer()
        }
        .padding(20)
        .navigationTitle("Plan nauki")
        .containerBackground(for: .navigation) { NightGlow() }
    }
}

enum Week {
    struct Day: Identifiable {
        var id: String { label }
        var label: String
        var done: Bool
        var today: Bool
        var date: Date
    }

    @MainActor
    static func days(_ store: LearningStore) -> [Day] {
        let cal = Calendar.current
        let today = Date()
        let weekday = cal.component(.weekday, from: today)
        let sunday = cal.date(byAdding: .day, value: 1 - weekday, to: cal.startOfDay(for: today)) ?? today
        let labels = ["niedz.", "pon.", "wt.", "śr.", "czw.", "pt.", "sob."]
        return (0..<7).map { offset in
            let date = cal.date(byAdding: .day, value: offset, to: sunday) ?? today
            let key = LearningStore.dayKey(date)
            let done = (store.journal.history[key] ?? 0) > 0 || store.journal.lastActive == key
            return Day(label: labels[offset], done: done, today: cal.isDateInToday(date), date: date)
        }
    }
}

struct StreakSheet: View {
    @EnvironmentObject var store: LearningStore
    @Environment(\.dismiss) private var dismiss
    @State private var month = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Theme.orange.opacity(0.25))
                        .frame(width: 150, height: 150)
                        .blur(radius: 8)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 120))
                        .foregroundStyle(Theme.orange)
                    Text("\(max(store.streak, store.journal.lastActive == LearningStore.dayKey() ? 1 : store.streak))")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(y: 16)
                }
                Text("Seria dni").font(.largeTitle.bold())
                Text(store.journal.lastActive == LearningStore.dayKey() ? "Dzisiejsza passa ukończona" : "Zrób dziś jedną lekcję, żeby przedłużyć serię")
                    .foregroundStyle(Theme.text2)
                HStack {
                    Button { shift(-1) } label: { Image(systemName: "chevron.left").frame(width: 44, height: 44) }
                    Spacer()
                    Text(title).font(.headline)
                    Spacer()
                    Button { shift(1) } label: { Image(systemName: "chevron.right").frame(width: 44, height: 44) }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(["pon.", "wt.", "śr.", "czw.", "pt.", "sob.", "niedz."], id: \.self) { name in
                        Text(name).font(.caption2).foregroundStyle(Theme.text2)
                    }
                    ForEach(cells, id: \.id) { cell in
                        Text(cell.number)
                            .font(.body.weight(.semibold))
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(cell.done ? Theme.orange : Theme.card))
                            .overlay(Circle().stroke(cell.today ? Theme.orange : .clear, lineWidth: 2))
                            .foregroundStyle(cell.number.isEmpty ? .clear : .white)
                    }
                }
                Spacer()
            }
            .padding(20)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").frame(width: 44, height: 44)
                    }
                }
            }
        }
        .presentationDetents([.large])
    }

    private var title: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "LLLL yyyy"
        return f.string(from: month).capitalized
    }

    private struct Cell: Identifiable {
        var id: String
        var number: String
        var done: Bool
        var today: Bool
    }

    private var cells: [Cell] {
        let cal = Calendar(identifier: .gregorian)
        let start = cal.date(from: cal.dateComponents([.year, .month], from: month)) ?? month
        let range = cal.range(of: .day, in: .month, for: start) ?? 1..<31
        let weekday = cal.component(.weekday, from: start)
        let pad = (weekday + 5) % 7
        var out: [Cell] = (0..<pad).map { Cell(id: "p\($0)", number: "", done: false, today: false) }
        for day in range {
            let date = cal.date(byAdding: .day, value: day - 1, to: start) ?? start
            let key = LearningStore.dayKey(date)
            let done = (store.journal.history[key] ?? 0) > 0 || store.journal.lastActive == key
            out.append(Cell(id: key, number: "\(day)", done: done, today: cal.isDateInToday(date)))
        }
        return out
    }

    private func shift(_ delta: Int) {
        month = Calendar.current.date(byAdding: .month, value: delta, to: month) ?? month
    }
}
