//
//  GetTopRatedMoviesByUserUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetTopRatedMoviesByUserUseCase: SyncUseCase {
    typealias Input = Int
    typealias Output = [SavedMovie]

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Int = 15) -> [SavedMovie] {
        let watched = repository.allWatchedMovies()
            .filter { $0.userRating > 0 }
            .sorted { lhs, rhs in
                if lhs.userRating != rhs.userRating {
                    return lhs.userRating > rhs.userRating
                }
                return (lhs.watchedDate ?? .distantPast) > (rhs.watchedDate ?? .distantPast)
            }

        return Array(watched.prefix(input))
    }
}
