//
//  Cast.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

struct Cast: Identifiable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profileURL: URL?
    let order: Int
}
