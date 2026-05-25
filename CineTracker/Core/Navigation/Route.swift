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
            case .trending: return L10n.MovieCategory.trending
            case .popular: return L10n.MovieCategory.popular
            case .topRated: return L10n.MovieCategory.topRated
            case .upcoming: return L10n.MovieCategory.upcoming
            case .nowPlaying: return L10n.MovieCategory.nowPlaying
            }
        }
    }
}
