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
    func batchRemove(ids: [Int]) throws
    func restore(_ savedMovie: SavedMovie) throws
    func filteredMovies(status: SavedMovie.Status?, sortBy: WatchlistSortOption, query: String) -> [SavedMovie]
    func savedMovie(id: Int) -> SavedMovie?
    func allWatchedMovies() -> [SavedMovie]
    func allFavoriteMovies() -> [SavedMovie]
}

enum WatchlistSortOption: CaseIterable {
    case dateAddedDesc
    case dateAddedAsc
    case ratingDesc
    case ratingAsc
    case titleAsc
    case titleDesc
    case releaseDateDesc
    case releaseDateAsc

    var title: String {
        switch self {
        case .dateAddedDesc: return L10n.WatchlistSort.dateAddedDesc
        case .dateAddedAsc: return L10n.WatchlistSort.dateAddedAsc
        case .ratingDesc: return L10n.WatchlistSort.ratingDesc
        case .ratingAsc: return L10n.WatchlistSort.ratingAsc
        case .titleAsc: return L10n.WatchlistSort.titleAsc
        case .titleDesc: return L10n.WatchlistSort.titleDesc
        case .releaseDateDesc: return L10n.WatchlistSort.releaseDateDesc
        case .releaseDateAsc: return L10n.WatchlistSort.releaseDateAsc
        }
    }

    var sfSymbol: String {
        switch self {
        case .dateAddedDesc, .dateAddedAsc: return "calendar"
        case .ratingDesc, .ratingAsc: return "star"
        case .titleDesc, .titleAsc: return "textformat"
        case .releaseDateDesc, .releaseDateAsc: return "film"
        }
    }
}
