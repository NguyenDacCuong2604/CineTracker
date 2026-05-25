//
//  YourReviewSection.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct YourReviewSection: View {
    let savedMovie: SavedMovie
    var onEditTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(L10n.MovieDetail.yourReview)
                    .appFont(.headlineLarge)

                Spacer()

                Button(action: { onEditTap?() }) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text(L10n.Common.edit)
                            .appFont(.bodySmall)
                    }
                    .foregroundColor(.appBrand)
                }
            }
            .padding(.horizontal, AppSpacing.lg)

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                ratingDisplay

                if !savedMovie.userReview.isEmpty {
                    reviewText
                }

                if let watchedDate = savedMovie.watchedDate {
                    watchedDateView(watchedDate)
                }
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(Color.appBackgroundSecondary)
            )
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private var ratingDisplay: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                ForEach(1 ... 5, id: \.self) { star in
                    Image(systemName: starImageName(for: star))
                        .foregroundColor(.appBrandSecondary)
                        .font(.system(size: 20))
                }

                Text(String(format: "%.1f", savedMovie.userRating))
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)
                    .padding(.leading, AppSpacing.xs)

                Text(L10n.Review.maxRating)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
            }
        }
    }

    private var reviewText: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack(alignment: .top, spacing: AppSpacing.xs) {
                Image(systemName: "quote.opening")
                    .foregroundColor(.appTextTertiary)
                    .font(.system(size: 14))

                Text(savedMovie.userReview)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top, AppSpacing.xs)
    }

    private func watchedDateView(_ date: Date) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "calendar")
                .foregroundColor(.appTextTertiary)
                .font(.system(size: 11))

            Text(L10n.Review.watchedOn(date.formatted(date: .abbreviated, time: .omitted)))
                .appFont(.caption)
                .foregroundColor(.appTextTertiary)
        }
        .padding(.top, AppSpacing.xs)
    }

    private func starImageName(for star: Int) -> String {
        let rating = savedMovie.userRating
        let starDouble = Double(star)

        if rating >= starDouble {
            return "star.fill"
        } else if rating >= starDouble - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

#Preview {
    let movie = Movie(
        id: 1,
        title: "Inception",
        overview: "...",
        posterURL: nil,
        backdropURL: nil,
        releaseDate: Date(),
        rating: 8.4,
        voteCount: 1000,
        genreIDs: []
    )

    let savedMovie = SavedMovie(
        id: 1,
        movie: movie,
        status: .watched,
        userRating: 4.5,
        userReview: "Phim hay nhất tôi từng xem! Cốt truyện phức tạp nhưng cuốn hút từ đầu đến cuối. Diễn xuất của Leonardo DiCaprio xuất sắc, kỹ xảo đỉnh cao.",
        watchedDate: Date(),
        addedDate: Date(),
        isFavorite: true
    )

    return ScrollView {
        YourReviewSection(savedMovie: savedMovie)
    }
}
