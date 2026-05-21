//
//  GetWatchingActivityUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetWatchingActivityUseCase: SyncUseCase {
    typealias Input = Void
    typealias Output = [DailyActivity]

    private let repository: WatchlistRepository
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter

    init(repository: WatchlistRepository) {
        self.repository = repository
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func execute(_: Void) -> [DailyActivity] {
        let watched = repository.allWatchedMovies()
        let now = Date()

        let currentYear = calendar.component(.year, from: now)
        var components = DateComponents()
        components.year = currentYear
        components.month = 1
        components.day = 1

        guard let startDate = calendar.date(from: components) else {
            return []
        }

        var countByDate: [String: Int] = [:]
        for movie in watched {
            guard let watchedDate = movie.watchedDate,
                  watchedDate >= startDate
            else {
                continue
            }

            let dateString = dateFormatter.string(from: watchedDate)
            countByDate[dateString, default: 0] += 1
        }

        var activities: [DailyActivity] = []
        var currentDate = startDate

        while currentDate <= now {
            let dateString = dateFormatter.string(from: currentDate)
            let count = countByDate[dateString] ?? 0

            activities.append(DailyActivity(
                id: dateString,
                date: currentDate,
                movieCount: count
            ))

            guard let next = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = next
        }

        return activities
    }
}
