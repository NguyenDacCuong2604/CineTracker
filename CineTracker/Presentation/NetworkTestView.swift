//
//  NetworkTestView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import OSLog
import SwiftUI

struct NetworkTestView: View {
    @State private var state: ViewState = .idle
    @StateObject private var networkMonitor = NetworkMonitor.shared

    private let movieRepository: MovieRepository = MovieRepositoryImpl(apiClient: APIClientImpl())

    enum ViewState {
        case idle
        case loading
        case loaded([Movie])
        case error(String)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Respository Test")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !networkMonitor.isConnected {
                            Image(systemName: "wifi.slash")
                                .foregroundColor(.appError)
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle:
            VStack(spacing: AppSpacing.lg) {
                Text("Tap để fetch popular movies")
                    .appFont(.bodyLarge)

                PrimaryButton(title: "Fetch Movies") {
                    Task { await loadMovies() }
                }
                .frame(maxWidth: 250)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loading:
            LoadingView(message: "Đang tải phim...")

        case let .loaded(movies):
            List(movies) { movie in
                movieRow(movie)
            }
            .refreshable {
                await loadMovies(forceRefresh: true)
            }

        case let .error(message):
            ErrorView(
                message: message,
                onRetry: {
                    Task { await loadMovies() }
                }
            )
        }
    }

    private func movieRow(_ movie: Movie) -> some View {
        HStack(spacing: AppSpacing.md) {
            CachedAsyncImage(url: movie.posterURL) {
                SkeletonView()
            }
            .aspectRatio(2 / 3, contentMode: .fill)
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(movie.title).appFont(.headlineSmall)
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.appBrandSecondary)
                        .font(.caption)
                    Text(movie.formattedRating).appFont(.bodySmall)
                    Text("⌘").foregroundColor(.appTextTertiary)
                    Text(movie.releaseYear).appFont(.bodySmall).foregroundColor(.appTextSecondary)
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func loadMovies(forceRefresh: Bool = false) async {
        state = .loading
        do {
            let movies = try await movieRepository.popularMovies(page: 1, forceRefresh: forceRefresh)
            state = .loaded(movies)
            AppLogger.app.info("Loaded \(movies.count) movies")
        } catch let error as APIError {
            state = .error(error.localizedDescription)
            AppLogger.network.error("Failed: \(error.localizedDescription)")
        } catch {
            state = .error(error.localizedDescription)
            AppLogger.network.error("Unknown error: \(error)")
        }
    }
}

#Preview {
    NetworkTestView()
}
