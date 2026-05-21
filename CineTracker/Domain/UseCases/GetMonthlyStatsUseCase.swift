//
//  GetMonthlyStatsUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetMonthlyStatsUseCase: SyncUseCase {
    typealias Input = Int
    typealias Output = [MonthlyStats]

    private let repository: WatchlistRepository
    private let calendar = Calendar.current

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Int = 12) -> [MonthlyStats] {
        let watched = repository.allWatchedMovies()
        let now = Date()

        var result: [MonthlyStats] = []

        for monthOffset in (0 ..< input).reversed() {
            guard let date = calendar.date(byAdding: .month, value: -monthOffset, to: now) else {
                continue
            }

            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)

            let count = watched.filter { movie in
                guard let watchedDate = movie.watchedDate else { return false }
                let movieYear = calendar.component(.year, from: watchedDate)
                let movieMonth = calendar.component(.month, from: watchedDate)

                return movieYear == year && movieMonth == month
            }.count

            let id = String(format: "%04d-%02d", year, month)
            result.append(MonthlyStats(id: id, year: year, month: month, count: count))
        }

        return result
    }
}
