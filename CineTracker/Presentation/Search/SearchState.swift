//
//  SearchState.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Foundation

enum SearchState {
    case idle
    case loading(query: String)
    case suggestions(query: String, movies: [Movie])
    case empty(query: String)
    case error(query: String, message: String)
}
