//
//  DiscoverViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor

final class DiscoverViewModel {
    private(set) var state = DiscoverState()
    private let fetchTrending: FetchTrendingMoviesUseCase
    private let fetchPopular: FetchPopularMovieUseCase
    private let fetchTopRated: FetchTopRatedMoviesUseCase
    private let fetchUpcoming: FetchUpcomingMoviesUseCase
    private let fetchNowPlaying: FetchNowPlayingMoviesUseCase

    init(
        fetchTrending: FetchTrendingMoviesUseCase,
        fetchPopular: FetchPopularMovieUseCase,
        fetchTopRated: FetchTopRatedMoviesUseCase,
        fetchUpcoming: FetchUpcomingMoviesUseCase,
        fetchNowPlaying: FetchNowPlayingMoviesUseCase
    ) {
        self.fetchTrending = fetchTrending
        self.fetchPopular = fetchPopular
        self.fetchTopRated = fetchTopRated
        self.fetchUpcoming = fetchUpcoming
        self.fetchNowPlaying = fetchNowPlaying
    }

    func load() async {
        await loadAllSections(forceRefresh: false)
    }

    func refresh() async {
        state.isRefreshing = true
        defer { state.isRefreshing = false }
        await loadAllSections(forceRefresh: true)
    }

    func retrySection(_ section: Section) async {
        switch section {
        case .trending: await loadTrending(forceRefresh: true)
        case .popular: await loadPopular(forceRefresh: true)
        case .topRated: await loadTopRated(forceRefresh: true)
        case .upcoming: await loadUpcoming(forceRefresh: true)
        case .nowPlaying: await loadNowPlaying(forceRefresh: true)
        }
    }

    enum Section {
        case trending, popular, topRated, upcoming, nowPlaying
    }

    private func loadTrending(forceRefresh _: Bool) async {
        state.trending = .loading
        do {
            let movies = try await fetchTrending.execute(.init(limit: 5))
            state.trending = .loaded(movies)
        } catch {
            AppLogger.app.error("Failed to fetch trending: \(error.localizedDescription)")
            state.trending = .error(error)
        }
    }

    private func loadPopular(forceRefresh: Bool) async {
        state.popular = .loading
        do {
            let movies = try await fetchPopular.execute(.init(forceRefresh: forceRefresh))
            state.popular = .loaded(movies)
        } catch {
            state.popular = .error(error)
        }
    }

    private func loadTopRated(forceRefresh: Bool) async {
        state.topRated = .loading
        do {
            let movies = try await fetchTopRated.execute(.init(forceRefresh: forceRefresh))
            state.topRated = .loaded(movies)
        } catch {
            state.topRated = .error(error)
        }
    }

    private func loadUpcoming(forceRefresh: Bool) async {
        state.upcoming = .loading
        do {
            let movies = try await fetchUpcoming.execute(.init(forceRefresh: forceRefresh))
            state.upcoming = .loaded(movies)
        } catch {
            state.upcoming = .error(error)
        }
    }

    private func loadNowPlaying(forceRefresh: Bool) async {
        state.nowPlaying = .loading
        do {
            let movies = try await fetchNowPlaying.execute(.init(forceRefresh: forceRefresh))
            state.nowPlaying = .loaded(movies)
        } catch {
            state.nowPlaying = .error(error)
        }
    }

    private func loadAllSections(forceRefresh: Bool) async {
        async let trending: Void = loadTrending(forceRefresh: forceRefresh)
        async let popular: Void = loadPopular(forceRefresh: forceRefresh)
        async let topRated: Void = loadTopRated(forceRefresh: forceRefresh)
        async let upcoming: Void = loadUpcoming(forceRefresh: forceRefresh)
        async let nowPlaying: Void = loadNowPlaying(forceRefresh: forceRefresh)

        _ = await [trending, popular, topRated, upcoming, nowPlaying]
    }
}
