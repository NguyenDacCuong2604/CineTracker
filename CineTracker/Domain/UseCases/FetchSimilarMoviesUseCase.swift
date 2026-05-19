//
//  FetchSimilarMoviesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct FetchSimilarMoviesUseCase: UseCase {
    struct Input {
        let movieID: Int
        let page: Int

        init(movieID: Int, page: Int = 1) {
            self.movieID = movieID
            self.page = page
        }
    }

    typealias Output = [Movie]

    private static let maxResults = 10

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> [Movie] {
        let movies = try await repository.similarMovies(
            id: input.movieID,
            page: input.page
        )
        return Array(movies.prefix(Self.maxResults))
    }
}
