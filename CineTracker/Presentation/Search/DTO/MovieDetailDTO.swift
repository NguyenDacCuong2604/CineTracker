//
//  MovieDetailDTO.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let tagline: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double
    let voteCount: Int
    let genres: [GenreDTO]
    let status: String?
    let originalLanguage: String?
}

struct GenreDTO: Codable {
    let id: Int
    let name: String
}

struct GenreListResponse: Codable {
    let genres: [GenreDTO]
}
