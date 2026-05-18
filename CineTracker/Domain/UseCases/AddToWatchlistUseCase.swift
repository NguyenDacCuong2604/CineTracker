//
//  AddToWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct AddToWatchlistUseCase: UseCase {
    typealias Input = Movie
    typealias Output = Void

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Movie) async throws {
        try repository.add(input)
    }
}
