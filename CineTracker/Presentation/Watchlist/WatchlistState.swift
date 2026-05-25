//
//  WatchlistState.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct WatchlistState {
    var movies: [SavedMovie] = []
    var filter: WatchlistFilter = .all
    var sortBy: WatchlistSortOption = .dateAddedDesc
    var query: String = ""
    var displayMode: DisplayMode = .list
    var isEditMode: Bool = false
    var selectedIDs: Set<Int> = []
    var recentlyDeteted: SavedMovie? = nil
    var showUndoToast: Bool = false

    enum DisplayMode {
        case list
        case grid
    }
}

enum WatchlistFilter: Hashable {
    case all
    case wantToWatch
    case watched
    case favorites

    var title: String {
        switch self {
        case .all: return L10n.Watchlist.all
        case .wantToWatch: return L10n.Watchlist.wantToWatch
        case .watched: return L10n.Watchlist.watched
        case .favorites: return L10n.Watchlist.favorites
        }
    }

    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .wantToWatch: return "bookmark"
        case .watched: return "checkmark.circle"
        case .favorites: return "heart"
        }
    }
}
