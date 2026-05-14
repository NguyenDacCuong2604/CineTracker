//
//  RealmManager.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation
import OSLog
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    static let currentSchemaVersion: UInt64 = 1

    private init() {
        configureRealm()
    }

    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: Self.currentSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                Self.performMigration(
                    migration: migration,
                    oldVersion: oldSchemaVersion
                )
            }
        )

        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm()
            AppLogger.database.info("Realm initialized at: \(realm.configuration.fileURL?.path ?? "unknown")")
        } catch {
            AppLogger.database.error("Realm init failed: \(error)")
        }
    }

    private static func performMigration(migration _: Migration, oldVersion: UInt64) {
        AppLogger.database.info("Migrating Realm from v\(oldVersion) to v\(currentSchemaVersion)")

        // When change schema, add migration logic
        // ...
    }

    @MainActor
    func realm() throws -> Realm {
        try Realm()
    }

    #if DEBUG
        func reset() throws {
            guard let realm = try? Realm() else { return }
            try realm.write {
                realm.deleteAll()
            }
            AppLogger.database.warning("Realm reset (all data deleted)")
        }
    #endif
}
