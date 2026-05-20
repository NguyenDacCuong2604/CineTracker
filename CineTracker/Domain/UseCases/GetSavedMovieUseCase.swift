//
//  GetSavedMovieUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct GetSavedMovieUseCase: SyncUseCase {
    typealias Input = Int
    typealias Output = SavedMovie?

    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(_ input: Int) -> SavedMovie? {
        repository.savedMovie(id: input)
    }
}
