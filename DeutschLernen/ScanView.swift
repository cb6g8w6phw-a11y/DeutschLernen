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

struct CaptureView: View {
    @EnvironmentObject var store: LearningStore
    @StateObject private var mic = Mic()
    @State private var mode = "Tekst"
    @State private var draft = ""
    @State private var lang = "pl-PL"
    @State private var photo: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var busy = false
    @State private var polish = ""
    @State private var german = ""
    @State private var note = ""
    private let modes = ["Tekst", "Zdjęcie", "Głos"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Wklej komentarz z meczu, wiadomość z pracy albo cokolwiek. Możesz też dać zdjęcie albo głosówkę. Dostaniesz polski, niemiecki i słowa do nauki.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text2)
                Picker("Sposób", selection: $mode) {
                    ForEach(modes, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.segmented)
                switch mode {
                case "Zdjęcie": photoBox
                case "Głos": voiceBox
                default: textBox
                }
                if !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, mode != "Tekst" {
                    Text("Rozpoznane")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.text2)
                    Text(draft)
                        .font(.body)
                        .foregroundStyle(Theme.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .themedCard(radius: 18)
                }
                Button {
                    Task { await learn() }
                } label: {
                    Group {
                        if busy {
                            ProgressView().tint(Theme.ink)
                        } else {
                            Text("Przetłumacz i dodaj do nauki")
                        }
                    }
                    .primaryButton()
                }
                .buttonStyle(.plain)
                .disabled(busy)
                if !note.isEmpty {
                    Text(note).font(.footnote).foregroundStyle(Theme.text2)
                }
                if !polish.isEmpty {
                    resultCard("Po polsku", polish)
                }
                if !german.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        resultCard("Po niemiecku", german)
                        Button { Talk.de(String(german.prefix(420))) } label: {
                            Label("Odtwórz", systemImage: "speaker.wave.2")
                                .foregroundStyle(Theme.accent)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .navigationTitle("Z życia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .containerBackground(for: .navigation) { NightGlow() }
        .scrollDismissesKeyboard(.interactively)
        .micPrompt(mic)
        .onChange(of: mic.text) { _, value in
            if mode == "Głos", !value.isEmpty { draft = value }
        }
        .onChange(of: photo) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    image = img
                    draft = ocrText(img)
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { img in
                image = img
                draft = ocrText(img)
            }
        }
    }

    private var textBox: some View {
        TextField("Np. Lewandowski strzelił gola w 78. minucie", text: $draft, axis: .vertical)
            .lineLimit(4...10)
            .padding(14)
            .themedCard(radius: 18)
    }

    private var photoBox: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                PhotosPicker(selection: $photo, matching: .images) {
                    Label("Galeria", systemImage: "photo").ghostButton()
                }
                .buttonStyle(.plain)
                Button { showCamera = true } label: {
                    Label("Aparat", systemImage: "camera").ghostButton()
                }
                .buttonStyle(.plain)
            }
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var voiceBox: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                langChip("Polski", "pl-PL")
                langChip("Niemiecki", "de-DE")
            }
            Button {
                mic.arm(lang)
                mic.toggle()
            } label: {
                Label(mic.listening ? "Stop" : "Nagraj głosówkę", systemImage: mic.listening ? "stop.fill" : "mic.fill")
                    .primaryButton()
            }
            .buttonStyle(.plain)
            if !mic.note.isEmpty {
                Text(mic.note).font(.footnote).foregroundStyle(Theme.text2)
            }
        }
    }

    private func langChip(_ title: String, _ id: String) -> some View {
        Button { lang = id } label: {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(lang == id ? Theme.ink : Theme.text)
                .padding(.horizontal, 14)
                .frame(minHeight: 36)
                .background(lang == id ? AnyShapeStyle(Theme.gradient) : AnyShapeStyle(Theme.card), in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private func resultCard(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(Theme.text)
            Text(body).font(.body).foregroundStyle(Theme.text2).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .themedCard(radius: 22)
    }

    private func learn() async {
        let source = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard source.count > 2 else {
            note = "Najpierw wpisz tekst, dodaj zdjęcie albo nagraj głos."
            return
        }
        busy = true
        note = "Tłumaczę…"
        polish = ""
        german = ""
        defer { busy = false }
        let prompt = """
        Materiał użytkownika. Może być po polsku albo po niemiecku, z meczu, pracy, czatu albo zdjęcia:
        \(source.prefix(3500))

        Odpowiedz dokładnie tak, bez markdownu:
        POLSKI:
        pełny sens po polsku, maksymalnie 8 krótkich zdań. Same polskie zdania.
        NIEMIECKI:
        to samo prostym niemieckim A2, maksymalnie 8 krótkich zdań. Same niemieckie zdania.
        ZAPISZ: niemiecki zwrot | polskie znaczenie
        Daj od 4 do 8 linii ZAPISZ. Tylko słowa, które są w tym materiale.
        """
        do {
            let text = try await Gemini.send(
                messages: [GeminiMessage(role: "user", text: prompt)],
                system: "Sekcja POLSKI jest wyłącznie po polsku. Sekcja NIEMIECKI jest wyłącznie po niemiecku. Nie mieszaj języków.")
            polish = slice(text, "POLSKI")
            german = slice(text, "NIEMIECKI")
            let pairs = text.split(separator: "\n").compactMap { savePair(in: String($0)) }
            let sample = german.isEmpty ? source : german
            let words = pairs.map {
                Word(de: $0.0, pl: $0.1, ex: sample, exPl: polish.isEmpty ? $0.1 : polish, topic: "Z życia", level: "A2")
            }
            let added = store.addWords(words)
            if polish.isEmpty && german.isEmpty {
                note = "Nie udało się rozdzielić tłumaczenia. Spróbuj jeszcze raz."
            } else {
                note = added > 0 ? "Dodano \(added) słów do nauki." : "Tłumaczenie gotowe. Te słowa już były w nauce."
            }
        } catch {
            note = error.localizedDescription
        }
    }

    private func slice(_ text: String, _ name: String) -> String {
        let heads = ["POLSKI", "NIEMIECKI", "ZAPISZ"]
        var take = false
        var lines: [String] = []
        for raw in text.components(separatedBy: .newlines) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }
            let key = line.uppercased()
            if key.hasPrefix(name + ":") {
                take = true
                let rest = String(line.drop(while: { $0 != ":" }).dropFirst()).trimmingCharacters(in: .whitespaces)
                if !rest.isEmpty { lines.append(rest) }
                continue
            }
            if heads.contains(where: { key.hasPrefix($0 + ":") }) {
                if take { break }
                continue
            }
            if take { lines.append(line) }
        }
        return lines.joined(separator: "\n\n")
    }
}

func ocrText(_ image: UIImage) -> String {
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
