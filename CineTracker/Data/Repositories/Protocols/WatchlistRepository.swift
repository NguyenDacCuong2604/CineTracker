//
//  WatchlistRepository.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Combine
import Foundation

protocol WatchlistRepository {
    var savedMoviesPublisher: AnyPublisher<[SavedMovie], Never> { get }
    func add(_ movie: Movie) throws
    func remove(id: Int) throws
    func contains(id: Int) -> Bool
    func markAsWatched(id: Int, rating: Double, review: String) throws
    func toggleFavorite(id: Int) throws
    func all() -> [SavedMovie]
    func filter(by status: SavedMovie.Status?) -> [SavedMovie]
    func search(query: String) -> [SavedMovie]
}
