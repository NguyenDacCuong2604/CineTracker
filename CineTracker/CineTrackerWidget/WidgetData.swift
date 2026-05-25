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
    let userRating: Double
    let status: String
}

struct WidgetData {
    let movies: [WidgetMovie]
    let totalCount: Int
    let lastUpdated: Date

    static let placeholder = WidgetData(
        movies: [
            WidgetMovie(id: 1, title: "Inception", posterURL: nil, userRating: 0, status: "Muốn xem"),
            WidgetMovie(id: 2, title: "Interstellar", posterURL: nil, userRating: 4.5, status: "Đã xem"),
            WidgetMovie(id: 3, title: "Tenet", posterURL: nil, userRating: 0, status: "Muốn xem"),
        ],
        totalCount: 12,
        lastUpdated: Date()
    )

    static let empty = WidgetData(
        movies: [],
        totalCount: 0,
        lastUpdated: Date()
    )
}
