import SwiftUI

enum Merke {
    static func tokens(_ text: String) -> [String] {
        text.lowercased().split { ch in
            !(ch.isLetter || "äöüß".contains(ch))
        }.map(String.init)
    }

    static func changed(wrong: String, right: String) -> Set<String> {
        let old = Set(tokens(wrong))
        return Set(tokens(right).filter { !old.contains($0) })
    }

    static func why(wrong: String, right: String) -> String {
        let w = wrong.lowercased()
        let r = right.lowercased()
        var bits: [String] = []
        if (r.contains("habe ich") || r.contains("bin ich") || r.contains("kann ich")) && w.contains("ich ") {
            bits.append("Po nein, darum albo deshalb czasownik jest drugi: habe ich, nie ich habe.")
        }
        if r.contains("nicht") && w.contains("keine") {
            bits.append("Czasownik negujesz przez nicht. Keine stoi tylko przy rzeczowniku, na przykład keine Zeit.")
        }
        if r.contains("ge") && (r.contains("geschlafen") || r.contains("gemacht") || r.contains("gekommen") || r.contains("gesagt")) && !w.contains("ge") {
            bits.append("Czas przeszły to habe albo bin plus forma z ge-: geschlafen, nie samo schlafen.")
        }
        if w.contains("hab ") && r.contains("habe") {
            bits.append("Hab słyszysz w mowie. W pełnym zdaniu pisze się habe.")
        }
        if bits.isEmpty {
            let diff = changed(wrong: wrong, right: right).sorted()
            if diff.isEmpty { return "Porównaj swoją wersję z poprawną. Tak układa się całe zdanie." }
            return "Ważne słowa: \(diff.joined(separator: ", ")). Tak jest w pełnym zdaniu, nie w skrócie."
        }
        return bits.joined(separator: " ")
    }
}

struct MerkeBox: View {
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Merke!").font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
            Text(text).font(.footnote).foregroundStyle(Theme.text).fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.ok.opacity(0.45), lineWidth: 1))
    }
}

struct MarkedGerman: View {
    let text: String
    let marks: Set<String>

    var body: some View {
        Text(line)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .fixedSize(horizontal: false, vertical: true)
    }

    private var line: AttributedString {
        var out = AttributedString()
        let parts = text.split(separator: " ", omittingEmptySubsequences: false)
        for (index, part) in parts.enumerated() {
            var piece = AttributedString(String(part))
            let bare = String(part).lowercased().filter { $0.isLetter || "äöüß".contains($0) }
            if marks.contains(bare) {
                piece.foregroundColor = Theme.ok
                piece.underlineStyle = .single
            }
            out += piece
            if index < parts.count - 1 { out += AttributedString(" ") }
        }
        return out
    }
}
