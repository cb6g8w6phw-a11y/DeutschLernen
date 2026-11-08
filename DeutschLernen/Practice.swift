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
        Group(id: "zycie", title: "Styl życia", symbol: "fork.knife", tint: Color(hex: "FF9A62"), items: [
            talk("restauracja", "Restauracja", "Jesteś kelnerem w restauracji.", "Guten Abend. Haben Sie reserviert?", "Dobry wieczór. Ma pan rezerwację?", "Ja, einen Tisch für zwei, bitte."),
            talk("kawa", "Kawiarnia", "Jesteś baristą.", "Was darf es sein?", "Co podać?", "Einen Kaffee zum Mitnehmen, bitte."),
            talk("fryzjer", "Fryzjer", "Jesteś fryzjerem.", "Was machen wir heute?", "Co dzisiaj robimy?", "Nur die Spitzen schneiden, bitte.")
        ]),
        Group(id: "kultura", title: "Sztuka i kultura", symbol: "theatermasks", tint: Color(hex: "8B6CF0"), items: [
            talk("kino", "Kino", "Sprzedajesz bilety do kina.", "Welchen Film möchten Sie sehen?", "Jaki film chce pan zobaczyć?", "Zwei Karten für den Film um acht, bitte."),
            talk("muzeum", "Muzeum", "Jesteś w kasie muzeum.", "Einmalig oder die Jahreskarte?", "Jednorazowo czy karnet?", "Einmalig, bitte. Gibt es eine Ermäßigung?"),
            talk("swieta", "Święta", "Jesteś sąsiadem na spotkaniu świątecznym.", "Frohe Weihnachten! Bleiben Sie zum Essen?", "Wesołych świąt! Zostaje pan na jedzenie?", "Danke, gerne. Kann ich etwas mitbringen?")
        ]),
        Group(id: "ruch", title: "Aktywny tryb życia", symbol: "figure.run", tint: Color(hex: "34C759"), items: [
            talk("silownia", "Siłownia", "Jesteś recepcjonistą na siłowni.", "Haben Sie schon einen Vertrag?", "Ma pan już umowę?", "Nein, ich möchte eine Probestunde."),
            talk("bieganie", "Bieganie", "Jesteś kolegą na bieżni.", "Wie viele Kilometer läufst du heute?", "Ile kilometrów dzisiaj biegasz?", "Ich laufe heute fünf Kilometer."),
            talk("rower", "Rower", "Jesteś w serwisie rowerowym.", "Was ist mit dem Rad?", "Co z rowerem?", "Die Schaltung springt. Können Sie das heute noch machen?")
        ]),
        Group(id: "media", title: "Rozrywka", symbol: "tv.fill", tint: Color(hex: "FF6B9A"), items: [
            talk("film", "Film w domu", "Jesteś współlokatorem.", "Welchen Film schauen wir?", "Jaki film oglądamy?", "Etwas Kurzes, ich muss morgen früh raus."),
            talk("mecz", "Mecz", "Jesteś kolegą przed meczem.", "Gehst du heute zum Spiel?", "Idziesz dzisiaj na mecz?", "Ja, aber ich muss um zehn zu Hause sein."),
            talk("muzyka", "Koncert", "Sprzedajesz bilety.", "Stehplatz oder Sitzplatz?", "Miejsca stojące czy siedzące?", "Zwei Stehplätze, bitte.")
        ]),
        Group(id: "praca", title: "Produktywność", symbol: "briefcase", tint: Color(hex: "5AC8FA"), items: [
            talk("praca", "Komunikacja w pracy", "Jesteś kierownikiem zmiany.", "Hast du den Auftrag verstanden?", "Rozumiesz zlecenie?", "Ja. Ich fange mit der linken Seite an."),
            talk("mail", "Mail do szefa", "Jesteś szefem i właśnie dostałeś wiadomość.", "Ich habe deine Nachricht gelesen. Was genau fehlt?", "Przeczytałem wiadomość. Czego dokładnie brakuje?", "Uns fehlt Material für heute."),
            talk("spotkanie", "Spotkanie", "Prowadzisz krótkie spotkanie zespołu.", "Was steht heute an?", "Co jest dzisiaj do zrobienia?", "Zuerst die Lieferung, dann die Montage.")
        ])
    ]

    static let modes: [(String, String, String, Color, TalkLaunch)] = [
        ("Dyskusja", "bubble.left.and.bubble.right.fill", "dyskusja", Color(hex: "8B6CF0"),
         TalkLaunch(id: "dyskusja", title: "Dyskusja", who: "Prowadzisz luźną rozmowę po niemiecku o dniu ucznia. Jedno pytanie na raz.", de: "Worüber willst du heute reden?", pl: "O czym chcesz dziś pogadać?", say: "Über die Arbeit und den Feierabend.")),
        ("Odgrywanie ról", "theatermasks.fill", "rola", Color(hex: "FF9A62"),
         TalkLaunch(id: "rola", title: "Odgrywanie ról", who: "Grasz rolę kierownika. Uczeń ma powiedzieć, że się spóźni.", de: "Wo bleiben Sie? Die Schicht hat schon angefangen.", pl: "Gdzie pan jest? Zmiana już się zaczęła.", say: "Entschuldigung, der Bus kam nicht. Ich bin in zwanzig Minuten da.")),
        ("Debata", "hammer.fill", "debata", Color(hex: "FF453A"),
         TalkLaunch(id: "debata", title: "Debata", who: "Bronisz tezy, że zmiana powinna zaczynać się o szóstej. Uczeń może się nie zgodzić. Krótko, bez wykładu.", de: "Ich finde, wir sollten um sechs anfangen. Was meinst du?", pl: "Uważam, że powinniśmy zaczynać o szóstej. Co ty na to?", say: "Um sechs ist mir zu früh. Um sieben wäre besser.")),
        ("Wywiad", "person.crop.rectangle", "wywiad", Color(hex: "5AC8FA"),
         TalkLaunch(id: "wywiad", title: "Wywiad", who: "Jesteś rekruterem w magazynie. Pytasz o doświadczenie, zmianę i kiedy może zacząć.", de: "Erzählen Sie kurz: Wo haben Sie schon gearbeitet?", pl: "Proszę krótko: gdzie pan już pracował?", say: "Ich habe im Lager und auf der Baustelle gearbeitet."))
    ]

    private static func talk(_ id: String, _ title: String, _ who: String, _ de: String, _ pl: String, _ say: String) -> Item {
        Item(id: id, title: title, launch: TalkLaunch(id: id, title: title, who: who, de: de, pl: pl, say: say))
    }
}

