//
//  FetchMovieVideosUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct FetchMovieVideosUseCase: UseCase {
    typealias Input = Int
    typealias Output = [Video]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws -> [Video] {
        try await repository.movieVideos(id: input)
    }
}
