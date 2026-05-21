//
//  StatisticsViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class StatisticsViewModel {
    private(set) var state = StatisticsState()

    private let getStatistics: GetStatisticsUseCase
    private let getMonthlyStats: GetMonthlyStatsUseCase
    private let getGenreDistribution: GetGenreDistributionUseCase
    private let getRatingDistribution: GetRatingDistributionUseCase
    private let getWatchingActivity: GetWatchingActivityUseCase
    private let getTopRated: GetTopRatedMoviesByUserUseCase

    private var cancellables = Set<AnyCancellable>()

    init(
        getStatistics: GetStatisticsUseCase,
        getMonthlyStats: GetMonthlyStatsUseCase,
        getGenreDistribution: GetGenreDistributionUseCase,
        getRatingDistribution: GetRatingDistributionUseCase,
        getWatchingActivity: GetWatchingActivityUseCase,
        getTopRated: GetTopRatedMoviesByUserUseCase,
        watchlistPublisher: AnyPublisher<[SavedMovie], Never>
    ) {
        self.getStatistics = getStatistics
        self.getMonthlyStats = getMonthlyStats
        self.getGenreDistribution = getGenreDistribution
        self.getRatingDistribution = getRatingDistribution
        self.getWatchingActivity = getWatchingActivity
        self.getTopRated = getTopRated

        watchlistPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &cancellables)
    }

    func refresh() {
        state.statistics = getStatistics.execute(())
        state.monthlyStats = getMonthlyStats.execute(12)
        state.genreDistribution = getGenreDistribution.execute(())
        state.ratingDistribution = getRatingDistribution.execute(())
        state.watchingActivity = getWatchingActivity.execute(())
        state.topRatedMovies = getTopRated.execute(15)
    }
}
