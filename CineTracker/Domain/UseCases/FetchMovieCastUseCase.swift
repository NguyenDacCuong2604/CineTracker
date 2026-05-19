//
//  FetchMovieCastUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct FetchMovieCastUseCase: UseCase {
    typealias Input = Int
    typealias Output = [Cast]

    private static let maxCastMembers = 20

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws -> [Cast] {
        let allCast = try await repository.movieCast(id: input)
        return Array(allCast.prefix(Self.maxCastMembers))
    }
}
