//
//  IsInWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct IsInWatchlistUseCase: SyncUseCase {
    typealias Input = Int
    typealias Output = Bool

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) -> Bool {
        repository.contains(id: input)
    }
}
