//
//  Statistics.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct Statistics: Equatable {
    let totalMovies: Int
    let totalWatched: Int
    let totalWantToWatch: Int
    let totalFavorites: Int
    let totalMinutesWatched: Int
    let averageUserRating: Double

    var formattedWatchTime: String {
        let hours = totalMinutesWatched / 60
        let minutes = totalMinutesWatched % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var formattedDays: String {
        let days = Double(totalMinutesWatched) / (60 * 24)
        return String(format: "%.1f ngày", days)
    }

    static let empty = Statistics(
        totalMovies: 0,
        totalWatched: 0,
        totalWantToWatch: 0,
        totalFavorites: 0,
        totalMinutesWatched: 0,
        averageUserRating: 0
    )
}

struct MonthlyStats: Identifiable, Equatable {
    let id: String
    let year: Int
    let month: Int
    let count: Int

    var date: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }

    var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }

    var shortLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}

struct GenreStats: Identifiable, Equatable {
    let id: Int
    let name: String
    let count: Int
    let percentage: Double
}

struct RatingStats: Identifiable, Equatable {
    let id: Int
    let rating: Int
    let count: Int
}

struct DailyActivity: Identifiable, Equatable {
    let id: String
    let date: Date
    let movieCount: Int

    var intensity: Int {
        switch movieCount {
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 3 ... 4: return 3
        default: return 4
        }
    }
}
