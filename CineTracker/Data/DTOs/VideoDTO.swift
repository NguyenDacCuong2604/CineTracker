//
//  VideoDTO.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct VideoDTO: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool
}

struct VideosResponse: Codable {
    let id: Int
    let results: [VideoDTO]
}
