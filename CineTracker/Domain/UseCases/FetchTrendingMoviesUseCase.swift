//
//  FetchTrendingMoviesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct FetchTrendingMoviesUseCase: UseCase {
    struct Input {
        let limit: Int
        init(limit: Int = 5) {
            self.limit = limit
        }
    }

    typealias Output = [Movie]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> [Movie] {
        let movies = try await repository.popularMovies(page: 1, forceRefresh: false)

        return Array(movies.prefix(input.limit))
    }
}
