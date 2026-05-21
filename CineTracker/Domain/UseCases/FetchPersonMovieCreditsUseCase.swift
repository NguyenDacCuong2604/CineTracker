//
//  FetchPersonMovieCreditsUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct FetchPersonMovieCreditsUseCase: UseCase {
    typealias Input = Int
    typealias Output = [PersonMovieCredit]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws -> [PersonMovieCredit] {
        let credits = try await repository.personMovieCredits(id: input)

        var seenIDs: Set<Int> = []
        let unique = credits.cast.filter { credit in
            if seenIDs.contains(credit.id) { return false }
            seenIDs.insert(credit.id)
            return true
        }

        return unique.sorted { lhs, rhs in
            switch (lhs.releaseDate, rhs.releaseDate) {
            case let (.some(l), .some(r)):
                return l > r
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            case (.none, .none):
                return false
            }
        }
    }
}
