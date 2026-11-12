import SwiftUI
import Charts

struct AIWord: Decodable {
    let de: String
    let pl: String
    let ex: String
    let exPl: String
    let topic: String
}

struct StatsView: View {
    @EnvironmentObject var store: LearningStore
    @State private var generating = false
    @State private var message = ""
    @State private var showPace = false
    @AppStorage("goalLevel") private var goalLevel = "A2"
    @AppStorage("dailyMinutes") private var dailyMinutes = 20
    @AppStorage("goalDays") private var goalDays = 90
    @AppStorage("didPickPace") private var didPickPace = false
    @AppStorage("ritualHistory") private var ritualHistory = ""
    @AppStorage("ritualStreak") private var ritualStreak = 0
    @AppStorage("ritualBest") private var ritualBest = 0

    private let ladder = ["A1", "A2", "B1", "B2"]
    private let minuteChoices = [10, 20, 30, 60]
    private let deadlineChoices = [30, 90, 180, 365]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    levelCard
                    dailyCard
                    summary
                    topics
                    activity
                    skills
                    mistakes
                    weak
                    lesson
                }
                .padding()
            }
            .navigationTitle("Postęp")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showPace) {
                PaceSheet(
                    minutes: $dailyMinutes,
                    goalDays: $goalDays,
                    goalLevel: goalLevel,
                    bands: journey(),
                    ladder: ladder,
                    minuteChoices: minuteChoices,
                    deadlineChoices: deadlineChoices
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Theme.bg)
            }
            .onAppear {
                if !minuteChoices.contains(dailyMinutes) {
                    dailyMinutes = minuteChoices.min { abs($0 - dailyMinutes) < abs($1 - dailyMinutes) } ?? 20
                }
                if !deadlineChoices.contains(goalDays) {
                    goalDays = deadlineChoices.min { abs($0 - goalDays) < abs($1 - goalDays) } ?? 90
                }
                seedRitual()
                if !didPickPace { showPace = true }
            }
            .onChange(of: showPace) { _, open in
                if !open { didPickPace = true }
            }
        }
    }

    fileprivate struct BandStat {
        let name: String
        let mastered: Int
        let learning: Int
        let total: Int
        var gate: Int { Int((Double(total) * 0.8).rounded(.up)) }
        var gap: Int { max(0, gate - mastered) }
        var softPercent: Int {
            let score = Double(mastered) + Double(learning) * 0.5
            return min(100, Int((score / Double(max(total, 1))) * 100))
        }
    }

    private func journey() -> [BandStat] {
        var levelOf: [String: String] = [:]
        for word in store.words { levelOf[word.de] = word.level }
        for word in FreqBank.all where levelOf[word.de] == nil { levelOf[word.de] = word.level }
        var mastered = ["A1": 0, "A2": 0, "B1": 0, "B2": 0]
        var learning = ["A1": 0, "A2": 0, "B1": 0, "B2": 0]
        for (de, stat) in store.stats {
            let raw = levelOf[de] ?? "A2"
            let level = mastered[raw] != nil ? raw : "A2"
            if stat.days.count >= 3 {
                mastered[level, default: 0] += 1
            } else if stat.correct + stat.wrong > 0 || !stat.days.isEmpty {
                learning[level, default: 0] += 1
            }
        }
        return ladder.map { name in
            BandStat(
                name: name,
                mastered: mastered[name] ?? 0,
                learning: learning[name] ?? 0,
                total: max(FreqBank.count(name), 1)
            )
        }
    }

    private func currentBand(_ bands: [BandStat]) -> BandStat {
        bands.first { $0.mastered < $0.gate } ?? bands[bands.count - 1]
    }

    private func goalTotals(_ bands: [BandStat]) -> (already: Int, need: Int) {
        let index = ladder.firstIndex(of: goalLevel) ?? 1
        let slice = bands.prefix(index + 1)
        let need = slice.reduce(0) { $0 + $1.gate }
        let already = slice.reduce(0) { $0 + min($1.mastered, $1.gate) }
        return (already, need)
    }

    private var levelCard: some View {
        let bands = journey()
        let now = currentBand(bands)
        let totals = goalTotals(bands)
        let left = max(0, totals.need - totals.already)
        let percent = totals.need == 0 ? 100 : Int((Double(totals.already) / Double(totals.need)) * 100)
        let days = left == 0 ? 0 : Int(ceil(Double(left) / Double(max(1, dailyMinutes / 3))))
        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("JESTEŚ").font(.caption.weight(.semibold)).foregroundStyle(Theme.text2)
                    Text(now.name).font(.system(size: 40, weight: .bold, design: .rounded))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("CELUJESZ").font(.caption.weight(.semibold)).foregroundStyle(Theme.text2)
                    Text(goalLevel).font(.system(size: 40, weight: .bold, design: .rounded)).foregroundStyle(Theme.orange)
                }
            }
            Text("Znasz \(now.softPercent)% poziomu \(now.name). Opanowane \(now.mastered), w nauce \(now.learning). Do progu \(now.name) zostało \(now.gap) słów.")
                .font(.subheadline)
            Picker("Na jaki poziom", selection: $goalLevel) {
                ForEach(ladder, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.segmented)
            ForEach(bands, id: \.name) { band in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(band.name == now.name ? "\(band.name) · tu jesteś" : band.name)
                            .font(.subheadline.weight(band.name == now.name ? .bold : .regular))
                        Spacer()
                        Text("\(band.mastered)/\(band.total) · \(band.softPercent)%")
                            .font(.caption)
                            .foregroundStyle(Theme.text2)
                    }
                    bandBar(band.softPercent, 100)
                    if let goalIndex = ladder.firstIndex(of: goalLevel),
                       let bandIndex = ladder.firstIndex(of: band.name),
                       bandIndex <= goalIndex {
                        Text(band.gap == 0 ? "Próg tego poziomu już masz." : "Do progu zostało \(band.gap) opanowanych słów.")
                            .font(.caption)
                            .foregroundStyle(Theme.text2)
                    }
                }
            }
            Text("Droga do \(goalLevel): \(percent)%. Zostało \(left) słów, żeby domknąć poziomy po drodze.")
                .font(.footnote)
                .foregroundStyle(Theme.text2)
            Button {
                showPace = true
            } label: {
                Text("Ile czasu dziennie? 10 · 20 · 30 · 60 min")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 12)
            .background(Theme.gradient, in: Capsule())
            .foregroundStyle(Theme.ink)
            Text(forecastLine(days: days, left: left))
                .font(.footnote)
                .foregroundStyle(Theme.text2)
        }
        .padding(16)
        .themedCard()
    }

    private var dailyCard: some View {
        let today = Self.dayKey()
        let claimed = ritualSet().contains(today)
        let marks = weekMarks()
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Codzienny ogień", systemImage: "flame.fill")
                    .font(.headline)
                    .foregroundStyle(claimed ? Theme.orange : Theme.text)
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(Theme.dni(max(ritualStreak, store.streak))).font(.headline)
                    Text("seria").font(.caption).foregroundStyle(Theme.text2)
                }
            }
            HStack {
                ForEach(marks, id: \.key) { mark in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(mark.on ? AnyShapeStyle(Theme.gradient) : AnyShapeStyle(Theme.track))
                            .frame(width: 28, height: 28)
                        Text(mark.label).font(.system(size: 10)).foregroundStyle(Theme.text2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            if claimed, let word = store.wordOfDay {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.de).font(.title3.bold())
                    Text(word.pl).foregroundStyle(Theme.text2)
                    Text("Masz dziś. Jutro słowo zgaśnie, jeśli nie wpadniesz.")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.card2, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                Text("Jedno wejście trzyma serię. Odbierz słowo dnia, zanim dzień się zamknie.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                Button {
                    claimRitual()
                } label: {
                    Text("Odbierz słowo dnia")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 12)
                .background(Theme.accent, in: Capsule())
                .foregroundStyle(Theme.ink)
            }
            if ritualBest > 0 {
                Text("Najdłuższa seria ognia: \(Theme.dni(ritualBest)).")
                    .font(.caption)
                    .foregroundStyle(Theme.text2)
            }
        }
        .padding(16)
        .themedCard()
    }

    private func forecastLine(days: Int, left: Int) -> String {
        if left == 0 { return "Ten cel już masz. Ustaw wyższy poziom." }
        let when = Self.pretty(days)
        let needMin = max(5, Int((Double(left) / Double(max(goalDays, 1))).rounded(.up)) * 3)
        if days <= goalDays {
            return "Przy \(dailyMinutes) min dziennie \(goalLevel) wypada \(when). Termin \(Self.deadlineName(goalDays)) się zgadza."
        }
        return "Przy \(dailyMinutes) min \(goalLevel) wypada \(when). Żeby zdążyć w \(Self.deadlineName(goalDays)), rób około \(needMin) min."
    }

    private func ritualSet() -> Set<String> {
        Set(ritualHistory.split(separator: ",").map { String($0) })
    }

    private func seedRitual() {
        guard ritualHistory.isEmpty, store.streak > 0 else {
            ritualStreak = max(ritualStreak, store.streak)
            ritualBest = max(ritualBest, ritualStreak)
            return
        }
        var keys: [String] = []
        for offset in 1...min(store.streak, 14) {
            if let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) {
                keys.append(Self.dayKey(date))
            }
        }
        ritualHistory = keys.joined(separator: ",")
        ritualStreak = store.streak
        ritualBest = max(ritualBest, store.streak)
    }

    private func claimRitual() {
        let today = Self.dayKey()
        var hist = ritualSet()
        guard !hist.contains(today) else { return }
        let yesterday = Self.dayKey(Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        if hist.contains(yesterday) {
            ritualStreak = max(ritualStreak, store.streak) + 1
        } else if ritualStreak == 0 {
            ritualStreak = max(store.streak, 1)
        } else {
            ritualStreak = 1
        }
        ritualBest = max(ritualBest, ritualStreak)
        hist.insert(today)
        ritualHistory = hist.sorted().suffix(40).joined(separator: ",")
        Haptic.good()
    }

    private func weekMarks() -> [(key: String, label: String, on: Bool)] {
        let hist = ritualSet()
        let cal = Calendar.current
        return (0..<7).reversed().compactMap { offset in
            guard let date = cal.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            let key = Self.dayKey(date)
            return (key, "\(cal.component(.day, from: date))", hist.contains(key))
        }
    }

    private func bandBar(_ known: Int, _ total: Int) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.track)
                Capsule()
                    .fill(Theme.gradient)
                    .frame(width: max(6, geo.size.width * CGFloat(known) / CGFloat(max(total, 1))))
            }
        }
        .frame(height: 10)
    }

    private static func dayKey(_ date: Date = Date()) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    private static func pretty(_ days: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateStyle = .long
        return f.string(from: date)
    }

    private static func deadlineName(_ days: Int) -> String {
        switch days {
        case 30: return "1 miesiąc"
        case 90: return "3 miesiące"
        case 180: return "pół roku"
        case 365: return "rok"
        default: return "\(days) dni"
        }
    }

    private var summary: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(store.learningCount)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.text)
                Text("słów w nauce, opanowane \(store.masteredCount)")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Theme.text2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(Theme.dni(store.streak))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.text)
                Text("Seria")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Theme.text2)
            }
        }
        .padding(16)
        .themedCard()
    }

    private var topics: some View {
        let rows = store.topicAccuracy().prefix(6)
        return VStack(alignment: .leading, spacing: 10) {
            Text("Tematy").font(.headline)
            if rows.isEmpty {
                Text("Po pierwszej sesji zobaczysz, co już siedzi.").foregroundStyle(Ink.muted)
            }
            ForEach(Array(rows), id: \.topic) { row in
                HStack {
                    Text(row.topic).font(.subheadline)
                    Spacer()
                    Text("\(Int(row.accuracy * 100))%").font(.caption).foregroundStyle(Ink.muted)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Theme.track)
                        Capsule().fill(Theme.gradient).frame(width: max(6, geo.size.width * row.accuracy))
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var activity: some View {
        let days = store.recentActivity()
        let maxValue = max(days.map(\.value).max() ?? 1, 1)
        return VStack(alignment: .leading, spacing: 10) {
            Text("Powtórki, 14 dni").font(.system(size: 17, weight: .semibold, design: .rounded))
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(day.label == days.last?.label ? AnyShapeStyle(Theme.gradient) : AnyShapeStyle(Theme.accent.opacity(day.value == 0 ? 0.25 : 0.7)))
                            .frame(height: max(6, 70 * CGFloat(day.value) / CGFloat(maxValue)))
                        Text(day.label).font(.system(size: 8)).foregroundStyle(Ink.muted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 96, alignment: .bottom)
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var skills: some View {
        let studied = max(store.stats.count, 1)
        let words = Double(store.masteredCount) / Double(studied)
        let listen = store.journal.listenTries == 0 ? 0 : Double(store.journal.listenOk) / Double(store.journal.listenTries)
        let talk = min(1, Double(store.monthTalkSeconds) / 1800)
        let scenes = Scenarios.all.isEmpty ? 0 : Double(store.journal.scenes.count) / Double(Scenarios.all.count)
        let rows: [(String, Double)] = [("Słówka", words), ("Słuchanie", listen), ("Rozmowa", talk), ("Sceny", scenes)]
        return VStack(alignment: .leading, spacing: 10) {
            Text("Umiejętności").font(.headline)
            ForEach(rows, id: \.0) { name, value in
                HStack {
                    Text(name).frame(width: 90, alignment: .leading).font(.subheadline)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.08))
                            Capsule().fill(Ink.accent).frame(width: geo.size.width * value)
                        }
                    }
                    .frame(height: 8)
                }
            }
            Text("Baza: \(FreqBank.all.count) najczęstszych słów, A1–B2. W nauce: \(store.stats.count).")
                .font(.footnote)
                .foregroundStyle(Ink.muted)
            Text("Rozmowa w tym miesiącu: \(store.talkLabel) · Dzień \(store.planDay)/30")
                .font(.footnote)
                .foregroundStyle(Ink.muted)
        }
        .padding(16)
        .liquidGlass(radius: 22)
    }

    private var mistakes: some View {
        let slips = store.mistakesToday.isEmpty ? Array(store.journal.mistakes.prefix(6)) : store.mistakesToday
        return VStack(alignment: .leading, spacing: 8) {
            Text("Błędy").font(.headline)
            if slips.isEmpty {
                Text("Jak w rozmowie powiesz coś krzywo, wpadnie to tutaj.").foregroundStyle(Ink.muted)
            }
            ForEach(slips) { slip in
                VStack(alignment: .leading, spacing: 2) {
                    Text(slip.text)
                    if !slip.fix.isEmpty { Text(slip.fix).font(.footnote).foregroundStyle(Ink.muted) }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 22)
    }

    private var weak: some View {
        let weak = Array(store.weakWords.prefix(6))
        return VStack(alignment: .leading, spacing: 8) {
            Text("Do poprawy").font(.headline)
            if weak.isEmpty { Text("Na razie nic.").foregroundStyle(Ink.muted) }
            ForEach(weak) { word in
                HStack {
                    Text(word.de)
                    Spacer()
                    Text(word.pl).foregroundStyle(Ink.muted)
                }
                .font(.subheadline)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(radius: 22)
    }

    private var lesson: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                Task { await generateLesson() }
            } label: {
                Text(generating ? "Chwilę…" : "Wygeneruj nowe słówka")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 12)
            .background(Ink.accent, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(.black)
            .disabled(generating)
            if !message.isEmpty { Text(message).font(.footnote).foregroundStyle(Ink.muted) }
        }
    }

    private func generateLesson() async {
        generating = true
        message = ""
        defer { generating = false }
        let known = store.words.map(\.de).suffix(300).joined(separator: ", ")
        let prompt = """
        Postępy ucznia:
        \(store.progressSummary())

        Znane już słówka (NIE powtarzaj ich): \(known)

        Wygeneruj 10 NOWYCH, przydatnych słówek lub zwrotów (poziom A2–B1) do codziennego życia i pracy w Niemczech. \
        Skup się na tematach, w których uczeń ma najniższą skuteczność, oraz na tych samych trudnościach co słabe słowa. \
        Nie podawaj bardzo łatwych słów (powitania, liczby, kolory).
        Zwróć JSON obiektu {"items":[{"de":"","pl":"","ex":"","exPl":"","topic":""}]}. Nic poza JSON.
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Jesteś nauczycielem niemieckiego dla Polaka. Odpowiadasz wyłącznie poprawnym JSON-em.",
                json: true)
            let items = try WordJSON.decode(text)
            let added = store.addWords(items.map {
                Word(de: $0.de, pl: $0.pl, ex: $0.ex, exPl: $0.exPl, topic: $0.topic)
            })
            message = "Dodano \(added) nowych słówek. Zobaczysz je w następnej sesji."
        } catch {
            message = "⚠️ Nie wyszła lista słówek. Stuknij jeszcze raz."
        }
    }
}

private struct PaceSheet: View {
    @Binding var minutes: Int
    @Binding var goalDays: Int
    let goalLevel: String
    let bands: [StatsView.BandStat]
    let ladder: [String]
    let minuteChoices: [Int]
    let deadlineChoices: [Int]
    @Environment(\.dismiss) private var dismiss

    private var slice: [StatsView.BandStat] {
        let index = ladder.firstIndex(of: goalLevel) ?? 0
        return Array(bands.prefix(index + 1))
    }

    private var need: Int { slice.reduce(0) { $0 + $1.gate } }
    private var already: Int { slice.reduce(0) { $0 + min($1.mastered, $1.gate) } }
    private var left: Int { max(0, need - already) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Jak szybko chcesz dojść do \(goalLevel)?")
                    .font(.title2.bold())
                Text("Cztery dawki. Wykres pokazuje, ile procent celu masz po kolejnych miesiącach.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                HStack(spacing: 8) {
                    ForEach(minuteChoices, id: \.self) { choice in
                        Button {
                            minutes = choice
                        } label: {
                            VStack(spacing: 0) {
                                Text("\(choice)").font(.title2.bold())
                                Text("min").font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                if minutes == choice {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.gradient)
                                } else {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.track)
                                }
                            }
                            .foregroundStyle(minutes == choice ? Theme.ink : Theme.text)
                        }
                        .buttonStyle(.plain)
                    }
                }
                Text(headline)
                    .font(.subheadline)
                chart
                    .frame(height: 200)
                Text("miesiące od dziś · % drogi do \(goalLevel)")
                    .font(.caption2)
                    .foregroundStyle(Theme.text2)
                    .frame(maxWidth: .infinity)
                Text("Chcę zdążyć w").font(.headline)
                HStack(spacing: 8) {
                    ForEach(deadlineChoices, id: \.self) { choice in
                        Button {
                            goalDays = choice
                        } label: {
                            Text(StatsView.deadlineLabel(choice))
                                .font(.caption.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(goalDays == choice ? Theme.text : Theme.track))
                                .foregroundStyle(goalDays == choice ? Theme.ink : Theme.text2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                Text(verdict)
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                ForEach(slice, id: \.name) { band in
                    let per = max(1, minutes / 3)
                    let bandDays = band.gap == 0 ? 0 : Int(ceil(Double(band.gap) / Double(per)))
                    Text(band.gap == 0
                         ? "\(band.name): próg zamknięty"
                         : "\(band.name): \(band.gap) słów · około \(bandDays) dni przy \(minutes) min")
                        .font(.footnote)
                        .foregroundStyle(Theme.text2)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Biorę to tempo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 14)
                .background(Theme.gradient, in: Capsule())
                .foregroundStyle(Theme.ink)
            }
            .padding(20)
        }
    }

    private var headline: String {
        if left == 0 { return "Poziom \(goalLevel) już siedzi. Podnieś cel." }
        let per = max(1, minutes / 3)
        let days = Int(ceil(Double(left) / Double(per)))
        return "Przy \(minutes) min (\(per) słów dziennie) \(goalLevel) około \(StatsView.prettyDate(days))."
    }

    private var verdict: String {
        let per = max(1, minutes / 3)
        let days = left == 0 ? 0 : Int(ceil(Double(left) / Double(per)))
        if days <= goalDays { return "To tempo mieści się w terminie \(StatsView.deadlineLabel(goalDays))." }
        let needMin = max(5, Int((Double(left) / Double(max(goalDays, 1))).rounded(.up)) * 3)
        return "W \(StatsView.deadlineLabel(goalDays)) to tempo nie dowozi \(goalLevel). Trzeba około \(needMin) min dziennie, albo dłuższy termin."
    }

    private var chart: some View {
        let samples = samples()
        return Chart(samples) { sample in
            LineMark(
                x: .value("Miesiąc", sample.month),
                y: .value("Cel", sample.percent)
            )
            .foregroundStyle(by: .value("Dawka", sample.tempo))
            .interpolationMethod(.monotone)
            .lineStyle(StrokeStyle(lineWidth: sample.minutes == minutes ? 3 : 1.4))
        }
        .chartYScale(domain: 0...100)
        .chartForegroundStyleScale([
            "10 min": Color.white.opacity(0.45),
            "20 min": Theme.accent,
            "30 min": Color(hex: "C4B5FD"),
            "60 min": Theme.orange,
        ])
        .chartXAxis {
            AxisMarks(values: [0, 3, 6, 12, 24]) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let month = value.as(Int.self) {
                        Text("\(month)")
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom, spacing: 8)
    }

    private func samples() -> [PaceSample] {
        let marks = [0, 1, 2, 3, 4, 6, 9, 12, 18, 24]
        var out: [PaceSample] = []
        let base = max(need, 1)
        for choice in minuteChoices {
            let per = max(1, choice / 3)
            for month in marks {
                let gained = month * 30 * per
                let pct = min(100, Int((Double(already + gained) / Double(base)) * 100))
                out.append(PaceSample(minutes: choice, month: month, percent: pct))
            }
        }
        return out
    }
}

private struct PaceSample: Identifiable {
    let minutes: Int
    let month: Int
    let percent: Int
    var tempo: String { "\(minutes) min" }
    var id: String { "\(minutes)-\(month)" }
}

extension StatsView {
    fileprivate static func prettyDate(_ days: Int) -> String { pretty(days) }
    fileprivate static func deadlineLabel(_ days: Int) -> String { deadlineName(days) }
}

enum WordJSON {
    static func decode(_ text: String) throws -> [AIWord] {
        let raw = jsonSlice(text)
        let data = Data(raw.utf8)
        if let items = try? JSONDecoder().decode([AIWord].self, from: data), !items.isEmpty { return items }
        guard let obj = try? JSONSerialization.jsonObject(with: data) else { throw GeminiError.badResponse }
        let rows: [[String: Any]]
        if let arr = obj as? [[String: Any]] {
            rows = arr
        } else if let dict = obj as? [String: Any] {
            rows = (dict["items"] ?? dict["words"] ?? dict["slowka"]) as? [[String: Any]] ?? []
        } else {
            rows = []
        }
        let words: [AIWord] = rows.compactMap { row in
            func pick(_ keys: String...) -> String {
                for key in keys {
                    if let value = row[key] as? String {
                        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty { return trimmed }
                    }
                }
                return ""
            }
            let de = pick("de", "german", "niemiecki")
            guard !de.isEmpty else { return nil }
            let pl = pick("pl", "polish", "polski")
            let ex = pick("ex", "example", "sentence")
            let topic = pick("topic", "temat")
            return AIWord(
                de: de,
                pl: pl.isEmpty ? de : pl,
                ex: ex.isEmpty ? de : ex,
                exPl: pick("exPl", "examplePl", "tlumaczenie"),
                topic: topic.isEmpty ? "Z życia" : topic)
        }
        if words.isEmpty { throw GeminiError.badResponse }
        return words
    }
}
