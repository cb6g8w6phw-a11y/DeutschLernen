import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("groqKey") private var groq = ""
    @AppStorage("geminiKey") private var gemini = ""
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            Form {
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
}
