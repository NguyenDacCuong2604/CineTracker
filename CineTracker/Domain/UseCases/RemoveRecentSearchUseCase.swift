//
//  RemoveRecentSearchUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Foundation

struct RemoveRecentSearchUseCase: SyncUseCase {
    typealias Input = String
    typealias Output = Void

    private let repository: RecentSearchesRepository

    init(repository: RecentSearchesRepository) {
        self.repository = repository
    }

    func execute(_ input: String) {
        repository.remove(input)
    }
}
