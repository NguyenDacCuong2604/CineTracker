//
//  PersonMapper.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

enum PersonMapper {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func map(_ dto: PersonDetailDTO) -> Person {
        let profileURL = dto.profilePath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }

        let birthday = dto.birthday.flatMap { dateFormatter.date(from: $0) }
        let deathday = dto.deathday.flatMap { dateFormatter.date(from: $0) }

        return Person(
            id: dto.id,
            name: dto.name,
            biography: dto.biography ?? "",
            birthday: birthday,
            deathday: deathday,
            placeOfBirth: dto.placeOfBirth,
            profileURL: profileURL,
            knownForDepartment: dto.knownForDepartment ?? "Acting",
            popularity: dto.popularity ?? 0
        )
    }
}
