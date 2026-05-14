//
//  SavedMovieObject.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation
import RealmSwift

final class SavedMovieObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var title: String = ""
    @Persisted var overview: String = ""
    @Persisted var posterURLString: String?
    @Persisted var backdropURLString: String?
    @Persisted var releaseDate: Date?
    @Persisted var rating: Double = 0
    @Persisted var voteCount: Int = 0

    @Persisted var statusRaw: Int = 0
    @Persisted var userRating: Double = 0
    @Persisted var userReview: String = ""
    @Persisted var watchedDate: Date?
    @Persisted var addedDate: Date = .init()
    @Persisted var isFavorite: Bool = false

    var status: WatchStatus {
        get { WatchStatus(rawValue: statusRaw) ?? .wantToWatch }
        set { statusRaw = newValue.rawValue }
    }

    enum WatchStatus: Int {
        case wantToWatch = 0
        case watched = 1
    }
}

extension SavedMovieObject {
    convenience init(from movie: Movie) {
        self.init()
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterURLString = movie.posterURL?.absoluteString
        backdropURLString = movie.backdropURL?.absoluteString
        releaseDate = movie.releaseDate
        rating = movie.rating
        voteCount = movie.voteCount
        addedDate = Date()
    }

    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterURL: URL(string: posterURLString ?? ""),
            backdropURL: URL(string: backdropURLString ?? ""),
            releaseDate: releaseDate,
            rating: rating,
            voteCount: voteCount,
            genreIDs: []
        )
    }
}
