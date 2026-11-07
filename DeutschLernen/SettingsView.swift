import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: LearningStore
    @AppStorage("geminiKey") private var key = ""
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Klucz Gemini (darmowy)") {
                    SecureField("Wklej klucz API", text: $key)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    Link("Pobierz klucz: aistudio.google.com/apikey",
                         destination: URL(string: "https://aistudio.google.com/apikey")!)
                }
                Section {
                    Button("Zresetuj postępy i słówka", role: .destructive) { confirmReset = true }
                }
            }
            .navigationTitle("Ustawienia")
            .scrollContentBackground(.hidden)
            .containerBackground(for: .navigation) { NightGlow() }
            .confirmationDialog("Na pewno?", isPresented: $confirmReset) {
                Button("Resetuj", role: .destructive) { store.reset() }
            }
        }
    }
}
