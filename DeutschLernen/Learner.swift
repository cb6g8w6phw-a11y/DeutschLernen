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
            return "Uczeń pracuje w Niemczech, w magazynie, na budowie albo w warsztacie."
        }
        return "Dane ucznia, używaj ich w rozmowie jak o prawdziwej osobie: " + bits.joined(separator: ", ") + "."
    }
}
