//
//  AllMoviesViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AllMoviesViewModel {
    let category: Route.MovieCategory
    private(set) var state = AllMoviesState()
    private let fetchMovies: FetchMoviesByCategoryUseCase
    private var loadTask: Task<Void, Never>?
    private static let loadMoreThreshold = 6

    init(
        category: Route.MovieCategory,
        fetchMovies: FetchMoviesByCategoryUseCase
    ) {
        self.category = category
        self.fetchMovies = fetchMovies
    }

    func load() async {
        guard state.movies.isEmpty else { return }
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.loadInitial()
        }
        await loadTask?.value
    }

    private func loadInitial(forceRefresh: Bool = false) async {
        state.loadingState = .loading
        do {
            let movies = try await fetchMovies.execute(.init(
                category: category,
                page: 1,
                forceRefresh: forceRefresh
            ))

            guard !Task.isCancelled else { return }

            var seenIDs: Set<Int> = []
            let uniqueMovies = movies.filter { movie in
                if seenIDs.contains(movie.id) {
                    return false
                }
                seenIDs.insert(movie.id)
                return true
            }

            state.movies = uniqueMovies
            state.currentPage = 1
            state.hasMorePages = !uniqueMovies.isEmpty
            state.loadingState = .loaded
        } catch is CancellationError {
            return
        } catch let apiError as APIError where apiError == .cancelled {
            return
        } catch {
            AppLogger.app.error("Load all movies failed: \(error.localizedDescription)")
            state.loadingState = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        loadTask?.cancel()

        state.movies = []
        state.currentPage = 0
        state.hasMorePages = true
        state.loadingState = .idle

        loadTask = Task { [weak self] in
            await self?.loadInitial(forceRefresh: true)
        }
        await loadTask?.value
    }

    func loadMoreIfNeeded(currentIndex: Int) {
        guard !state.isLoadingMore,
              state.hasMorePages,
              currentIndex >= state.movies.count - Self.loadMoreThreshold
        else {
            return
        }

        Task { await loadNextPage() }
    }

    private func loadNextPage() async {
        guard !state.isLoadingMore, state.hasMorePages else { return }
        state.isLoadingMore = true
        defer { state.isLoadingMore = false }
        let nextPage = state.currentPage + 1

        do {
            let newMovies = try await fetchMovies.execute(.init(
                category: category,
                page: nextPage
            ))

            guard !Task.isCancelled else { return }

            if newMovies.isEmpty {
                state.hasMorePages = false
            } else {
                let existingIDs = Set(state.movies.map { $0.id })
                let uniqueNew = newMovies.filter { !existingIDs.contains($0.id) }

                let duplicateCount = newMovies.count - uniqueNew.count
                if duplicateCount > 0 {
                    AppLogger.app.debug("Filtered \(duplicateCount) duplicates from page \(nextPage)")
                }

                state.movies.append(contentsOf: uniqueNew)
                state.currentPage = nextPage

                if uniqueNew.isEmpty {
                    state.hasMorePages = false
                    AppLogger.app.debug("📊 All movies in page \(nextPage) were duplicates, stopping pagination")
                }
            }
        } catch is CancellationError {
            return
        } catch let apiError as APIError where apiError == .cancelled {
            return
        } catch {
            AppLogger.app.error("Load page \(nextPage) failed: \(error.localizedDescription)")
        }
    }
}
