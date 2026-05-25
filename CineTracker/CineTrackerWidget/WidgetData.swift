//
//  WidgetData.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import Foundation

struct WidgetMovie: Identifiable {
    let id: Int
    let title: String
    let posterURL: URL?
    let posterData: Data?
    let userRating: Double
    let status: String
}

struct WidgetData {
    let wantToWatchMovies: [WidgetMovie]
    let allMovies: [WidgetMovie]
    let totalCount: Int
    let lastUpdated: Date

    static let placeholder: WidgetData = {
        let want = [
            WidgetMovie(id: 1, title: "Inception", posterURL: nil, posterData: nil, userRating: 0, status: L10n.MovieStatus.wantToWatch),
            WidgetMovie(id: 3, title: "Tenet", posterURL: nil, posterData: nil, userRating: 0, status: L10n.MovieStatus.wantToWatch),
            WidgetMovie(id: 4, title: "Oppenheimer", posterURL: nil, posterData: nil, userRating: 0, status: L10n.MovieStatus.wantToWatch),
            WidgetMovie(id: 5, title: "Dune", posterURL: nil, posterData: nil, userRating: 0, status: L10n.MovieStatus.wantToWatch),
            WidgetMovie(id: 6, title: "The Dark Knight", posterURL: nil, posterData: nil, userRating: 0, status: L10n.MovieStatus.wantToWatch),
        ]
        let all = want + [
            WidgetMovie(id: 2, title: "Interstellar", posterURL: nil, posterData: nil, userRating: 4.5, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 7, title: "Memento", posterURL: nil, posterData: nil, userRating: 4.0, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 8, title: "Prestige", posterURL: nil, posterData: nil, userRating: 4.5, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 9, title: "Dunkirk", posterURL: nil, posterData: nil, userRating: 3.5, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 10, title: "Insomnia", posterURL: nil, posterData: nil, userRating: 3.0, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 11, title: "Following", posterURL: nil, posterData: nil, userRating: 3.5, status: L10n.MovieStatus.watched),
            WidgetMovie(id: 12, title: "Insomnia 2", posterURL: nil, posterData: nil, userRating: 3.0, status: L10n.MovieStatus.watched),
        ]
        return WidgetData(
            wantToWatchMovies: want,
            allMovies: all,
            totalCount: all.count,
            lastUpdated: Date()
        )
    }()

    static let empty = WidgetData(
        wantToWatchMovies: [],
        allMovies: [],
        totalCount: 0,
        lastUpdated: Date()
    )
}
