import Foundation

enum Learner {
    static var line: String {
        let d = UserDefaults.standard
        let job = d.string(forKey: "profileJob") ?? ""
        let city = d.string(forKey: "profileCity") ?? ""
        let boss = d.string(forKey: "profileBoss") ?? ""
        let car = d.string(forKey: "profileCar") ?? ""
        var bits: [String] = []
        if !job.isEmpty { bits.append("praca: \(job)") }
        if !city.isEmpty { bits.append("miasto: \(city)") }
        if !boss.isEmpty { bits.append("szef: \(boss)") }
        if !car.isEmpty { bits.append("auto: \(car)") }
        if bits.isEmpty {
            bits.append("Uczeń pracuje w Niemczech, w magazynie, na budowie albo w warsztacie")
        }
        let fresh = UserDefaults.standard.stringArray(forKey: "freshVocab") ?? []
        if !fresh.isEmpty {
            bits.append("ostatnio uczone słowa, wpleć je w rozmowę: " + fresh.joined(separator: ", "))
        }
        let pattern = d.string(forKey: "freshPattern") ?? ""
        if !pattern.isEmpty {
            bits.append("ostatni wzorzec gramatyczny, użyj go w zdaniu: \(pattern)")
        }
        return "Dane ucznia: " + bits.joined(separator: ". ") + "."
    }
}
