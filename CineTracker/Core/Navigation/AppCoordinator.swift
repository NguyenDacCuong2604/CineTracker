//
//  AppCoordinator.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import OSLog
import SwiftUI

@Observable
@MainActor
final class AppCoordinator {
    var discoverPath = NavigationPath()
    var searchPath = NavigationPath()
    var watchlistPath = NavigationPath()
    var statisticsPath = NavigationPath()
    var profilePath = NavigationPath()
    var selectedTab: AppTab = .discover

    func push(_ route: Route, on tab: AppTab) {
        switch tab {
        case .discover: discoverPath.append(route)
        case .search: searchPath.append(route)
        case .watchlist: watchlistPath.append(route)
        case .statistics: statisticsPath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    func popToRoot(tab: AppTab) {
        switch tab {
        case .discover: discoverPath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .watchlist: watchlistPath = NavigationPath()
        case .statistics: statisticsPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }

    func pop(tab: AppTab) {
        switch tab {
        case .discover:
            if !discoverPath.isEmpty { discoverPath.removeLast() }
        case .search:
            if !searchPath.isEmpty { searchPath.removeLast() }
        case .watchlist:
            if !watchlistPath.isEmpty { watchlistPath.removeLast() }
        case .statistics:
            if !statisticsPath.isEmpty { statisticsPath.removeLast() }
        case .profile:
            if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
}

enum AppTab: String, CaseIterable, Hashable {
    case discover
    case search
    case watchlist
    case statistics
    case profile

    var title: String {
        switch self {
        case .discover: return "Khám phá"
        case .search: return "Tìm kiếm"
        case .watchlist: return "Watchlist"
        case .statistics: return "Thống kê"
        case .profile: return "Cá nhân"
        }
    }

    var systemImage: String {
        switch self {
        case .discover: return "popcorn.fill"
        case .search: return "magnifyingglass"
        case .watchlist: return "bookmark.fill"
        case .statistics: return "chart.bar.fill"
        case .profile: return "person.fill"
        }
    }
}

extension AppCoordinator {
    func handle(_ deepLink: DeepLinkResult) {
        selectedTab = deepLink.targetTab
        push(deepLink.route, on: deepLink.targetTab)
        AppLogger.navigation.info("Handled deep link: \(String(describing: deepLink.route)) on \(String(describing: deepLink.targetTab))")
    }
}