struct PracticeView: View {
    @EnvironmentObject var store: LearningStore
    @State private var streak = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        Text("Ćwicz")
                            .font(.largeTitle.bold())
                        Spacer()
                        Button { streak = true } label: { streakPill }
                    }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                        ForEach(PracticeData.modes, id: \.2) { mode in
                            NavigationLink {
                                TutorView(launch: mode.4)
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: mode.1)
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .frame(width: 64, height: 64)
                                        .background(mode.3.opacity(0.9), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    Text(mode.0)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(Theme.text)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .frame(height: 32)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Text("Szybkie scenariusze")
                        .font(.title3.bold())
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(PracticeData.quick) { scene in
                            NavigationLink {
                                SceneChatView(scenario: scene)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: icon(scene.id))
                                    Text(scene.title)
                                        .font(.subheadline.weight(.semibold))
                                        .lineLimit(2)
                                    Spacer(minLength: 0)
                                }
                                .foregroundStyle(Theme.text)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                                .background(Theme.card, in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    ForEach(PracticeData.groups) { group in
                        HStack {
                            Text(group.title).font(.title3.bold())
                            Spacer()
                            NavigationLink {
                                ActivityList(group: group)
                            } label: {
                                Text("Wszystko").foregroundStyle(Theme.text2)
                                Image(systemName: "chevron.right").font(.caption).foregroundStyle(Theme.text2)
                            }
                        }
                        NavigationLink {
                            ActivityList(group: group)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(group.items.count) aktywności")
                                        .font(.caption)
                                        .foregroundStyle(Theme.text2)
                                    Text(group.items[0].title)
                                        .font(.title2.bold())
                                }
                                Spacer()
                                Image(systemName: group.symbol)
                                    .font(.largeTitle)
                                    .foregroundStyle(group.tint)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, minHeight: 140, alignment: .bottomLeading)
                            .background(
                                LinearGradient(colors: [group.tint.opacity(0.45), Theme.card], startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 150)
            }
            .toolbar(.hidden, for: .navigationBar)
            .containerBackground(for: .navigation) { NightGlow() }
            .safeAreaInset(edge: .bottom) {
                NavigationLink {
                    TutorView(launch: TalkLaunch(
                        id: "wolna",
                        title: "Swobodna rozmowa",
                        who: "Gadasz swobodnie po niemiecku o tym, co uczeń przyniesie. Jedno pytanie na raz.",
                        de: "Na, worüber hast du Lust zu reden?",
                        pl: "No, o czym masz ochotę pogadać?",
                        say: "Über meinen Tag auf der Arbeit."
                    ))
                } label: {
                    Label("Rozpocznij swobodną rozmowę", systemImage: "mic.fill")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Theme.accent, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            .sheet(isPresented: $streak) { StreakSheet() }
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

    private func icon(_ id: String) -> String {
        switch id {
        case "wynajem": return "house.fill"
        case "lekarz-szybko": return "cross.case.fill"
        case "zakupy": return "cart.fill"
        default: return "bubble.left.fill"
        }
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
                Text("Oba").tag("oba")
            }
            .pickerStyle(.segmented)
            Text("Ten poziom jest używany w lekcjach i powtórkach.")
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
