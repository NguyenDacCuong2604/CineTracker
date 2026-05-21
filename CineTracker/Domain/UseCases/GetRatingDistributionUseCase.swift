//
//  GetRatingDistributionUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetRatingDistributionUseCase: SyncUseCase {
    typealias Input = Void
    typealias Output = [RatingStats]

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_: Void) -> [RatingStats] {
        let watched = repository.allWatchedMovies().filter { $0.userRating > 0 }

        var ratingCounts: [Int: Int] = [:]
        for star in 1 ... 5 {
            ratingCounts[star] = 0
        }
        for movie in watched {
            let rating = Int(movie.userRating.rounded())
            let clamped = max(1, min(5, rating))
            ratingCounts[clamped, default: 0] += 1
        }

        return (1 ... 5).map { star in
            RatingStats(id: star, rating: star, count: ratingCounts[star] ?? 0)
        }
    }
}
