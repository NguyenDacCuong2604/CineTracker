//
//  PersonDetailDTO.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct PersonDetailDTO: Codable {
    let id: Int
    let name: String
    let biography: String?
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let profilePath: String?
    let knownForDepartment: String?
    let popularity: Double?
}
