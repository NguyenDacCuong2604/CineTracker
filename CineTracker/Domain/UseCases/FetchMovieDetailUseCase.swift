//
//  FetchMovieDetailUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct FetchMovieDetailUseCase: UseCase {
    struct Input {
        let id: Int
        let forceRefresh: Bool

        init(id: Int, forceRefresh: Bool = false) {
            self.id = id
            self.forceRefresh = forceRefresh
        }
    }

    typealias Output = MovieDetail

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> MovieDetail {
        try await repository.movieDetail(id: input.id, forceRefresh: input.forceRefresh)
    }
}
