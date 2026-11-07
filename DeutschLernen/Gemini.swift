import Foundation

enum GeminiError: LocalizedError {
    case noKey, badResponse
    case http(Int, String)

    var errorDescription: String? {
        switch self {
        case .noKey:
            return "Brak klucza. Ustawienia → darmowy klucz Groq (console.groq.com/keys). Karta nie jest potrzebna."
        case .badResponse: return "Pusta odpowiedź. Spróbuj jeszcze raz."
        case .http(let code, _):
            if code == 401 || code == 403 { return "Klucz odrzucony (\(code)). Wklej go jeszcze raz w Ustawieniach." }
            if code == 429 { return "Za dużo pytań na darmowym limicie. Odczekaj minutę." }
            if code == 503 || code == 502 { return "Serwis chwilowo nie działa (\(code)). Spróbuj za chwilę albo drugi klucz w Ustawieniach." }
            return "Serwis nie odpowiedział (\(code))."
        }
    }
}

struct GeminiMessage {
    let role: String
    let text: String
}

enum Gemini {
    static func send(messages: [GeminiMessage], system: String, json: Bool = false) async throws -> String {
        let groq = stored("groqKey")
        let gemini = stored("geminiKey")
        guard !groq.isEmpty || !gemini.isEmpty else { throw GeminiError.noKey }

        var last: Error = GeminiError.badResponse
        if !groq.isEmpty {
            for model in ["openai/gpt-oss-20b", "llama-3.1-8b-instant"] {
                do { return try await groqSend(model: model, messages: messages, system: system) }
                catch { last = error }
            }
        }
        if !gemini.isEmpty {
            for model in ["gemini-3.8-flash", "gemini-2.5-flash-lite", "gemini-2.0-flash"] {
                do { return try await geminiSend(model: model, messages: messages, system: system, json: json) }
                catch let error as GeminiError {
                    last = error
                    if case .http(let code, _) = error, code == 401 || code == 403 { throw error }
                } catch { last = error }
            }
        }
        throw last
    }

    private static func stored(_ name: String) -> String {
        (UserDefaults.standard.string(forKey: name) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func groqSend(model: String, messages: [GeminiMessage], system: String) async throws -> String {
        let key = stored("groqKey")
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/chat/completions")!)
        req.httpMethod = "POST"
        req.timeoutInterval = 60
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        var chat: [[String: String]] = [["role": "system", "content": system]]
        chat += messages.map { ["role": $0.role == "model" ? "assistant" : "user", "content": $0.text] }
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": model,
            "messages": chat,
            "temperature": 0.4
        ])
        return try await text(from: req, path: ["choices", 0, "message", "content"] as [Any])
    }

    private static func geminiSend(model: String, messages: [GeminiMessage], system: String, json: Bool) async throws -> String {
        let key = stored("geminiKey")
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent"
        var req = URLRequest(url: URL(string: endpoint)!)
        req.httpMethod = "POST"
        req.timeoutInterval = 45
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
            throw GeminiError.http(http.statusCode, String(data: data, encoding: .utf8) ?? "")
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

    private static func text(from req: URLRequest, path: [Any]) async throws -> String {
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GeminiError.badResponse }
        guard http.statusCode == 200 else {
            throw GeminiError.http(http.statusCode, String(data: data, encoding: .utf8) ?? "")
        }
        let obj = try JSONSerialization.jsonObject(with: data)
        var cur: Any = obj
        for key in path {
            if let s = key as? String, let d = cur as? [String: Any] { cur = d[s] ?? "" }
            else if let i = key as? Int, let a = cur as? [Any], a.indices.contains(i) { cur = a[i] }
            else { throw GeminiError.badResponse }
        }
        let text = (cur as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { throw GeminiError.badResponse }
        return text
    }
}

enum Keyboard {
    static func hide() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
