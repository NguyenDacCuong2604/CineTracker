//
//  RestoreToWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct RestoreToWatchlistUseCase: UseCase {
    typealias Input = SavedMovie
    typealias Output = Void

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: SavedMovie) async throws {
        try repository.restore(input)
    }
}
