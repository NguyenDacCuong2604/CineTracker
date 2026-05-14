//
//  SavedMovie.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct SavedMovie: Identifiable, Hashable {
    let id: Int
    let movie: Movie
    let status: Status
    let userRating: Double
    let userReview: String
    let watchedDate: Date?
    let addedDate: Date
    let isFavorite: Bool

    enum Status: Int {
        case wantToWatch = 0
        case watched = 1

        var title: String {
            switch self {
            case .wantToWatch: return "Muốn xem"
            case .watched: return "Đã xem"
            }
        }
    }
}

extension SavedMovieObject {
    func toSavedMovie() -> SavedMovie {
        SavedMovie(
            id: id,
            movie: toDomain(),
            status: SavedMovie.Status(rawValue: statusRaw) ?? .wantToWatch,
            userRating: userRating,
            userReview: userReview,
            watchedDate: watchedDate,
            addedDate: addedDate,
            isFavorite: isFavorite
        )
    }
}
