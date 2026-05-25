//
//  RealmConfig.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//
import Foundation
import RealmSwift

enum RealmConfig {
    private static let appGroupID = "group.codewithcuongnd.CineTracker"

    static var defaultConfiguration: Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration

        if let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) {
            let realmURL = containerURL.appendingPathComponent("default.realm")
            config.fileURL = realmURL
            print("✅ Realm using App Group: \(realmURL.path)")
        } else {
            print("⚠️ App Group not accessible. Using local container.")
            print("⚠️ Widget will NOT see this data.")
        }

        config.schemaVersion = 1
        config.migrationBlock = { _, _ in
        }

        return config
    }

    static func configure() {
        Realm.Configuration.defaultConfiguration = defaultConfiguration
    }
}
