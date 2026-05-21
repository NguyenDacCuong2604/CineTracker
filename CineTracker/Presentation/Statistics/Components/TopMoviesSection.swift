//
//  TopMoviesSection.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct TopMoviesSection: View {
    let movies: [SavedMovie]
    var onMovieTap: ((SavedMovie) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("🏆 Top 15 phim của bạn")
                .appFont(.headlineLarge)

            if movies.isEmpty {
                emptyState
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                        topMovieRow(rank: index + 1, movie: movie)
                            .onTapGesture {
                                onMovieTap?(movie)
                            }
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private func topMovieRow(rank: Int, movie: SavedMovie) -> some View {
        HStack(spacing: AppSpacing.md) {
            Text("\(rank)")
                .appFont(.bodySmall)
                .foregroundColor(rankColor(rank))
                .frame(width: 32)

            CachedAsyncImage(url: movie.movie.posterURL, contentMode: .fill) {
                SkeletonView()
            }
            .frame(width: 50, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(movie.movie.title)
                    .appFont(.headlineSmall)
                    .lineLimit(1)

                HStack(spacing: 2) {
                    ForEach(1 ... 5, id: \.self) { star in
                        Image(systemName: Double(star) <= movie.userRating ? "star.fill" : "star")
                            .foregroundColor(.appBrandSecondary)
                            .font(.system(size: 10))
                    }
                    Text(String(format: "%.1f", movie.userRating))
                        .appFont(.caption)
                        .foregroundColor(.appTextSecondary)
                        .padding(.leading, 4)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.appTextTertiary)
                .font(.system(size: 12))
        }
        .padding(.vertical, AppSpacing.xs)
        .contentShape(Rectangle())
    }

    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .appBrandSecondary
        case 2: return Color(white: 0.7)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return .appTextSecondary
        }
    }

    private var emptyState: some View {
        Text("Chưa rate phim nào")
            .appFont(.bodyMedium)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
    }
}
