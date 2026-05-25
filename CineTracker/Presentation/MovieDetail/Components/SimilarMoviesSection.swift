//
//  SimilarMoviesSection.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI

struct SimilarMoviesSection: View {
    let movies: [Movie]
    var onMovieTap: ((Movie) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(L10n.MovieDetail.mightLike)
                .appFont(.headlineLarge)
                .padding(.horizontal, AppSpacing.lg)

            if movies.isEmpty {
                Text(L10n.MovieDetail.noSuggestions)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
                    .padding(.horizontal, AppSpacing.lg)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(movies) { movie in
                            MoviePosterCard(
                                movie: movie,
                                width: 120,
                                onTap: { onMovieTap?(movie) }
                            )
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
            }
        }
    }
}
