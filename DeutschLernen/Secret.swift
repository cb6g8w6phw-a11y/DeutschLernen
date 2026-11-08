import Foundation
import Security

enum Secret {
    static func load(_ key: String) -> String {
        if let saved = read(key) { return saved }
        let old = UserDefaults.standard.string(forKey: key) ?? ""
        if !old.isEmpty {
            save(old, key)
            UserDefaults.standard.removeObject(forKey: key)
        }
        return old
    }

    static func save(_ value: String, _ key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "DeutschLernen"
        ]
        SecItemDelete(query as CFDictionary)
        var add = query
        add[kSecValueData as String] = data
        SecItemAdd(add as CFDictionary, nil)
    }

    private static func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "DeutschLernen",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let text = String(data: data, encoding: .utf8) else { return nil }
        return text
    }
}
