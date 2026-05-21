//
//  GetStatisticsUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetStatisticsUseCase: SyncUseCase {
    typealias Input = Void
    typealias Output = Statistics

    private let repository: WatchlistRepository
    private let movieRepository: MovieRepository

    init(repository: WatchlistRepository, movieRepository: MovieRepository) {
        self.repository = repository
        self.movieRepository = movieRepository
    }

    func execute(_: Void) -> Statistics {
        let allMovies = repository.all()

        let watched = allMovies.filter { $0.status == .watched }
        let wantToWatch = allMovies.filter { $0.status == .wantToWatch }
        let favorites = allMovies.filter { $0.isFavorite }

        let ratedMovies = watched.filter { $0.userRating > 0 }
        let avgRating: Double = ratedMovies.isEmpty ?
            0 : ratedMovies.reduce(0.0) { $0 + $1.userRating } / Double(ratedMovies.count)

        let totalMinutes = watched.count * 120

        return Statistics(
            totalMovies: allMovies.count,
            totalWatched: watched.count,
            totalWantToWatch: wantToWatch.count,
            totalFavorites: favorites.count,
            totalMinutesWatched: totalMinutes,
            averageUserRating: avgRating
        )
    }
}
