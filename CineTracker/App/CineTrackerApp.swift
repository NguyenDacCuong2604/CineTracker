//
//  CineTrackerApp.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//

import OSLog
import RealmSwift
import SwiftUI

@main
struct CineTrackerApp: App {
    init() {
        setupApp()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }

    private func setupApp() {
        AppLogger.app.info("🚀 App started")
        AppLogger.app.info("Environment: \(AppEnvironment.current.rawValue)")
        AppLogger.app.info("Bundle ID: \(Bundle.main.bundleIdentifier ?? "unknown")")

        AppLogger.app.info("TMDB Base URL: \(Configuration.tmdbBaseURL.absoluteString)")

        migrateAPIKeyIfNeeded()

        testKeychain()

        testRealm()
    }

    private func migrateAPIKeyIfNeeded() {
        guard !KeychainManager.shared.exists(.tmdbAPIKey) else {
            AppLogger.auth.debug("API key already in Keychain")
            return
        }

        do {
            let apiKey = Configuration.tmdbAPIKey
            try KeychainManager.shared.save(apiKey, for: .tmdbAPIKey)
            AppLogger.auth.info("✅ API key migrated to Keychain")
        } catch {
            AppLogger.auth.error("❌ Failed to migrate API key: \(error.localizedDescription)")
        }
    }

    private func testKeychain() {
        do {
            let key = try KeychainManager.shared.read(.tmdbAPIKey)
            let prefix = String(key.prefix(4))
            AppLogger.auth.info("✅ Keychain test passed. Key prefix: \(prefix)***")
        } catch {
            AppLogger.auth.error("❌ Keychain test failed: \(error.localizedDescription)")
        }
    }

    private func testRealm() {
        do {
            let realm = try Realm()
            AppLogger.database.info("✅ Realm initialized at: \(realm.configuration.fileURL?.path ?? "unknown")")
        } catch {
            AppLogger.database.error("❌ Realm init failed: \(error.localizedDescription)")
        }
    }
}
