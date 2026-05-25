//
//  ProfileViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var state = ProfileState()

    private let getWatchlist: GetWatchlistUseCase
    private let cacheManager: CacheManager

    private var cancellables = Set<AnyCancellable>()

    init(
        getWatchlist: GetWatchlistUseCase,
        cacheManager: CacheManager
    ) {
        self.getWatchlist = getWatchlist
        self.cacheManager = cacheManager

        observeWatchlist()
    }

    private func observeWatchlist() {
        getWatchlist.execute(filter: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.updateStats(from: movies)
            }
            .store(in: &cancellables)
    }

    private func updateStats(from movies: [SavedMovie]) {
        state.totalMoviesInWatchlist = movies.count
        state.totalMoviesWatched = movies.filter { $0.status == .watched }.count
    }

    func calculateCacheSize() async {
        let size = await cacheManager.totalCacheSize()
        state.cacheSize = formatBytes(size)
    }

    func clearAllCache() async {
        await cacheManager.clearAll()
        await calculateCacheSize()
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
