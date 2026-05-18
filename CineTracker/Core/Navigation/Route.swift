//
//  Route.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

enum Route: Hashable {
    case movieDetail(id: Int)
    case castDetail(id: Int)
    case allMovies(category: MovieCategory)

    enum MovieCategory: String, Hashable {
        case trending
        case popular
        case topRated
        case upcoming
        case nowPlaying

        var title: String {
            switch self {
            case .trending: return "Trending"
            case .popular: return " Popular"
            case .topRated: return "Top Rated"
            case .upcoming: return "Upcoming"
            case .nowPlaying: return "Now Playing"
            }
        }
    }
}
