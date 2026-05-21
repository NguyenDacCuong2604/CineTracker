//
//  MoviePosterCard.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie
    let width: CGFloat?
    var onTap: (() -> Void)?

    init(movie: Movie, width: CGFloat? = nil, onTap: (() -> Void)? = nil) {
        self.movie = movie
        self.width = width
        self.onTap = onTap
    }

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                posterImage

                Text(movie.title)
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)
                    .frame(maxWidth: width ?? .infinity, alignment: .leading)

                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.appBrandSecondary)
                        .font(.system(size: 10))
                    Text(movie.formattedRating)
                        .appFont(.caption)
                        .foregroundColor(.appTextSecondary)
                    Text("•")
                        .foregroundColor(.appTextTertiary)
                    Text(movie.releaseYear)
                        .appFont(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                .frame(maxWidth: width ?? .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var posterImage: some View {
        if let width = width {
            CachedAsyncImage(url: movie.posterURL) {
                SkeletonView(cornerRadius: AppRadius.md)
            }
            .frame(width: width, height: width * 1.5)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(Color.appBackgroundTertiary, lineWidth: 0.5)
            )
        } else {
            CachedAsyncImage(url: movie.posterURL) {
                SkeletonView(cornerRadius: AppRadius.md)
            }
            .aspectRatio(2 / 3, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(Color.appBackgroundTertiary, lineWidth: 0.5)
            )
        }
    }
}

#Preview {
    HStack(spacing: AppSpacing.md) {
        MoviePosterCard(
            movie: Movie(
                id: 1,
                title: "Inception",
                overview: "Mind-bending thriller",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg"),
                backdropURL: nil,
                releaseDate: Date(),
                rating: 8.4,
                voteCount: 1000,
                genreIDs: []
            )
        )

        MoviePosterCard(
            movie: Movie(
                id: 2,
                title: "The Dark Knight: Rise of Something Very Long",
                overview: "",
                posterURL: nil,
                backdropURL: nil,
                releaseDate: nil,
                rating: 9.0,
                voteCount: 0,
                genreIDs: []
            )
        )
    }
    .padding()
}
