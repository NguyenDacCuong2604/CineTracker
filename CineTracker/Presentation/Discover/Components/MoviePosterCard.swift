//
//  MoviePosterCard.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie
    let width: CGFloat
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                CachedAsyncImage(url: movie.posterURL) {
                    SkeletonView(cornerRadius: AppRadius.md)
                }
                .aspectRatio(2 / 3, contentMode: .fill)
                .frame(width: width)
                .frame(height: width * 1.5)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(Color.appBackgroundTertiary, lineWidth: 0.5)
                )

                Text(movie.title)
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)
                    .frame(width: width, alignment: .leading)

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
                .frame(width: width, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
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
            ),
            width: 130
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
            ),
            width: 130
        )
    }
    .padding()
}
