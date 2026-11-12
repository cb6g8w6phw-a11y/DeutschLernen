import Foundation

enum FreqBank {
    static let all: [Word] = load()

    static func count(_ level: String) -> Int {
        all.filter { $0.level == level }.count
    }

    private static func load() -> [Word] {
        guard let url = Bundle.main.url(forResource: "freq10k", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let rows = try? JSONDecoder().decode([[String]].self, from: data) else { return [] }
        return rows.compactMap { row in
            guard row.count >= 3 else { return nil }
            return Word(de: row[0], pl: row[1], ex: row[0], exPl: row[1], topic: "Najczęstsze", level: row[2])
        }
    }
}
