//
//  SearchView.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel(
        searchMovies: DIContainer.shared.searchMovieUseCase,
        getRecentSearches: DIContainer.shared.getRecentSearchesUseCase,
        saveRecentSearch: DIContainer.shared.saveRecentSearchUseCase,
        removeRecentSearch: DIContainer.shared.removeRecentSearchUseCase,
        clearRecentSearches: DIContainer.shared.clearRecentSearchesUseCase
    )

    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .id("top")

                    content
                }
            }
            .background(Color.appBackground)
            .navigationTitle(L10n.Search.title)
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: L10n.Search.placeholder
            )
            .submitLabel(.search)
            .onSubmit(of: .search) {
                viewModel.commitCurrentQuery()
            }
            .onChange(of: stateKey) { _, _ in
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo("top", anchor: .top)
                }
            }
        }
    }

    private var stateKey: String {
        switch viewModel.state {
        case .idle: return "idle"
        case .loading: return "loading"
        case .suggestions: return "suggestions"
        case .empty: return "empty"
        case .error: return "error"
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            recentSearchesContent

        case .loading:
            loadingContent

        case let .suggestions(_, movies):
            suggestionsContent(movies: movies)

        case let .empty(query):
            emptyContent(query: query)

        case let .error(_, message):
            errorContent(message: message)
        }
    }

    private var recentSearchesContent: some View {
        RecentSearchesView(
            searches: viewModel.recentSearches,
            onSelect: { viewModel.selectRecentSearch($0) },
            onRemove: { viewModel.removeRecent($0) },
            onClearAll: { viewModel.clearAllRecent() }
        )
    }

    private var loadingContent: some View {
        VStack(spacing: AppSpacing.lg) {
            ForEach(0 ..< 6, id: \.self) { _ in
                SearchResultRowSkeleton()
            }
        }
        .padding(.top, AppSpacing.md)
    }

    private func suggestionsContent(movies: [Movie]) -> some View {
        VStack(spacing: 0) {
            ForEach(movies) { movie in
                Button(action: {
                    viewModel.commitSearchAndOpenMovie(movie)
                    coordinator.push(.movieDetail(id: movie.id), on: .search)
                }) {
                    SearchResultRow(movie: movie)
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, AppSpacing.lg)
            }
        }
    }

    private func emptyContent(query: String) -> some View {
        EmptyStateView(
            icon: "movieclapper",
            title: L10n.Search.notFound,
            message: L10n.Search.noMatchingMovies(query)
        )
        .frame(minHeight: 400)
    }

    private func errorContent(message: String) -> some View {
        ErrorView(
            message: message,
            onRetry: nil
        )
        .frame(minHeight: 400)
    }
}

private struct SearchResultRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            CachedAsyncImage(url: movie.posterURL, contentMode: .fill) {
                SkeletonView()
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(movie.title)
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.appBrandSecondary)
                        .font(.system(size: 11))
                    Text(movie.formattedRating)
                        .appFont(.bodySmall)
                    Text("•")
                        .foregroundColor(.appTextTertiary)
                    Text(movie.releaseYear)
                        .appFont(.bodySmall)
                        .foregroundColor(.appTextSecondary)
                }

                if !movie.overview.isEmpty {
                    Text(movie.overview)
                        .appFont(.bodySmall)
                        .foregroundColor(.appTextTertiary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.appTextTertiary)
                .font(.system(size: 14))
        }
        .padding(AppSpacing.md)
        .contentShape(Rectangle())
    }
}

private struct SearchResultRowSkeleton: View {
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            SkeletonView()
                .frame(width: 60, height: 90)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                SkeletonView()
                    .frame(height: 16)
                SkeletonView()
                    .frame(width: 100, height: 12)
                SkeletonView()
                    .frame(height: 12)
                SkeletonView()
                    .frame(width: 200, height: 12)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
    }
}
