//
//  MovieCarousel.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct MovieCarousel: View {
    let title: String
    let state: CarouselState
    var onSeeAll: (() -> Void)? = nil
    var onMovieTap: ((Movie) -> Void)? = nil

    enum CarouselState {
        case loading
        case loaded([Movie])
        case empty
    }

    private let cardWidth: CGFloat = 130

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            header
            content
        }
    }

    private var header: some View {
        HStack {
            Text(title)
                .appFont(.headlineLarge)
                .foregroundColor(.appTextPrimary)

            Spacer()

            if onSeeAll != nil {
                Button(action: { onSeeAll?() }) {
                    HStack(spacing: AppSpacing.xs) {
                        Text("Xem tất cả")
                            .appFont(.bodySmall)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            loadingContent
        case let .loaded(movies):
            loadedContent(movies)
        case .empty:
            emptyContent
        }
    }

    private var loadingContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(0 ..< 5, id: \.self) { _ in
                    MovieCardSkeleton()
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private func loadedContent(_ movies: [Movie]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(movies) { movie in
                    MoviePosterCard(
                        movie: movie,
                        width: cardWidth,
                        onTap: { onMovieTap?(movie) }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private var emptyContent: some View {
        Text("Không có phim")
            .appFont(.bodyMedium)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
    }
}

#Preview("Loaded") {
    MovieCarousel(
        title: "Popular",
        state: .loaded([
            Movie(id: 1, title: "Inception", overview: "", posterURL: URL(string: "https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg"), backdropURL: nil, releaseDate: Date(), rating: 8.4, voteCount: 0, genreIDs: []),
            Movie(id: 2, title: "Interstellar", overview: "", posterURL: nil, backdropURL: nil, releaseDate: Date(), rating: 8.6, voteCount: 0, genreIDs: []),
        ]),
        onSeeAll: {},
        onMovieTap: { _ in }
    )
    Text("Cuong")
}

#Preview("Loading") {
    MovieCarousel(title: "Popular", state: .loading)
}

#Preview("Empty") {
    MovieCarousel(title: "Popular", state: .empty)
}
