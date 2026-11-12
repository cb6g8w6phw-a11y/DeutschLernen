import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: LearningStore
    @State private var groq = ""
    @State private var gemini = ""
    @State private var eleven = ""
    @State private var keyOK = false
    @AppStorage("profileJob") private var job = ""
    @AppStorage("profileCity") private var city = ""
    @AppStorage("profileBoss") private var boss = ""
    @AppStorage("profileCar") private var car = ""
    @AppStorage("dailyGoal") private var dailyGoal = 20
    @AppStorage("sessionSize") private var sessionSize = 20
    @AppStorage("islandSentence") private var islandSentence = true
    @AppStorage("islandEvening") private var islandEvening = true
    @AppStorage("islandLesson") private var islandLesson = true
    @AppStorage("islandSpeak") private var islandSpeak = true
    @AppStorage("islandVoice") private var islandVoice = true
    @State private var testing = false
    @State private var testNote = ""
    @State private var confirmReset = false
    @State private var notifyNote = "Sprawdzam zgodę…"

    var body: some View {
        NavigationStack {
            Form {
                Section("Twoje dane w scenach") {
                    TextField("Praca, np. magazyn", text: $job)
                    TextField("Miasto", text: $city)
                    TextField("Imię szefa", text: $boss)
                    TextField("Auto, np. Audi A4", text: $car)
                    Text("Rozmowy będą o tym, nie o wymyślonej osobie.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section("Ile dziennie") {
                    Stepper("Cel: \(dailyGoal) słówek", value: $dailyGoal, in: 5...200, step: 5)
                    Stepper("Sesja: \(sessionSize) słówek", value: $sessionSize, in: 5...200, step: 5)
                    Text("Po celu możesz ćwiczyć dalej. Nie ma blokady.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section {
                    Text("iPhone musi zezwolić na powiadomienia. Rano przyjdzie zdanie, o 18:00 informacja ile słówek zostało. Bez zgody przypomnienia nie wyjdą.")
                        .font(.footnote).foregroundStyle(.secondary)
                    Button {
                        Task { await askNotify() }
                    } label: {
                        Text("Zezwól na powiadomienia")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    Text(notifyNote).font(.footnote).foregroundStyle(.secondary)
                } header: {
                    Text("Powiadomienia")
                }
                Section {
                    Toggle("Zdanie na dziś", isOn: $islandSentence)
                    Toggle("Wieczorem: zostało słówek", isOn: $islandEvening)
                    Toggle("Nauka i słuchanie", isOn: $islandLesson)
                    Toggle("Wymowa", isOn: $islandSpeak)
                    Toggle("Głosówka", isOn: $islandVoice)
                    Text("Wyłączone nie wchodzi na Dynamic Island. Zdanie i wieczór idą też jako powiadomienie, jeśli zezwolisz.")
                        .font(.footnote).foregroundStyle(.secondary)
                } header: {
                    Text("Co na wyspie")
                }
                Section("Wygląd") {
                    ThemePicker()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                Section {
                    SecureField("Klucz ElevenLabs", text: $eleven)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: eleven) { _, value in Secret.save(value, "elevenKey") }
                    Link("Klucz głosu: elevenlabs.io", destination: URL(string: "https://elevenlabs.io/app/settings/api-keys")!)
                    Text("Ten klucz tylko czyta odpowiedzi na głos. Rozmowę dalej pisze Gemini albo Groq. Głos jest męski i niemiecki.")
                        .font(.footnote).foregroundStyle(.secondary)
                    Text("Jeśli nadal słyszysz kobietę, na iPhonie ściągnij głos Markus: Ustawienia, Dostępność, Treść mówiona, Głosy, Niemiecki.")
                        .font(.footnote).foregroundStyle(.secondary)
                    PaceButtons()
                } header: {
                    Text("ElevenLabs — głos")
                }
                Section {
                    SecureField("Klucz Groq", text: $groq)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: groq) { _, value in Secret.save(value, "groqKey") }
                    Link("Darmowy klucz, bez karty: console.groq.com/keys",
                         destination: URL(string: "https://console.groq.com/keys")!)
                    Text("Konto na Groq, potem Create API Key i wklej tutaj. To działa, gdy Gemini ma przerwę.")
                        .font(.footnote).foregroundStyle(.secondary)
                } header: {
                    Text("Groq — polecane")
                }
                Section {
                    SecureField("Klucz Gemini", text: $gemini)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: gemini) { _, value in Secret.save(value, "geminiKey") }
                    Link("Klucz Gemini: aistudio.google.com/apikey",
                         destination: URL(string: "https://aistudio.google.com/apikey")!)
                    Text("Zapas. Aplikacja użyje go, gdy Groq nie odpowie.")
                        .font(.footnote).foregroundStyle(.secondary)
                } header: {
                    Text("Gemini — zapas")
                }
                Section {
                    Button {
                        Task { await ping() }
                    } label: {
                        HStack {
                            if testing { ProgressView() }
                            else { Text("Sprawdź klucz") }
                            if keyOK { Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.ok) }
                        }
                        .frame(minHeight: 44)
                    }
                    .disabled(testing)
                    if !testNote.isEmpty {
                        Text(testNote).font(.footnote)
                    }
                }
                Section {
                    Button("Zresetuj postępy i słówka", role: .destructive) { confirmReset = true }
                }
            }
            .navigationTitle("Ustawienia")
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Zamknij") { Keyboard.hide() }
                }
            }
            .confirmationDialog("Na pewno?", isPresented: $confirmReset) {
                Button("Resetuj", role: .destructive) { store.reset() }
            }
            .onAppear {
                groq = Secret.load("groqKey")
                gemini = Secret.load("geminiKey")
                eleven = Secret.load("elevenKey")
                Task { await refreshNotify() }
            }
            .onChange(of: islandSentence) { _, _ in applyIsland() }
            .onChange(of: islandEvening) { _, _ in applyIsland() }
            .onChange(of: islandLesson) { _, _ in applyIsland() }
            .onChange(of: islandSpeak) { _, _ in applyIsland() }
            .onChange(of: islandVoice) { _, _ in applyIsland() }
            .onChange(of: dailyGoal) { _, _ in applyIsland() }
        }
    }

    private func applyIsland() {
        Island.sync(reviews: store.reviewsToday)
        Ping.plan(reviews: store.reviewsToday)
    }

    private func askNotify() async {
        let ok = await Ping.allow()
        if ok { Ping.plan(reviews: store.reviewsToday) }
        await refreshNotify()
    }

    private func refreshNotify() async {
        let current = await Ping.status()
        switch current {
        case .authorized, .provisional, .ephemeral:
            notifyNote = "Zgoda jest. Powiadomienia wyjdą według przełączników niżej."
        case .denied:
            notifyNote = "Zgoda odrzucona. Stuknij przycisk, otworzą się ustawienia iPhone’a."
        case .notDetermined:
            notifyNote = "Jeszcze niepytany. Stuknij przycisk, iPhone pokaże pytanie o zgodę."
        @unknown default:
            notifyNote = "Nie udało się sprawdzić zgody."
        }
    }

    private func ping() async {
        testing = true
        testNote = "Łączę…"
        keyOK = false
        defer { testing = false }
        do {
            _ = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: "Napisz dokładnie: OK")],
                system: "Odpowiedz dokładnie jednym słowem: OK")
            testNote = "Klucz działa."
            keyOK = true
        } catch {
            testNote = error.localizedDescription
            keyOK = false
        }
    }
}
