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

    private static let genres: [Int: String] = [
        28: "Hành động",
        12: "Phiêu lưu",
        16: "Hoạt hình",
        35: "Hài",
        80: "Tội phạm",
        99: "Tài liệu",
        18: "Chính kịch",
        10751: "Gia đình",
        14: "Giả tưởng",
        36: "Lịch sử",
        27: "Kinh dị",
        10402: "Âm nhạc",
        9648: "Bí ẩn",
        10749: "Lãng mạn",
        878: "Khoa học viễn tưởng",
        53: "Giật gân",
        10752: "Chiến tranh",
        37: "Cao bồi",
    ]

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
                name: Self.genres[id] ?? "Khác",
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
                    name: "Khác",
                    count: restCount,
                    percentage: Double(restCount) / Double(totalCount) * 100
                ),
            ]
        }

        return stats
    }
}
