//
//  WatchlistViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Combine
import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class WatchlistViewModel {
    private(set) var state = WatchlistState()

    private let getWatchlist: GetWatchlistUseCase
    private let searchWatchlist: SearchWatchlistUseCase
    private let removeFromWatchlist: RemoveFromWatchlistUseCase
    private let batchRemove: BatchRemoveFromWatchlistUseCase
    private let restoreToWatchlist: RestoreToWatchlistUseCase
    private let markAsWatched: MarkAsWatchedUseCase
    private let toggleFavorite: ToggleFavoriteUseCase

    private var cancellables = Set<AnyCancellable>()
    private var undoTask: Task<Void, Never>?

    private static let undoTimeoutSeconds: UInt64 = 5

    init(
        getWatchlist: GetWatchlistUseCase,
        searchWatchlist: SearchWatchlistUseCase,
        removeFromWatchlist: RemoveFromWatchlistUseCase,
        batchRemove: BatchRemoveFromWatchlistUseCase,
        restoreToWatchlist: RestoreToWatchlistUseCase,
        markAsWatched: MarkAsWatchedUseCase,
        toggleFavorite: ToggleFavoriteUseCase
    ) {
        self.getWatchlist = getWatchlist
        self.searchWatchlist = searchWatchlist
        self.removeFromWatchlist = removeFromWatchlist
        self.batchRemove = batchRemove
        self.restoreToWatchlist = restoreToWatchlist
        self.markAsWatched = markAsWatched
        self.toggleFavorite = toggleFavorite

        observeWatchlistChanges()
    }

    private func observeWatchlistChanges() {
        getWatchlist.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshMovies()
            }
            .store(in: &cancellables)
    }

    private func refreshMovies() {
        let status: SavedMovie.Status?
        let favoritesOnly: Bool

        switch state.filter {
        case .all:
            status = nil
            favoritesOnly = false
        case .wantToWatch:
            status = .wantToWatch
            favoritesOnly = false
        case .watched:
            status = .watched
            favoritesOnly = false
        case .favorites:
            status = nil
            favoritesOnly = true
        }

        var movies = searchWatchlist.execute(.init(
            query: state.query,
            status: status,
            sortBy: state.sortBy
        ))

        if favoritesOnly {
            movies = movies.filter { $0.isFavorite }
        }

        state.movies = movies
    }

    func setFilter(_ filter: WatchlistFilter) {
        state.filter = filter
        refreshMovies()
    }

    func setSort(_ sort: WatchlistSortOption) {
        state.sortBy = sort
        refreshMovies()
    }

    func setQuery(_ query: String) {
        state.query = query
        refreshMovies()
    }

    func toggleDisplayMode() {
        state.displayMode = state.displayMode == .list ? .grid : .list
    }

    func toggleEditMode() {
        state.isEditMode.toggle()
        if !state.isEditMode {
            state.selectedIDs.removeAll()
        }
    }

    func toggleSelection(_ id: Int) {
        if state.selectedIDs.contains(id) {
            state.selectedIDs.remove(id)
        } else {
            state.selectedIDs.insert(id)
        }
    }

    func selectAll() {
        state.selectedIDs = Set(state.movies.map { $0.id })
    }

    func removeSelected() async {
        let ids = Array(state.selectedIDs)
        guard !ids.isEmpty else { return }

        do {
            try await batchRemove.execute(ids)
            state.selectedIDs.removeAll()
            state.isEditMode = false
            AppLogger.app.info("Batch removed \(ids.count) movies")
        } catch {
            AppLogger.app.error("Batch remove failed: \(error.localizedDescription)")
        }
    }

    func removeMovie(_ movie: SavedMovie) async {
        state.recentlyDeteted = movie
        do {
            try await removeFromWatchlist.execute(movie.id)
            showUndoToast()
        } catch {
            AppLogger.app.error("Remove failed: \(error.localizedDescription)")
            state.recentlyDeteted = nil
        }
    }

    private func showUndoToast() {
        state.showUndoToast = true
        undoTask?.cancel()
        undoTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: Self.undoTimeoutSeconds * 1_000_000_000)

            guard !Task.isCancelled else { return }

            self?.state.showUndoToast = false
            self?.state.recentlyDeteted = nil
        }
    }

    func undoDelete() async {
        guard let movie = state.recentlyDeteted else { return }

        do {
            try await restoreToWatchlist.execute(movie)
            state.recentlyDeteted = nil
            state.showUndoToast = false
            undoTask?.cancel()
            AppLogger.app.info("Restored: \(movie.movie.title)")
        } catch {
            AppLogger.app.error("Undo failed: \(error.localizedDescription)")
        }
    }

    func toggleFavorite(_ movie: SavedMovie) async {
        do {
            try await toggleFavorite.execute(movie.id)
        } catch {
            AppLogger.app.error("Toggle favorite failed: \(error.localizedDescription)")
        }
    }

    func markWatched(movie: SavedMovie, rating: Double, review: String) async {
        do {
            try await markAsWatched.execute(.init(movieID: movie.id, rating: rating, review: review))
            AppLogger.app.info("Marked watched: \(movie.movie.title)")
        } catch {
            AppLogger.app.error("Mark watched failed: \(error.localizedDescription)")
        }
    }

    func dismissUndoToast() {
        state.showUndoToast = false
        state.recentlyDeteted = nil
        undoTask?.cancel()
    }
}
