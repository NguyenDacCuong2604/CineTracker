//
//  DiscoverState.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct DiscoverState {
    var trending: SectionState<Movie> = .idle
    var popular: SectionState<Movie> = .idle
    var topRated: SectionState<Movie> = .idle
    var upcoming: SectionState<Movie> = .idle
    var nowPlaying: SectionState<Movie> = .idle

    var isRefreshing: Bool = false

    var allSectionsLoaded: Bool {
        [trending, popular, topRated, upcoming, nowPlaying]
            .allSatisfy { $0.isLoadedOrError }
    }
}

enum SectionState<T> {
    case idle
    case loading
    case loaded([T])
    case error(Error)

    var isLoadedOrError: Bool {
        if case .loaded = self { return true }
        if case .error = self { return true }
        return false
    }

    var items: [T] {
        if case let .loaded(items) = self { return items }
        return []
    }
}
