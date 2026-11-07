import Foundation
import UIKit

enum GeminiError: LocalizedError {
    case noKey, badResponse
    case http(Int, String)

    var errorDescription: String? {
        switch self {
        case .noKey:
            return "Brak klucza. Ustawienia → darmowy klucz Groq (console.groq.com/keys). Karta nie jest potrzebna."
        case .badResponse: return "Pusta odpowiedź. Spróbuj jeszcze raz."
        case .http(let code, let detail):
            let extra = detail.isEmpty ? "" : " \(detail)"
            if code == 401 || code == 403 { return "Klucz odrzucony (\(code)). Groq zaczyna się od gsk_, Gemini od AIza. Wklej w odpowiednie pole.\(extra)" }
            if code == 429 { return "Limit darmowych pytań. Odczekaj minutę.\(extra)" }
            if code == 503 || code == 502 { return "Serwis chwilowo leży (\(code)).\(extra)" }
            return "Serwis nie odpowiedział (\(code)).\(extra)"
        }
    }
}

struct GeminiMessage {
    let role: String
    let text: String
}

enum Gemini {
    static func send(messages: [GeminiMessage], system: String, json: Bool = false) async throws -> String {
        let keys = resolved()
        guard !keys.groq.isEmpty || !keys.gemini.isEmpty else { throw GeminiError.noKey }

        var last: Error = GeminiError.badResponse
        if !keys.groq.isEmpty {
            for model in ["llama-3.1-8b-instant", "llama-3.3-70b-versatile"] {
                do { return try await groqSend(key: keys.groq, model: model, messages: messages, system: system) }
                catch { last = error }
            }
        }
        if !keys.gemini.isEmpty {
            for model in ["gemini-2.0-flash", "gemini-3.8-flash"] {
                do { return try await geminiSend(key: keys.gemini, model: model, messages: messages, system: system, json: json) }
                catch { last = error }
            }
        }
        throw last
    }

    private static func resolved() -> (groq: String, gemini: String) {
        var groq = stored("groqKey")
        var gemini = stored("geminiKey")
        if groq.hasPrefix("AIza"), gemini.isEmpty { gemini = groq; groq = "" }
        if gemini.hasPrefix("gsk_"), groq.isEmpty { groq = gemini; gemini = "" }
        return (groq, gemini)
    }

    private static func stored(_ name: String) -> String {
        (UserDefaults.standard.string(forKey: name) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func groqSend(key: String, model: String, messages: [GeminiMessage], system: String) async throws -> String {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/chat/completions")!)
        req.httpMethod = "POST"
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        var chat: [[String: String]] = [["role": "system", "content": system]]
        chat += messages.map { ["role": $0.role == "model" ? "assistant" : "user", "content": $0.text] }
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": model,
            "messages": chat,
            "temperature": 0.4
        ])
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GeminiError.badResponse }
        guard http.statusCode == 200 else {
            throw GeminiError.http(http.statusCode, "Groq/\(model): \(snippet(data))")
        }
        guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = obj["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any] else { throw GeminiError.badResponse }
        let content = (message["content"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !content.isEmpty { return content }
        let reasoning = (message["reasoning"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !reasoning.isEmpty else { throw GeminiError.badResponse }
        return reasoning
    }

    private static func geminiSend(key: String, model: String, messages: [GeminiMessage], system: String, json: Bool) async throws -> String {
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent"
        var req = URLRequest(url: URL(string: endpoint)!)
        req.httpMethod = "POST"
        req.timeoutInterval = 18
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(key, forHTTPHeaderField: "x-goog-api-key")
        var body: [String: Any] = [
            "systemInstruction": ["parts": [["text": system]]],
            "contents": messages.map { ["role": $0.role == "assistant" ? "model" : $0.role, "parts": [["text": $0.text]]] }
        ]
        if json { body["generationConfig"] = ["responseMimeType": "application/json"] }
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GeminiError.badResponse }
        guard http.statusCode == 200 else {
            throw GeminiError.http(http.statusCode, "Gemini/\(model): \(snippet(data))")
        }
        struct Resp: Decodable {
            struct Cand: Decodable {
                struct Content: Decodable {
                    struct Part: Decodable { let text: String? }
                    let parts: [Part]?
                }
                let content: Content?
            }
            let candidates: [Cand]?
        }
        let text = try JSONDecoder().decode(Resp.self, from: data)
            .candidates?.first?.content?.parts?.compactMap(\.text).joined() ?? ""
        guard !text.isEmpty else { throw GeminiError.badResponse }
        return text
    }

    private static func snippet(_ data: Data) -> String {
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return String((String(data: data, encoding: .utf8) ?? "").prefix(90))
        }
        if let err = obj["error"] as? [String: Any], let m = err["message"] as? String { return String(m.prefix(110)) }
        if let err = obj["error"] as? String { return String(err.prefix(110)) }
        return ""
    }
}

enum Keyboard {
    static func hide() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
