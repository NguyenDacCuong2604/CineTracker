//
//  StatisticsState.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Foundation

struct StatisticsState {
    var statistics: Statistics = .empty
    var monthlyStats: [MonthlyStats] = []
    var genreDistribution: [GenreStats] = []
    var ratingDistribution: [RatingStats] = []
    var watchingActivity: [DailyActivity] = []
    var topRatedMovies: [SavedMovie] = []

    var isEmpty: Bool {
        statistics.totalMovies == 0
    }
}
