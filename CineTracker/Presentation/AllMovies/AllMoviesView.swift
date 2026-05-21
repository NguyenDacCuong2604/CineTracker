//
//  AllMoviesView.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import SwiftUI

struct AllMoviesView: View {
    @State private var viewModel: AllMoviesViewModel
    @Environment(AppCoordinator.self) private var coordinator

    init(category: Route.MovieCategory) {
        let vm = AllMoviesViewModel(
            category: category,
            fetchMovies: DIContainer.shared.fetchMoviesByCategoryUseCase
        )
        _viewModel = State(initialValue: vm)
    }

    var body: some View {
        content
            .background(Color.appBackground)
            .navigationTitle(viewModel.category.title)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.load()
            }
            .refreshable {
                await viewModel.refresh()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state.loadingState {
        case .idle, .loading where viewModel.state.movies.isEmpty:
            loadingView
        case let .error(message) where viewModel.state.movies.isEmpty:
            errorView(message: message)
        default:
            moviesGrid
        }
    }

    private var moviesGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns,
                spacing: AppSpacing.md
            ) {
                ForEach(Array(viewModel.state.movies.enumerated()), id: \.element.id) { index, movie in
                    MoviePosterCard(
                        movie: movie,
                        onTap: {
                            coordinator.push(.movieDetail(id: movie.id), on: coordinator.selectedTab)
                        }
                    )
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentIndex: index)
                    }
                }

                if viewModel.state.isLoadingMore {
                    loadingMoreIndicator
                        .gridCellColumns(3)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: AppSpacing.md),
            GridItem(.flexible(), spacing: AppSpacing.md),
            GridItem(.flexible(), spacing: AppSpacing.md),
        ]
    }

    private var loadingView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: AppSpacing.md) {
                ForEach(0 ..< 12, id: \.self) { _ in
                    CardSkeleton()
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .disabled(true)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.appWarning)

            Text("Không thể tải phim")

            Text(message)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)

            PrimaryButton(
                title: "Thử lại",
                icon: "arrow.clockwise",
                action: {
                    Task { await viewModel.refresh() }
                }
            )
            .frame(maxWidth: 240)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var loadingMoreIndicator: some View {
        HStack(spacing: AppSpacing.sm) {
            ProgressView()
                .scaleEffect(0.8)

            Text("Đang tải thêm")
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }
}

private struct CardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SkeletonView()
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))

            SkeletonView()
                .frame(height: 14)

            SkeletonView()
                .frame(width: 60, height: 12)
        }
    }
}
