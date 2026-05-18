//
//  GetRecentSearchesUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Combine
import Foundation

struct GetRecentSearchesUseCase {
    private let repository: RecentSearchesRepository

    init(repository: RecentSearchesRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[String], Never> {
        repository.recentSearchesPublisher
    }
}
