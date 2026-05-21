//
//  PersonMovieCreditMapper.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

enum PersonMovieCreditMapper {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func mapCast(_ dto: PersonMovieCreditDTO) -> PersonMovieCredit {
        PersonMovieCredit(
            id: dto.id,
            title: dto.title,
            character: dto.character,
            job: nil,
            posterURL: posterURL(from: dto.posterPath),
            releaseDate: dto.releaseDate.flatMap { dateFormatter.date(from: $0) },
            rating: dto.voteAverage ?? 0
        )
    }

    static func mapCrew(_ dto: PersonMovieCreditDTO) -> PersonMovieCredit {
        PersonMovieCredit(
            id: dto.id,
            title: dto.title,
            character: nil,
            job: dto.job,
            posterURL: posterURL(from: dto.posterPath),
            releaseDate: dto.releaseDate.flatMap { dateFormatter.date(from: $0) },
            rating: dto.voteAverage ?? 0
        )
    }

    private static func posterURL(from path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
