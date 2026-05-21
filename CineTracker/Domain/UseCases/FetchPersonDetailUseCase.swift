//
//  FetchPersonDetailUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct FetchPersonDetailUseCase: UseCase {
    typealias Input = Int
    typealias Output = Person

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws -> Person {
        try await repository.personDetail(id: input)
    }
}
