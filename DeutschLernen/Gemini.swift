import Foundation

enum GeminiError: LocalizedError {
    case noKey, badResponse
    case http(Int, String)

    var errorDescription: String? {
        switch self {
        case .noKey: return "Brak klucza API. Wejdź w Ustawienia i wklej darmowy klucz Gemini."
        case .badResponse: return "Nieprawidłowa odpowiedź z Gemini."
        case .http(let code, _):
            if code == 404 { return "Ten model Gemini już nie działa. Zainstaluj nową wersję aplikacji." }
            if code == 400 || code == 403 { return "Gemini odrzuciło klucz (\(code)). Wklej go jeszcze raz w Ustawieniach." }
            return "Gemini nie odpowiedziało (\(code)). Spróbuj za chwilę."
        }
    }
}

struct GeminiMessage {
    let role: String   // "user" albo "model"
    let text: String
}

enum Gemini {
    static let model = "gemini-3.8-flash"

    private struct Resp: Decodable {
        struct Cand: Decodable {
            struct Content: Decodable {
                struct Part: Decodable { let text: String? }
                let parts: [Part]?
            }
            let content: Content?
        }
        let candidates: [Cand]?
    }

    static func send(messages: [GeminiMessage], system: String, json: Bool = false) async throws -> String {
        let key = (UserDefaults.standard.string(forKey: "geminiKey") ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else { throw GeminiError.noKey }

        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent"
        var req = URLRequest(url: URL(string: endpoint)!)
        req.httpMethod = "POST"
        req.timeoutInterval = 60
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(key, forHTTPHeaderField: "x-goog-api-key")

        var body: [String: Any] = [
            "systemInstruction": ["parts": [["text": system]]],
            "contents": messages.map { ["role": $0.role, "parts": [["text": $0.text]]] }
        ]
        if json {
            body["generationConfig"] = ["responseMimeType": "application/json"]
        }
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GeminiError.badResponse }
        guard http.statusCode == 200 else {
            throw GeminiError.http(http.statusCode, String(data: data, encoding: .utf8) ?? "")
        }
        let decoded = try JSONDecoder().decode(Resp.self, from: data)
        let text = decoded.candidates?.first?.content?.parts?.compactMap(\.text).joined() ?? ""
        guard !text.isEmpty else { throw GeminiError.badResponse }
        return text
    }
}
