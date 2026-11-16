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
            if code == 408 { return "Groq nie zdążył odpowiedzieć. Stuknij wyślij jeszcze raz." }
            if code == 404 { return "Ten model Groq został wyłączony. Wgraj najnowszą wersję aplikacji, sama wybierze działający." }
            if code == 429 { return "Limit darmowych pytań. Odczekaj minutę." }
            if code == 503 || code == 502 { return "Serwis chwilowo leży (\(code)).\(extra)" }
            return "Serwis nie odpowiedział (\(code)).\(extra)"
        }
    }
}

struct GeminiMessage {
    let role: String
    let text: String
}

enum GeminiRoute { case groqFirst, geminiFirst }

enum Gemini {
    static func send(messages: [GeminiMessage], system: String, json: Bool = false, route: GeminiRoute = .groqFirst) async throws -> String {
        let keys = resolved()
        guard !keys.groq.isEmpty || !keys.gemini.isEmpty else { throw GeminiError.noKey }

        var last: Error = GeminiError.badResponse
        if route == .geminiFirst {
            if let text = try? await geminiChain(key: keys.gemini, messages: messages, system: system, json: json) {
                return text
            }
        }
        if !keys.groq.isEmpty {
            let listed = await groqModels(key: keys.groq)
            let models = listed.isEmpty ? ["openai/gpt-oss-20b", "openai/gpt-oss-120b"] : listed
            for model in models.prefix(2) {
                do { return try await groqSend(key: keys.groq, model: model, messages: messages, system: system, json: json) }
                catch let error as URLError where error.code == .timedOut {
                    last = GeminiError.http(408, "Groq/\(model): czas minął, model myślał za długo.")
                } catch {
                    last = error
                    if let g = error as? GeminiError, case .http(let code, _) = g, code == 401 || code == 403 {
                        throw error
                    }
                }
            }
        }
        if route != .geminiFirst, let text = try? await geminiChain(key: keys.gemini, messages: messages, system: system, json: json) {
            return text
        }
        if route == .geminiFirst, keys.gemini.isEmpty == false {
            do {
                return try await geminiChainThrowing(key: keys.gemini, messages: messages, system: system, json: json)
            } catch {
                last = error
            }
        }
        throw last
    }

    private static let geminiModels = ["gemini-flash-latest", "gemini-2.5-flash", "gemini-3.5-flash"]

    private static func geminiChain(key: String, messages: [GeminiMessage], system: String, json: Bool) async throws -> String? {
        guard !key.isEmpty else { return nil }
        do { return try await geminiChainThrowing(key: key, messages: messages, system: system, json: json) }
        catch { return nil }
    }

    private static func geminiChainThrowing(key: String, messages: [GeminiMessage], system: String, json: Bool) async throws -> String {
        var last: Error = GeminiError.badResponse
        for model in geminiModels {
            do { return try await geminiSend(key: key, model: model, messages: messages, system: system, json: json) }
            catch { last = error }
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
        Secret.load(name).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func groqModels(key: String) async -> [String] {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/models")!)
        req.timeoutInterval = 10
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        guard let (data, resp) = try? await URLSession.shared.data(for: req),
              (resp as? HTTPURLResponse)?.statusCode == 200,
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let rows = obj["data"] as? [[String: Any]] else { return [] }
        let banned = ["whisper", "tts", "guard", "orpheus", "safeguard"]
        let chat = rows.compactMap { $0["id"] as? String }.filter { id in
            let low = id.lowercased()
            return !banned.contains { low.contains($0) }
        }
        let prefer = ["openai/gpt-oss-20b", "openai/gpt-oss-120b"]
        var ordered = prefer.filter { chat.contains($0) }
        ordered += chat.filter { !ordered.contains($0) && !$0.contains("70b") && !$0.contains("3.1-8b") }
        return ordered
    }

    private static func groqSend(key: String, model: String, messages: [GeminiMessage], system: String, json: Bool) async throws -> String {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/chat/completions")!)
        req.httpMethod = "POST"
        req.timeoutInterval = 25
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        var chat: [[String: String]] = [["role": "system", "content": system]]
        chat += messages.map { ["role": $0.role == "model" ? "assistant" : "user", "content": $0.text] }
        var body: [String: Any] = [
            "model": model,
            "messages": chat,
            "temperature": json ? 0.2 : 0.4,
            "max_tokens": json ? 1400 : 500
        ]
        if model.contains("gpt-oss") { body["reasoning_effort"] = "low" }
        req.httpBody = try JSONSerialization.data(withJSONObject: body)
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
        req.timeoutInterval = 12
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

enum GeminiVoice {
    static func clip(for text: String, key: String) async throws -> Data {
        let models = ["gemini-2.5-flash-preview-tts", "gemini-2.5-flash-tts"]
        var last: Error = GeminiError.badResponse
        for model in models {
            do { return try await once(model: model, text: text, key: key) }
            catch { last = error }
        }
        throw last
    }

    private static func once(model: String, text: String, key: String) async throws -> Data {
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent"
        guard let url = URL(string: endpoint) else { throw GeminiError.badResponse }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(key, forHTTPHeaderField: "x-goog-api-key")
        let body: [String: Any] = [
            "contents": [["parts": [["text": "Sprich auf Deutsch, natürlich und zügig, nicht langsam: \(text)"]]]],
            "generationConfig": [
                "responseModalities": ["AUDIO"],
                "speechConfig": [
                    "voiceConfig": [
                        "prebuiltVoiceConfig": ["voiceName": "Charon"]
                    ]
                ]
            ]
        ]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GeminiError.badResponse }
        guard http.statusCode == 200 else {
            let extra = String((String(data: data, encoding: .utf8) ?? "").prefix(80))
            throw GeminiError.http(http.statusCode, "Gemini głos: \(extra)")
        }
        guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = obj["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]] else { throw GeminiError.badResponse }
        for part in parts {
            let inline = part["inlineData"] as? [String: Any] ?? part["inline_data"] as? [String: Any]
            guard let inline, let b64 = inline["data"] as? String, let raw = Data(base64Encoded: b64), !raw.isEmpty else { continue }
            let mime = ((inline["mimeType"] as? String) ?? (inline["mime_type"] as? String) ?? "").lowercased()
            if mime.contains("mpeg") || mime.contains("mp3") || mime.contains("wav") { return raw }
            let digits = mime.split(separator: "=").last.map { String($0.filter(\.isNumber)) } ?? ""
            let rate = Int(digits) ?? 24000
            return wav(pcm: raw, rate: max(rate, 8000))
        }
        throw GeminiError.badResponse
    }

    private static func wav(pcm: Data, rate: Int) -> Data {
        var data = Data()
        func ascii(_ s: String) { data.append(contentsOf: s.utf8) }
        func le32(_ v: UInt32) {
            var x = v.littleEndian
            withUnsafeBytes(of: &x) { data.append(contentsOf: $0) }
        }
        func le16(_ v: UInt16) {
            var x = v.littleEndian
            withUnsafeBytes(of: &x) { data.append(contentsOf: $0) }
        }
        let size = UInt32(pcm.count)
        ascii("RIFF")
        le32(36 + size)
        ascii("WAVE")
        ascii("fmt ")
        le32(16)
        le16(1)
        le16(1)
        le32(UInt32(rate))
        le32(UInt32(rate * 2))
        le16(2)
        le16(16)
        ascii("data")
        le32(size)
        data.append(pcm)
        return data
    }
}

enum Keyboard {
    static func hide() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
