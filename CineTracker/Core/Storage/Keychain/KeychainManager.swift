//
//  KeychainManager.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//

import Foundation
import OSLog
import Security

final class KeychainManager {
    // singleton
    static let shared = KeychainManager()
    private init() {}

    enum Key: String {
        case tmdbAPIKey = "com.cinetracker.tmdb.apikey"
        case userToken = "com.cinetracker.user.token"
    }

    enum KeychainError: Error, LocalizedError {
        case duplicateItem
        case itemNotFound
        case unhandled(OSStatus)
        case invalidData
        var errorDescription: String? {
            switch self {
            case .duplicateItem: return "Item already exists in Keychain"
            case .itemNotFound: return "Item not found in Keychain"
            case let .unhandled(status): return "Keychain error: \(status)"
            case .invalidData: return "Invalid data format"
            }
        }
    }
    func save(_ value: String, for key: Key) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try? delete(key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandled(status)
        }
        AppLogger.auth.debug("Saved item for key: \(key.rawValue)")
    }
    func read(_ key: Key) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandled(status)
        }
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8)
        else {
            throw KeychainError.invalidData
        }
        return value
    }

    func delete(_ key: Key) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandled(status)
        }
    }
    func exists(_ key: Key) -> Bool {
        (try? read(key)) != nil
    }
}
