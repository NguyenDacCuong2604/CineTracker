//
//  MarkAsWatchedUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct MarkAsWatchedUseCase: UseCase {
    struct Input {
        let movieID: Int
        let rating: Double
        let review: String
    }

    typealias Output = Void

    enum Error: Swift.Error, LocalizedError {
        case invalidRating
        case reviewTooLong

        var errorDescription: String? {
            switch self {
            case .invalidRating: return "Rating phai trong khoang 0-5"
            case .reviewTooLong: return "Review toi da 1000 ky tu"
            }
        }
    }

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws {
        guard (0 ... 5).contains(input.rating) else {
            throw Error.invalidRating
        }
        guard input.review.count <= 1000 else {
            throw Error.reviewTooLong
        }
        try repository.markAsWatched(id: input.movieID, rating: input.rating, review: input.review)
    }
}
