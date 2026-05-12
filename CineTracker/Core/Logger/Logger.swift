//
//  Logger.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//
import Foundation
import OSLog

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.cinetracker"

    static let app = Logger(subsystem: subsystem, category: "App")
    static let network = Logger(subsystem: subsystem, category: "Network")
    static let database = Logger(subsystem: subsystem, category: "Database")
    static let cache = Logger(subsystem: subsystem, category: "Cache")
    static let ui = Logger(subsystem: subsystem, category: "UI")
    static let navigation = Logger(subsystem: subsystem, category: "Navigation")
    static let auth = Logger(subsystem: subsystem, category: "Auth")
}

extension Logger {
    func verbose(_ message: String) {
        if Configuration.isVerboseLoggingEnabled {
            debug("🔍 \(message)")
        }
    }
}
