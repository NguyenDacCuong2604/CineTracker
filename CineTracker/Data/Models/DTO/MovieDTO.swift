//
//  MovieDTO.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

struct MovieDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double?
    let originalLanguage: String?
    let genreIds: [Int]?
}

struct PagedResponse<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}
