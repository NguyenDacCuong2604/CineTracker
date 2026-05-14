//
//  CastDTO.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastDTO]
}

struct CastDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int
}
