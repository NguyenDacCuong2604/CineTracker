//
//  StatsOverview.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct StatsOverview: View {
    let statistics: Statistics

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: AppSpacing.md),
                GridItem(.flexible(), spacing: AppSpacing.md),
            ],
            spacing: AppSpacing.md
        ) {
            StatCard(
                icon: "popcorn.fill",
                iconColor: .appBrand,
                value: "\(statistics.totalMovies)",
                label: "Tổng phim"
            )

            StatCard(
                icon: "checkmark.circle.fill",
                iconColor: .appSuccess,
                value: "\(statistics.totalWatched)",
                label: "Đã xem"
            )

            StatCard(
                icon: "clock.fill",
                iconColor: .appInfo,
                value: statistics.formattedWatchTime,
                label: "Thời gian xem"
            )

            StatCard(
                icon: "star.fill",
                iconColor: .appBrandSecondary,
                value: String(format: "%.1f", statistics.averageUserRating),
                label: "Rating trung bình"
            )

            StatCard(
                icon: "bookmark.fill",
                iconColor: .appWarning,
                value: "\(statistics.totalWantToWatch)",
                label: "Muốn xem"
            )

            StatCard(
                icon: "heart.fill",
                iconColor: .appError,
                value: "\(statistics.totalFavorites)",
                label: "Yêu thích"
            )
        }
    }
}
