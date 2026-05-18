//
//  SearchViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Combine
import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class SearchViewModel {
    var query: String = "" {
        didSet { onQueryChanged() }
    }

    private(set) var state: SearchState = .idle
    private(set) var recentSearches: [String] = []

    private let searchMovies: SearchMoviesUseCase
    private let getRecentSearches: GetRecentSearchesUseCase
    private let saveRecentSearch: SaveRecentSearchUseCase
    private let removeRecentSearch: RemoveRecentSearchUseCase
    private let clearRecentSearches: ClearRecentSearchesUseCase

    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    private static let debounceMilliseconds: UInt64 = 300
    private static let minQueryLength: Int = 1

    init(
        searchMovies: SearchMoviesUseCase,
        getRecentSearches: GetRecentSearchesUseCase,
        saveRecentSearch: SaveRecentSearchUseCase,
        removeRecentSearch: RemoveRecentSearchUseCase,
        clearRecentSearches: ClearRecentSearchesUseCase
    ) {
        self.searchMovies = searchMovies
        self.getRecentSearches = getRecentSearches
        self.saveRecentSearch = saveRecentSearch
        self.removeRecentSearch = removeRecentSearch
        self.clearRecentSearches = clearRecentSearches

        observeRecentSearches()
    }

    func commitCurrentQuery() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= Self.minQueryLength else { return }

        saveRecentSearch.execute(trimmed)
        AppLogger.app.debug("Committed search: \(trimmed)")
    }

    func commitSearchAndOpenMovie(_: Movie) {
        commitCurrentQuery()
    }

    func selectRecentSearch(_ recentQuery: String) {
        query = recentQuery
    }

    func removeRecent(_ query: String) {
        removeRecentSearch.execute(query)
    }

    func clearAllRecent() {
        clearRecentSearches.execute(())
    }

    private func onQueryChanged() {
        searchTask?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            state = .idle
            return
        }

        searchTask = Task { [weak self] in
            guard let self else { return }
            
            try? await Task.sleep(nanoseconds: Self.debounceMilliseconds * 1_000_000)
            guard !Task.isCancelled else { return }
            
            await fetchSuggestions(query: trimmed)
        }
    }

    private func fetchSuggestions(query: String) async {
        state = .loading(query: query)

        do {
            let movies = try await searchMovies.execute(.init(query: query))
            guard !Task.isCancelled else { return }

            if movies.isEmpty {
                state = .empty(query: query)
            } else {
                state = .suggestions(query: query, movies: movies)
            }
        } catch is CancellationError {
            return
        } catch let apiError as APIError where apiError == .cancelled {
            return
        } catch {
            AppLogger.app.error("Search failed: \(error.localizedDescription)")
            state = .error(query: query, message: error.localizedDescription)
        }
    }

    private func observeRecentSearches() {
        getRecentSearches.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searches in
                self?.recentSearches = searches
            }
            .store(in: &cancellables)
    }
}
