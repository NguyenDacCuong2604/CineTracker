//
//  Endpoint.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

enum Endpoint {
    // Movies
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case upcomingMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case movieVideos(id: Int)
    case similarMovies(id: Int, page: Int)

    /// Search
    case searchMovies(query: String, page: Int)

    /// Genres
    case movieGenres

    /// Path of endpoint
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case let .movieDetail(id):
            return "/movie/\(id)"
        case let .movieCredits(id):
            return "/movie/\(id)/credits"
        case let .movieVideos(id):
            return "/movie/\(id)/videos"
        case let .similarMovies(id, _):
            return "/movie/\(id)/similar"
        case .searchMovies:
            return "/search/movie"
        case .movieGenres:
            return "/genre/movie/list"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        switch self {
        case let .popularMovies(page),
             let .topRatedMovies(page),
             let .upcomingMovies(page),
             let .nowPlayingMovies(page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case let .similarMovies(_, page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case let .searchMovies(query, page):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
            items.append(URLQueryItem(name: "include_adult", value: "false"))
        case .movieDetail, .movieCredits, .movieVideos, .movieGenres:
            break
        }

        return items
    }

    func url(baseURL: URL, apiKey: String) throws -> URL {
        let fullURL = baseURL.appendingPathComponent(path)

        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        var allItems = queryItems
        allItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = allItems

        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }

        return finalURL
    }
}
