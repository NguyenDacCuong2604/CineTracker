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
}

enum WatchlistSortOption: String, CaseIterable {
    case dateAddedDesc = "Mới thêm gần đây"
    case dateAddedAsc = "Thêm lâu nhất"
    case ratingDesc = "Rating cao nhất"
    case ratingAsc = "Rating thấp nhất"
    case titleDesc = "Tên A-Z"
    case titleAsc = "Tên Z-A"
    case releaseDateDesc = "Mới phát hành"
    case releaseDateAsc = "Cũ nhất"

    var sfSymbol: String {
        switch self {
        case .dateAddedDesc, .dateAddedAsc: return "calendar"
        case .ratingDesc, .ratingAsc: return "star"
        case .titleDesc, .titleAsc: return "textformat"
        case .releaseDateDesc, .releaseDateAsc: return "film"
        }
    }
}
