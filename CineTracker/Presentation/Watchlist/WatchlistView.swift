//
//  WatchlistView.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct WatchlistView: View {
    @State private var viewModel = WatchlistViewModel(
        getWatchlist: DIContainer.shared.getWatchlistUseCase,
        searchWatchlist: DIContainer.shared.searchWatchlistUseCase,
        removeFromWatchlist: DIContainer.shared.removeFromWatchlistUseCase,
        batchRemove: DIContainer.shared.batchRemoveFromWatchlistUseCase,
        restoreToWatchlist: DIContainer.shared.restoreToWatchlistUseCase,
        markAsWatched: DIContainer.shared.markAsWatchedUseCase,
        toggleFavorite: DIContainer.shared.toggleFavoriteUseCase
    )

    @Environment(AppCoordinator.self) private var coordinator

    @State private var movieToReview: SavedMovie? = nil

    var body: some View {
        mainContent
            .background(Color.appBackground)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: queryBinding,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Tìm trong watchlist..."
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    toolbarButtons
                }
            }
            .sheet(item: $movieToReview) { movie in
                AddReviewSheet(movie: movie) { rating, review in
                    await viewModel.markWatched(movie: movie, rating: rating, review: review)
                }
            }
            .overlay(alignment: .bottom) {
                if viewModel.state.showUndoToast {
                    undoToastView
                }
            }
    }

    private var mainContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                FilterChips(
                    selectedFilter: Binding(
                        get: { viewModel.state.filter },
                        set: { viewModel.setFilter($0) }
                    )
                )
                .padding(.vertical, AppSpacing.sm)

                if viewModel.state.movies.isEmpty {
                    EmptyWatchlistView(
                        filterDescription: emptyFilterDescription,
                        onDiscover: (viewModel.state.query.isEmpty) ? {
                            coordinator.selectedTab = .discover
                        } : nil
                    )
                    .frame(minHeight: 400)
                } else {
                    if viewModel.state.displayMode == .list {
                        listContent
                    } else {
                        gridContent
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var emptyFilterDescription: String {
        switch viewModel.state.filter {
        case .all: return "all"
        case .wantToWatch: return "wantToWatch"
        case .watched: return "watched"
        case .favorites: return "favorites"
        }
    }

    private var moviesContent: some View {
        ScrollView {
            if viewModel.state.displayMode == .list {
                listContent
            } else {
                gridContent
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var listContent: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.state.movies) { movie in
                WatchlistRow(
                    savedMovie: movie,
                    isSelected: viewModel.state.selectedIDs.contains(movie.id),
                    isEditMode: viewModel.state.isEditMode,
                    onTap: { handleMovieTap(movie) },
                    onSelectToggle: { viewModel.toggleSelection(movie.id) }
                )
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if !viewModel.state.isEditMode {
                        Button(role: .destructive) {
                            Task { await viewModel.removeMovie(movie) }
                        } label: {
                            Label("Xoá", systemImage: "trash")
                        }
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    if !viewModel.state.isEditMode && movie.status != .watched {
                        Button {
                            movieToReview = movie
                        } label: {
                            Label("Đã xem", systemImage: "checkmark")
                        }
                        .tint(.appSuccess)
                    }
                }
                .contextMenu {
                    contextMenuItems(for: movie)
                }

                Divider()
                    .padding(.leading, AppSpacing.lg)
            }
        }
    }

    private var gridContent: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: AppSpacing.md),
                GridItem(.flexible(), spacing: AppSpacing.md),
                GridItem(.flexible(), spacing: AppSpacing.md),
            ],
            spacing: AppSpacing.md
        ) {
            ForEach(viewModel.state.movies) { movie in
                WatchlistGridCard(
                    savedMovie: movie,
                    isSelected: viewModel.state.selectedIDs.contains(movie.id),
                    isEditMode: viewModel.state.isEditMode,
                    onTap: { handleMovieTap(movie) },
                    onSelectToggle: { viewModel.toggleSelection(movie.id) }
                )
                .contextMenu {
                    contextMenuItems(for: movie)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.lg)
    }

    @ViewBuilder
    private func contextMenuItems(for movie: SavedMovie) -> some View {
        Button {
            Task { await viewModel.toggleFavorite(movie) }
        } label: {
            Label(
                movie.isFavorite ? "Bỏ yêu thích" : "Yêu thích",
                systemImage: movie.isFavorite ? "heart.slash" : "heart"
            )
        }

        if movie.status != .watched {
            Button {
                movieToReview = movie
            } label: {
                Label("Đánh dấu đã xem", systemImage: "checkmark")
            }
        }

        Divider()

        Button(role: .destructive) {
            Task { await viewModel.removeMovie(movie) }
        } label: {
            Label("Xoá", systemImage: "trash")
        }
    }

    private func handleMovieTap(_ movie: SavedMovie) {
        coordinator.push(.movieDetail(id: movie.movie.id), on: .watchlist)
    }

    private var undoToastView: some View {
        UndoToast(
            message: "Đã xoá khỏi watchlist",
            onUndo: {
                Task { await viewModel.undoDelete() }
            },
            onDismiss: {
                viewModel.dismissUndoToast()
            }
        )
        .padding(.bottom, AppSpacing.lg)
        .animation(.easeInOut(duration: 0.3), value: viewModel.state.showUndoToast)
    }

    private var navigationTitle: String {
        viewModel.state.isEditMode ? "\(viewModel.state.selectedIDs.count) đã chọn" : "Watchlist"
    }

    private var queryBinding: Binding<String> {
        Binding(
            get: { viewModel.state.query },
            set: { viewModel.setQuery($0) }
        )
    }

    @ViewBuilder
    private var toolbarButtons: some View {
        if viewModel.state.isEditMode {
            Button("Xong") {
                viewModel.toggleEditMode()
            }
            .fontWeight(.semibold)

            if !viewModel.state.selectedIDs.isEmpty {
                Button(role: .destructive) {
                    Task { await viewModel.removeSelected() }
                } label: {
                    Image(systemName: "trash")
                }
            }
        } else {
            Menu {
                ForEach(WatchlistSortOption.allCases, id: \.self) { option in
                    Button {
                        viewModel.setSort(option)
                    } label: {
                        Label(option.rawValue, systemImage: option.sfSymbol)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }

            Button {
                viewModel.toggleDisplayMode()
            } label: {
                Image(systemName: viewModel.state.displayMode == .list ? "square.grid.2x2" : "list.bullet")
            }

            if !viewModel.state.movies.isEmpty {
                Button("Sửa") {
                    viewModel.toggleEditMode()
                }
            }
        }
    }
}
