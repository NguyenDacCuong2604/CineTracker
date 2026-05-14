//
//  MovieMapper.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

enum MovieMapper {
    static func map(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview ?? "",
            posterURL: imageURL(path: dto.posterPath, size: .poster),
            backdropURL: imageURL(path: dto.backdropPath, size: .backdrop),
            releaseDate: parseDate(dto.releaseDate),
            rating: dto.voteAverage,
            voteCount: dto.voteCount,
            genreIDs: dto.genreIds ?? []
        )
    }

    static func map(_ dtos: [MovieDTO]) -> [Movie] {
        dtos.map { map($0) }
    }

    static func map(_ dto: MovieDetailDTO) -> MovieDetail {
        MovieDetail(
            id: dto.id,
            title: dto.title,
            tagline: dto.tagline?.isEmpty == true ? nil : dto.tagline,
            overview: dto.overview ?? "",
            posterURL: imageURL(path: dto.posterPath, size: .poster),
            backdropURL: imageURL(path: dto.backdropPath, size: .backdrop),
            releaseDate: parseDate(dto.releaseDate),
            runtime: dto.runtime,
            rating: dto.voteAverage,
            voteCount: dto.voteCount,
            genres: dto.genres.map { Genre(id: $0.id, name: $0.name) },
            status: dto.status,
            originalLanguage: dto.originalLanguage
        )
    }

    static func map(_ dto: CastDTO) -> Cast {
        Cast(
            id: dto.id,
            name: dto.name,
            character: dto.character,
            profileURL: imageURL(path: dto.profilePath, size: .profile),
            order: dto.order
        )
    }

    static func map(_ dtos: [CastDTO]) -> [Cast] {
        dtos
            .filter { !$0.character.isEmpty }
            .sorted { $0.order < $1.order }
            .map { map($0) }
    }

    enum ImageSize: String {
        case poster = "w500"
        case backdrop = "w780"
        case profile = "w185"
        case original
    }

    static func imageURL(path: String?, size: ImageSize) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        let base = Configuration.tmdbImageBaseURL
        return base
            .appendingPathComponent(size.rawValue)
            .appendingPathComponent(path)
    }

    private static func parseDate(_ string: String?) -> Date? {
        guard let string = string, !string.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
}
