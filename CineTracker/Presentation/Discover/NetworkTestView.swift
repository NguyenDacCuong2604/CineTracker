//
//  NetworkTestView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI
import OSLog

struct NetworkTestView: View {
    @State private var state: ViewState = .idle
    @StateObject private var networkMonitor = NetworkMonitor.shared
    
    private let apiClient: APIClient = APIClientImpl()
    
    enum ViewState {
        case idle
        case loading
        case loaded(PagedResponse<MovieDTO>)
        case error(String)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Network Test")
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
            
        case .loaded(let response):
            List {
                Section("Page \(response.page) of \(response.totalPages)") {
                    ForEach(response.results) { movie in
                        movieRow(movie)
                    }
                }
            }
            .refreshable {
                await loadMovies()
            }
            
        case .error(let message):
            ErrorView(
                message: message,
                onRetry: {
                    Task { await loadMovies() }
                }
            )
        }
    }
    
    @ViewBuilder
    private func movieRow(_ movie: MovieDTO) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(movie.title)
                .appFont(.headlineSmall)
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.appBrandSecondary)
                    .font(.caption)
                Text(String(format: "%.1f", movie.voteAverage))
                    .appFont(.bodySmall)
                Text("•")
                    .foregroundColor(.appTextTertiary)
                Text(movie.releaseDate ?? "N/A")
                    .appFont(.bodySmall)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func loadMovies() async {
        state = .loading
        
        do {
            let response: PagedResponse<MovieDTO> = try await apiClient.request(
                .popularMovies(page: 1)
            )
            state = .loaded(response)
            AppLogger.network.info("Loaded \(response.results.count) movies")
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
