//
//  LocalizationManager.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//
import Combine
import Foundation
import SwiftUI

@Observable
final class LocalizationManager {
    static let shared = LocalizationManager()

    enum Language: String, CaseIterable, Identifiable {
        case vietnamese = "vi"
        case english = "en"

        var id: String {
            rawValue
        }

        var displayName: String {
            switch self {
            case .vietnamese: return "Tiếng Việt"
            case .english: return "English"
            }
        }

        var flag: String {
            switch self {
            case .vietnamese: return "🇻🇳"
            case .english: return "🇺🇸"
            }
        }
    }

    private(set) var currentLanguage: Language

    private var bundle: Bundle = .main

    private static let storageKey = "appLanguage"

    private init() {
        let saved = UserDefaults.standard.string(forKey: Self.storageKey)
        if let saved = saved, let lang = Language(rawValue: saved) {
            currentLanguage = lang
        } else {
            let systemLang = Locale.current.language.languageCode?.identifier ?? "vi"
            currentLanguage = Language(rawValue: systemLang) ?? .vietnamese
        }

        updateBundle()
    }

    func setLanguage(_ language: Language) {
        guard language != currentLanguage else { return }

        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: Self.storageKey)
        updateBundle()
    }

    func localizedString(forKey key: String, defaultValue: String = "") -> String {
        bundle.localizedString(forKey: key, value: defaultValue, table: nil)
    }

    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            bundle = .main
            return
        }
        self.bundle = bundle
    }
}
