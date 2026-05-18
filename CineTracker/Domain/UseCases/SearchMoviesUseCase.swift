//
//  SearchMoviesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct SearchMoviesUseCase: UseCase {
    struct Input {
        let query: String
        let page: Int

        init(query: String, page: Int = 1) {
            self.query = query
            self.page = page
        }
    }

    typealias Output = [Movie]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> [Movie] {
        let trimmed = input.query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count >= 1 else {
            return []
        }

        return try await repository.searchMovies(query: trimmed, page: input.page)
    }
}
