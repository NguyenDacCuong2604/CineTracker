//
//  FetchTopRatedMoviesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct FetchTopRatedMoviesUseCase: UseCase {
    struct Input {
        let page: Int
        let forceRefresh: Bool

        init(page: Int = 1, forceRefresh: Bool = false) {
            self.page = page
            self.forceRefresh = forceRefresh
        }
    }

    typealias Output = [Movie]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> [Movie] {
        try await repository.topRatedMovies(page: input.page, forceRefresh: input.forceRefresh)
    }
}
