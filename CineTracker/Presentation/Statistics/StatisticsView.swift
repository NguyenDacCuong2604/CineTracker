//
//  StatisticsView.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct StatisticsView: View {
    @State private var viewModel = StatisticsViewModel(
        getStatistics: DIContainer.shared.getStatisticsUseCase,
        getMonthlyStats: DIContainer.shared.getMonthlyStatsUseCase,
        getGenreDistribution: DIContainer.shared.getGenreDistributionUseCase,
        getRatingDistribution: DIContainer.shared.getRatingDistributionUseCase,
        getWatchingActivity: DIContainer.shared.getWatchingActivityUseCase,
        getTopRated: DIContainer.shared.getTopRatedMoviesByUserUseCase,
        watchlistPublisher: DIContainer.shared.watchlistPublisher
    )

    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.lg) {
                if viewModel.state.isEmpty {
                    emptyContent
                } else {
                    loadedContent
                }
            }
            .padding(AppSpacing.lg)
        }
        .background(Color.appBackground)
        .navigationTitle(L10n.Statistics.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.refresh()
        }
    }

    private var emptyContent: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer().frame(height: 60)

            Image(systemName: "chart.bar.fill")
                .font(.system(size: 70))
                .foregroundColor(.appTextTertiary)

            Text(L10n.Statistics.noData)
                .appFont(.headlineMedium)

            Text(L10n.Statistics.emptyMessage)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)

            PrimaryButton(
                title: L10n.Statistics.exploreMovies,
                icon: "sparkles",
                action: {
                    coordinator.selectedTab = .discover
                }
            )
            .frame(maxWidth: 240)
            .padding(.top, AppSpacing.md)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var loadedContent: some View {
        StatsOverview(statistics: viewModel.state.statistics)

        if !viewModel.state.monthlyStats.isEmpty {
            MonthlyBarChart(monthlyStats: viewModel.state.monthlyStats)
        }

        if !viewModel.state.genreDistribution.isEmpty {
            GenrePieChart(genreStats: viewModel.state.genreDistribution)
        }

        if !viewModel.state.ratingDistribution.isEmpty {
            RatingDistributionChart(ratingStats: viewModel.state.ratingDistribution)
        }

        if !viewModel.state.watchingActivity.isEmpty {
            ActivityHeatmap(activities: viewModel.state.watchingActivity)
        }

        TopMoviesSection(
            movies: viewModel.state.topRatedMovies,
            onMovieTap: { movie in
                coordinator.push(.movieDetail(id: movie.movie.id), on: .statistics)
            }
        )
    }
}
