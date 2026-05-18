//
//  SaveRecentSearchUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Foundation

struct SaveRecentSearchUseCase: SyncUseCase {
    typealias Input = String
    typealias Output = Void

    private let repository: RecentSearchesRepository

    init(repository: RecentSearchesRepository) {
        self.repository = repository
    }

    func execute(_ input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return }
        repository.add(trimmed)
    }
}
