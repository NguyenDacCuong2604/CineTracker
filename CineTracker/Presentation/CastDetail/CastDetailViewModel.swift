//
//  CastDetailViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CastDetailViewModel {
    let personID: Int
    private(set) var state = CastDetailState()
    private let fetchDetail: FetchPersonDetailUseCase
    private let fetchCredits: FetchPersonMovieCreditsUseCase
    private var loadTask: Task<Void, Never>?

    init(
        personID: Int,
        fetchDetail: FetchPersonDetailUseCase,
        fetchCredits: FetchPersonMovieCreditsUseCase
    ) {
        self.personID = personID
        self.fetchDetail = fetchDetail
        self.fetchCredits = fetchCredits
    }

    func load() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.loadAll(isInitialLoad: true)
        }
        await loadTask?.value
    }

    func refresh() async {
        loadTask?.cancel()
        state.isRefreshing = true

        loadTask = Task { [weak self] in
            await self?.loadAll(isInitialLoad: false)
            self?.state.isRefreshing = false
        }
        await loadTask?.value
    }

    private func loadAll(isInitialLoad: Bool) async {
        async let detail: Void = loadDetail(isInitialLoad: isInitialLoad)
        async let credits: Void = loadCredits(isInitialLoad: isInitialLoad)
        _ = await [detail, credits]
    }

    private func loadDetail(isInitialLoad: Bool) async {
        if isInitialLoad {
            state.person = .loading
        }

        do {
            let person = try await fetchDetail.execute(personID)
            state.person = .loaded([person])
        } catch is CancellationError {
            return
        } catch let apiError as APIError where apiError == .cancelled {
            return
        } catch {
            AppLogger.app.error("Fetch person detail failed: \(error.localizedDescription)")
            if isInitialLoad {
                state.person = .error(error)
            }
        }
    }

    private func loadCredits(isInitialLoad: Bool) async {
        if isInitialLoad {
            state.credits = .loading
        }

        do {
            let credits = try await fetchCredits.execute(personID)
            state.credits = .loaded(credits)
        } catch is CancellationError {
            return
        } catch let apiError as APIError where apiError == .cancelled {
            return
        } catch {
            AppLogger.app.error("Fetch credits failed: \(error.localizedDescription)")
            if isInitialLoad {
                state.credits = .error(error)
            }
        }
    }
}
