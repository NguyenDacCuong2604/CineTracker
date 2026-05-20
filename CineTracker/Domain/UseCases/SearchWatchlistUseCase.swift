//
//  SearchWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct SearchWatchlistUseCase: SyncUseCase {
    struct Input {
        let query: String
        let status: SavedMovie.Status?
        let sortBy: WatchlistSortOption
    }

    typealias Output = [SavedMovie]

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) -> [SavedMovie] {
        repository.filteredMovies(status: input.status, sortBy: input.sortBy, query: input.query)
    }
}
