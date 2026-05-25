//
//  ProfileState.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import Foundation

struct ProfileState {
    var totalMoviesInWatchlist: Int = 0
    var totalMoviesWatched: Int = 0
    var cacheSize: String = L10n.Profile.calculatingCache
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
