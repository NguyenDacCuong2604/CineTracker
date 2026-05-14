//
//  Movie.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct Movie: Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let backdropURL: URL?
    let releaseDate: Date?
    let rating: Double
    let voteCount: Int
    let genreIDs: [Int]

    var releaseYear: String {
        guard let date = releaseDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    var ratingFiveScale: Double {
        rating / 2.0
    }
}
