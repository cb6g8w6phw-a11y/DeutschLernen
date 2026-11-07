import SwiftUI
import PhotosUI
import Vision
import UIKit

struct ScanView: View {
    @EnvironmentObject var store: LearningStore
    @State private var photo: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var raw = ""
    @State private var result = ""
    @State private var busy = false
    @State private var note = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Zrób zdjęcie instrukcji, listu albo tabliczki. Tekst zostanie odczytany na telefonie, a trudne słowa trafią do powtórek.")
                        .foregroundStyle(.secondary)
                    HStack {
                        PhotosPicker(selection: $photo, matching: .images) {
                            Label("Z galerii", systemImage: "photo")
                        }
                        .buttonStyle(.glass)
                        Button { showCamera = true } label: {
                            Label("Aparat", systemImage: "camera")
                        }
                        .buttonStyle(.glass)
                    }
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    if !raw.isEmpty {
                        Text(raw).font(.footnote).padding(12).liquidGlass(radius: 16)
                        Button {
                            Task { await explain() }
                        } label: {
                            if busy { ProgressView() } else { Text("Przetłumacz i zapisz słowa") }
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Ink.brass)
                        .disabled(busy)
                    }
                    if !note.isEmpty { Text(note).font(.footnote).foregroundStyle(.secondary) }
                    if !result.isEmpty { Text(result).padding(12).liquidGlass(radius: 16) }
                }
                .padding()
            }
            .navigationTitle("Skan")
            .containerBackground(for: .navigation) { NightGlow() }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onChange(of: photo) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        image = img
                        raw = recognize(img)
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker { img in
                    image = img
                    raw = recognize(img)
                }
            }
        }
    }

    private func explain() async {
        busy = true
        note = "Tłumaczę…"
        defer { busy = false }
        let prompt = """
        To jest tekst ze zdjęcia (instrukcja, list albo tabliczka). Może być po niemiecku:
        \(raw.prefix(2500))
        Zrób dwie rzeczy, bez markdownu:
        1) Krótkie tłumaczenie całości na polski (max 8 zdań).
        2) Linia ZAPISZ dla maksymalnie 8 trudnych słów technicznych, każda w formacie:
        ZAPISZ: niemieckie słowo albo zwrot | polskie znaczenie
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Tłumaczysz niemieckie teksty z pracy na polski i wyciągasz trudne słowa.")
            result = text
            let pairs = text.split(separator: "\n").compactMap { row -> (String, String)? in
                savePair(in: String(row))
            }
            let words = pairs.map { Word(de: $0.0, pl: $0.1, ex: $0.0, exPl: $0.1, topic: "Ze zdjęcia", level: "A2") }
            let added = store.addWords(words)
            note = "Zapisano \(added) słów do powtórek."
        } catch {
            note = error.localizedDescription
        }
    }

    private func recognize(_ image: UIImage) -> String {
        guard let cg = image.cgImage else { return "Nie da się odczytać tego zdjęcia." }
        let req = VNRecognizeTextRequest()
        req.recognitionLevel = .accurate
        req.recognitionLanguages = ["de-DE", "pl-PL", "en-US"]
        req.usesLanguageCorrection = true
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        do {
            try handler.perform([req])
            let lines = (req.results ?? []).compactMap { $0.topCandidates(1).first?.string }
            return lines.isEmpty ? "Na zdjęciu nie ma czytelnego tekstu." : lines.joined(separator: "\n")
        } catch {
            return "OCR nie zadziałał."
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    var onImage: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coord { Coord(self) }

    final class Coord: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let img = info[.originalImage] as? UIImage { parent.onImage(img) }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.dismiss() }
    }
}
