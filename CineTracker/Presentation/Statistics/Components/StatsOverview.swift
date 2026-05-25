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
                label: L10n.Statistics.totalMovies
            )

            StatCard(
                icon: "checkmark.circle.fill",
                iconColor: .appSuccess,
                value: "\(statistics.totalWatched)",
                label: L10n.Statistics.watched
            )

            StatCard(
                icon: "clock.fill",
                iconColor: .appInfo,
                value: statistics.formattedWatchTime,
                label: L10n.Statistics.watchTime
            )

            StatCard(
                icon: "star.fill",
                iconColor: .appBrandSecondary,
                value: String(format: "%.1f", statistics.averageUserRating),
                label: L10n.Statistics.avgRatingFull
            )

            StatCard(
                icon: "bookmark.fill",
                iconColor: .appWarning,
                value: "\(statistics.totalWantToWatch)",
                label: L10n.Statistics.wantToWatch
            )

            StatCard(
                icon: "heart.fill",
                iconColor: .appError,
                value: "\(statistics.totalFavorites)",
                label: L10n.Statistics.favorites
            )
        }
    }
}
