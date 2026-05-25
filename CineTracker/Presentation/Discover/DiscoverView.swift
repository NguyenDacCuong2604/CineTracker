//
//  DiscoverView.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import SwiftUI

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel(
        fetchTrending: DIContainer.shared.fetchTrendingMoviesUseCase,
        fetchPopular: DIContainer.shared.fetchPopularMoviesUseCase,
        fetchTopRated: DIContainer.shared.fetchTopRatedMoviesUseCase,
        fetchUpcoming: DIContainer.shared.fetchUpcomingMoviesUseCase,
        fetchNowPlaying: DIContainer.shared.fetchNowPlayingMoviesUseCase
    )

    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.xl) {
                // Hero Banner
                heroBanner

                // Popular
                MovieCarousel(
                    title: L10n.Discover.popular,
                    state: carouselState(from: viewModel.state.popular),
                    onSeeAll: { coordinator.push(.allMovies(category: .popular), on: .discover) },
                    onMovieTap: handleMovieTap
                )

                // Top Rated
                MovieCarousel(
                    title: L10n.Discover.topRated,
                    state: carouselState(from: viewModel.state.topRated),
                    onSeeAll: { coordinator.push(.allMovies(category: .topRated), on: .discover) },
                    onMovieTap: handleMovieTap
                )

                // Upcoming
                MovieCarousel(
                    title: L10n.Discover.upcoming,
                    state: carouselState(from: viewModel.state.upcoming),
                    onSeeAll: { coordinator.push(.allMovies(category: .upcoming), on: .discover) },
                    onMovieTap: handleMovieTap
                )

                // Now Playing
                MovieCarousel(
                    title: L10n.Discover.nowPlaying,
                    state: carouselState(from: viewModel.state.nowPlaying),
                    onSeeAll: { coordinator.push(.allMovies(category: .nowPlaying), on: .discover) },
                    onMovieTap: handleMovieTap
                )

                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.vertical, AppSpacing.md)
        }
        .background(Color.appBackground)
        .navigationTitle(L10n.Discover.title)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var heroBanner: some View {
        switch viewModel.state.trending {
        case .idle, .loading:
            SkeletonView(cornerRadius: 0)
                .frame(height: 280)
        case let .loaded(movies):
            HeroBanner(
                movies: movies,
                onMovieTap: handleMovieTap
            )
        case .error:
            ErrorView(
                message: L10n.Discover.trendingError,
                onRetry: {
                    Task { await viewModel.retrySection(.trending) }
                }
            )
            .frame(height: 280)
        }
    }

    private func handleMovieTap(_ movie: Movie) {
        coordinator.push(.movieDetail(id: movie.id), on: .discover)
    }

    private func carouselState(from section: SectionState<Movie>) -> MovieCarousel.CarouselState {
        switch section {
        case .idle, .loading:
            return .loading
        case let .loaded(movies) where movies.isEmpty:
            return .empty
        case let .loaded(movies):
            return .loaded(movies)
        case .error:
            return .empty
        }
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
    .environment(AppCoordinator())
}
