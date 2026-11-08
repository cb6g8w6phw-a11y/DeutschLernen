import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("groqKey") private var groq = ""
    @AppStorage("geminiKey") private var gemini = ""
    @AppStorage("profileJob") private var job = ""
    @AppStorage("profileCity") private var city = ""
    @AppStorage("profileBoss") private var boss = ""
    @AppStorage("profileCar") private var car = ""
    @AppStorage("dailyGoal") private var dailyGoal = 20
    @AppStorage("sessionSize") private var sessionSize = 20
    @State private var testing = false
    @State private var testNote = ""
    @State private var confirmReset = false

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
                Section("Wygląd") {
                    ThemePicker()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                Section {
                    SecureField("Klucz Groq", text: $groq)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
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
                        if testing { ProgressView() } else { Text("Sprawdź klucz") }
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
        }
    }

    private func ping() async {
        testing = true
        testNote = "Łączę…"
        defer { testing = false }
        do {
            let reply = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: "Napisz dokładnie: OK")],
                system: "Odpowiedz dokładnie jednym słowem: OK")
            testNote = "Działa. Odpowiedź: \(reply.prefix(80))"
        } catch {
            testNote = error.localizedDescription
        }
    }
}
