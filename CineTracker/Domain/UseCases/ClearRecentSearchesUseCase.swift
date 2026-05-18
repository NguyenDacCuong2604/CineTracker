//
//  ClearRecentSearchesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Foundation

struct ClearRecentSearchesUseCase: SyncUseCase {
    typealias Input = Void
    typealias Output = Void

    private let repository: RecentSearchesRepository

    init(repository: RecentSearchesRepository) {
        self.repository = repository
    }

    func execute(_: Void) {
        repository.clear()
    }
}
