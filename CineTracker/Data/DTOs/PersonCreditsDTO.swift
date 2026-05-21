//
//  PersonCreditsDTO.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct PersonCreditsDTO: Codable {
    let cast: [PersonMovieCreditDTO]
    let crew: [PersonMovieCreditDTO]
}

struct PersonMovieCreditDTO: Codable {
    let id: Int
    let title: String
    let character: String?
    let job: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
}
