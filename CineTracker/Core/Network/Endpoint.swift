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
    
    // Search
    case searchMovies(query: String, page: Int)
    
    // Genres
    case movieGenres
    
    
    // Path of endpoint
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
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        case .similarMovies(let id, _):
            return "/movie/\(id)/similar"
        case .searchMovies:
            return "/search/movie"
        case .movieGenres:
            return "/genre/movie/list"
        }
    }
    
    var method: HTTPMethod{
        .get
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        switch self {
        case .popularMovies(let page),
                .topRatedMovies(let page),
                .upcomingMovies(let page),
                .nowPlayingMovies(let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .similarMovies(_, let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .searchMovies(let query, let page):
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
