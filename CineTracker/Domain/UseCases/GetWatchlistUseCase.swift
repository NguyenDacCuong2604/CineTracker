//
//  GetWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//
import Combine
import Foundation

struct GetWatchlistUseCase {
    private let repository: WatchlistRepository

    init(repository: WatchlistRepository) {
        self.repository = repository
    }

    func execute(filter: SavedMovie.Status? = nil) -> AnyPublisher<[SavedMovie], Never> {
        repository.savedMoviesPublisher
            .map { movies in
                guard let filter = filter else { return movies }
                return movies.filter { $0.status == filter }
            }
            .eraseToAnyPublisher()
    }
}
