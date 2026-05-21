//
//  PersonMovieCredit.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct PersonMovieCredit: Identifiable, Hashable {
    let id: Int
    let title: String
    let character: String?
    let job: String?
    let posterURL: URL?
    let releaseDate: Date?
    let rating: Double

    func toMovie() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "",
            posterURL: posterURL,
            backdropURL: nil,
            releaseDate: releaseDate,
            rating: rating,
            voteCount: 0,
            genreIDs: []
        )
    }

    var releaseYear: String {
        guard let releaseDate = releaseDate else {
            return "TBA"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: releaseDate)
    }
}
