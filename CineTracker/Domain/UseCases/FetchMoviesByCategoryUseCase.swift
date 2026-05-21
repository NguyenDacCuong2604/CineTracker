//
//  FetchMoviesByCategoryUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct FetchMoviesByCategoryUseCase: UseCase {
    struct Input {
        let category: Route.MovieCategory
        let page: Int
        let forceRefresh: Bool

        init(category: Route.MovieCategory, page: Int = 1, forceRefresh: Bool = false) {
            self.category = category
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
        switch input.category {
        case .trending, .popular:
            return try await repository.popularMovies(
                page: input.page,
                forceRefresh: input.forceRefresh
            )
        case .topRated:
            return try await repository.topRatedMovies(
                page: input.page,
                forceRefresh: input.forceRefresh
            )
        case .upcoming:
            return try await repository.upcomingMovies(
                page: input.page,
                forceRefresh: input.forceRefresh
            )
        case .nowPlaying:
            return try await repository.nowPlayingMovies(
                page: input.page,
                forceRefresh: input.forceRefresh
            )
        }
    }
}
