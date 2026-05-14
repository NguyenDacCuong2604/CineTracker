//
//  SavedMovieRealmMapper.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

enum SavedMovierealmMapper {
    static func toDomain(_ object: SavedMovieObject) -> SavedMovie {
        SavedMovie(
            id: object.id,
            movie: Movie(
                id: object.id,
                title: object.title,
                overview: object.overview,
                posterURL: URL(string: object.posterURLString ?? ""),
                backdropURL: URL(string: object.backdropURLString ?? ""),
                releaseDate: object.releaseDate,
                rating: object.rating,
                voteCount: object.voteCount,
                genreIDs: []
            ),
            status: SavedMovie.Status(rawValue: object.statusRaw) ?? .wantToWatch,
            userRating: object.userRating,
            userReview: object.userReview,
            watchedDate: object.watchedDate,
            addedDate: object.addedDate,
            isFavorite: object.isFavorite
        )
    }
    
    static func toRealmObject(_ movie: Movie) -> SavedMovieObject {
        let object = SavedMovieObject()
        object.id = movie.id
        object.title = movie.title
        object.overview = movie.overview
        object.posterURLString = movie.posterURL?.absoluteString
        object.backdropURLString = movie.backdropURL?.absoluteString
        object.releaseDate = movie.releaseDate
        object.rating = movie.rating
        object.voteCount = movie.voteCount
        object.addedDate = Date()
        return object
    }
}
