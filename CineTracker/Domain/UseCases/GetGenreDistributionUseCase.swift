//
//  GetGenreDistributionUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetGenreDistributionUseCase: SyncUseCase {
    typealias Input = Void
    typealias Output = [GenreStats]

    private static func genreName(for id: Int) -> String? {
        switch id {
        case 28: return L10n.Genre.action
        case 12: return L10n.Genre.adventure
        case 16: return L10n.Genre.animation
        case 35: return L10n.Genre.comedy
        case 80: return L10n.Genre.crime
        case 99: return L10n.Genre.documentary
        case 18: return L10n.Genre.drama
        case 10751: return L10n.Genre.family
        case 14: return L10n.Genre.fantasy
        case 36: return L10n.Genre.history
        case 27: return L10n.Genre.horror
        case 10402: return L10n.Genre.music
        case 9648: return L10n.Genre.mystery
        case 10749: return L10n.Genre.romance
        case 878: return L10n.Genre.scienceFiction
        case 53: return L10n.Genre.thriller
        case 10752: return L10n.Genre.war
        case 37: return L10n.Genre.western
        default: return nil
        }
    }

    private let repository: WatchlistRepository
    private static let topCount = 7

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_: Void) -> [GenreStats] {
        let watched = repository.allWatchedMovies()

        var genreCounts: [Int: Int] = [:]
        for movie in watched {
            for genreID in movie.movie.genreIDs {
                genreCounts[genreID, default: 0] += 1
            }
        }

        let totalCount = genreCounts.values.reduce(0, +)
        guard totalCount > 0 else { return [] }

        var stats = genreCounts.map { id, count in
            GenreStats(
                id: id,
                name: Self.genreName(for: id) ?? L10n.Genre.other,
                count: count,
                percentage: Double(count) / Double(totalCount) * 100
            )
        }
        .sorted { $0.count > $1.count }

        if stats.count > Self.topCount {
            let topStats = Array(stats.prefix(Self.topCount))
            let restCount = stats.dropFirst(Self.topCount).reduce(0) { $0 + $1.count }

            stats = topStats + [
                GenreStats(
                    id: -1,
                    name: L10n.Genre.other,
                    count: restCount,
                    percentage: Double(restCount) / Double(totalCount) * 100
                ),
            ]
        }

        return stats
    }
}
