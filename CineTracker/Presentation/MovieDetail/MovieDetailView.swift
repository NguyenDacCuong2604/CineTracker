//
//  MovieDetailView.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI

struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel
    @State private var showOverviewExpanded = false
    @State private var showShareSheet = false
    @State private var showReviewSheet = false

    @Environment(AppCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss

    init(movieID: Int) {
        let container = DIContainer.shared
        _viewModel = State(
            initialValue: MovieDetailViewModel(
                movieID: movieID,
                fetchDetail: container.fetchMovieDetailUseCase,
                fetchCast: container.fetchMovieCastUseCase,
                fetchVideos: container.fetchMovieVideosUseCase,
                fetchSimilar: container.fetchSimilarMoviesUseCase,
                isInWatchlist: container.isInWatchlistUseCase,
                getSavedMovie: container.getSavedMovieUseCase,
                addToWatchlist: container.addToWatchlistUseCase,
                removeFromWatchlist: container.removeFromWatchlistUseCase,
                markAsWatched: container.markAsWatchedUseCase,
                watchlistPublisher: container.watchlistPublisher
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                content
            }
        }
        .background(Color.appBackground)
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .sheet(isPresented: $showReviewSheet) {
            if let savedMovie = viewModel.state.savedMovie {
                AddReviewSheet(movie: savedMovie) { rating, review in
                    await viewModel.markWatched(rating: rating, review: review)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state.detail {
        case .idle, .loading:
            loadingView
        case let .loaded(details):
            if let detail = details.first {
                loadedContent(detail: detail)
            }
        case let .error(error):
            errorView(message: error.localizedDescription)
        }
    }

    private var loadingView: some View {
        VStack(spacing: AppSpacing.lg) {
            SkeletonView(cornerRadius: 0)
                .frame(height: 320)

            VStack(spacing: AppSpacing.md) {
                SkeletonView()
                    .frame(height: 32)
                SkeletonView()
                    .frame(width: 200, height: 16)
                SkeletonView()
                    .frame(height: 100)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: AppSpacing.lg) {
            ErrorView(
                message: message,
                onRetry: { Task { await viewModel.load() }}
            )
        }
        .frame(minHeight: 500)
    }

    private func loadedContent(detail: MovieDetail) -> some View {
        VStack(spacing: 0) {
            ParallaxHeader(backdropURL: detail.backdropURL, height: 320)

            movieInfo(detail: detail)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.lg)

            actionButtons(detail: detail)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.lg)

            if let saved = viewModel.state.savedMovie,
               saved.status == .watched
            {
                YourReviewSection(
                    savedMovie: saved,
                    onEditTap: { showReviewSheet = true }
                )
                .padding(.top, AppSpacing.lg)
            }

            overviewSection(detail: detail)
                .padding(.top, AppSpacing.xl)

            if case let .loaded(videos) = viewModel.state.videos,
               let trailer = videos.first
            {
                trailerSection(video: trailer)
                    .padding(.top, AppSpacing.xl)
            }

            if case let .loaded(cast) = viewModel.state.cast {
                CastSection(cast: cast)
                    .padding(.top, AppSpacing.xl)
            }

            if case let .loaded(similar) = viewModel.state.similar {
                SimilarMoviesSection(
                    movies: similar,
                    onMovieTap: { movie in
                        coordinator.push(.movieDetail(id: movie.id), on: coordinator.selectedTab)
                    }
                )
                .padding(.top, AppSpacing.xl)
            }

            Spacer(minLength: AppSpacing.xxl)
        }
    }

    private func movieInfo(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(detail.title)
                .appFont(.displayMedium)
                .foregroundColor(.appTextPrimary)

            if let tagline = detail.tagline {
                Text(tagline)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
                    .italic()
            }

            HStack(spacing: AppSpacing.md) {
                Label(detail.formattedRating, systemImage: "star.fill")
                    .appFont(.bodyMedium)
                    .foregroundColor(.appBrandSecondary)
                Text("•")
                    .foregroundColor(.appTextTertiary)
                Text(detail.releaseYear)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)

                if detail.runtime != nil {
                    Text("•")
                        .foregroundColor(.appTextTertiary)
                    Text(detail.formattedRuntime)
                        .appFont(.bodyMedium)
                        .foregroundColor(.appTextSecondary)
                }
            }

            if !detail.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.xs) {
                        ForEach(detail.genres) { genre in
                            Text(genre.name)
                                .appFont(.caption)
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xs)
                                .background(Color.appBackgroundSecondary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.top, AppSpacing.xs)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private func actionButtons(detail: MovieDetail) -> some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                Button(action: {
                    Task { await viewModel.toggleWatchlist() }
                }) {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: viewModel.state.isInWatchlist ? "checkmark" : "plus")
                        Text(viewModel.state.isInWatchlist ? "Đã thêm" : "Watchlist")
                            .appFont(.headlineSmall)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(viewModel.state.isInWatchlist ? Color.appSuccess : Color.appBrand)
                    )
                }

                ShareLink(item: shareURL(for: detail)) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.appBrand)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(Color.appBrand, lineWidth: 1.5)
                        )
                }
            }

            if let saved = viewModel.state.savedMovie,
               saved.status != .watched
            {
                Button(action: { showReviewSheet = true }) {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "checkmark.circle")
                        Text("Đánh dấu đã xem")
                            .appFont(.headlineSmall)
                    }
                    .foregroundColor(.appBrand)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .stroke(Color.appBrand, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private func shareURL(for detail: MovieDetail) -> URL {
        URL(string: "cinetracker://movie/\(detail.id)")!
    }

    private func overviewSection(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Nội dung")
                .appFont(.headlineLarge)
            Text(detail.overview.isEmpty ? "Chưa có mô tả" : detail.overview)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
                .lineLimit(showOverviewExpanded ? nil : 4)
                .animation(.easeInOut(duration: 0.2), value: showOverviewExpanded)

            if detail.overview.count > 200 {
                Button(showOverviewExpanded ? "Thu gọn" : "Đọc thêm") {
                    withAnimation { showOverviewExpanded.toggle() }
                }
                .appFont(.headlineSmall)
                .foregroundColor(.appBrand)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private func trailerSection(video: Video) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Trailer")
                .appFont(.headlineLarge)
                .padding(.horizontal, AppSpacing.lg)
            TrailerPlayer(videoID: video.key)
                .aspectRatio(16 / 9, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .padding(.horizontal, AppSpacing.lg)
        }
    }
}
