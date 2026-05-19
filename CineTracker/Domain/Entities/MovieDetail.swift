//
//  MovieDetail.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct MovieDetail: Identifiable, Hashable {
    let id: Int
    let title: String
    let tagline: String?
    let overview: String
    let posterURL: URL?
    let backdropURL: URL?
    let releaseDate: Date?
    let runtime: Int?
    let rating: Double
    let voteCount: Int
    let genres: [Genre]
    let status: String?
    let originalLanguage: String?

    var formattedRuntime: String {
        guard let runtime = runtime, runtime > 0 else { return "-" }
        let hours = runtime / 60
        let minues = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minues)m"
        }
        return "\(minues)m"
    }

    var releaseYear: String {
        guard let date = releaseDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

    var formattedRating: String {
        String(format: "%.1f", rating)
    }
}

struct Genre: Identifiable, Hashable {
    let id: Int
    let name: String
}
