//
//  AppEnvironment.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//

import Foundation

enum AppEnvironment: String {
    case debug
    case staging
    case production
    /// Read enviroment - Info.plist
    static var current: AppEnvironment {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "APP_ENVIROMENT") as? String,
              let env = AppEnvironment(rawValue: raw)
        else {
            return .debug
        }
        return env
    }

    var isDebug: Bool {
        self == .debug
    }

    var isProduction: Bool {
        self == .production
    }
}
