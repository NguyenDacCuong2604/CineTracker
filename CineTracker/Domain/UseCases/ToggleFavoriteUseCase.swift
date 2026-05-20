//
//  ToggleFavoriteUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct ToggleFavoriteUseCase: UseCase {
    typealias Input = Int
    typealias Output = Void

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws {
        try repository.toggleFavorite(id: input)
    }
}
