//
//  WatchlistRow.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct WatchlistRow: View {
    let savedMovie: SavedMovie
    var isSelected: Bool = false
    var isEditMode: Bool = false
    var onTap: (() -> Void)? = nil
    var onSelectToggle: (() -> Void)? = nil

    var body: some View {
        Button(action: handleTap) {
            HStack(spacing: AppSpacing.md) {
                if isEditMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isSelected ? .appBrand : .appTextTertiary)
                }

                CachedAsyncImage(url: savedMovie.movie.posterURL, contentMode: .fill) {
                    SkeletonView()
                }
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(savedMovie.movie.title)
                        .appFont(.headlineSmall)
                        .foregroundColor(.appTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: AppSpacing.xs) {
                        statusBadge

                        if savedMovie.isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.appError)
                                .font(.system(size: 11))
                        }
                    }

                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.appBrandSecondary)
                            .font(.system(size: 11))
                        Text(savedMovie.movie.formattedRating)
                            .appFont(.bodySmall)
                        Text("•")
                            .foregroundColor(.appTextTertiary)
                        Text(savedMovie.movie.releaseYear)
                            .appFont(.bodySmall)
                            .foregroundColor(.appTextSecondary)
                    }

                    if savedMovie.status == .watched && savedMovie.userRating > 0 {
                        userRatingView
                    }
                }

                Spacer()

                if !isEditMode {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.appTextTertiary)
                        .font(.system(size: 14))
                }
            }
            .padding(AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func handleTap() {
        if isEditMode {
            onSelectToggle?()
        } else {
            onTap?()
        }
    }

    private var statusBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
            Text(savedMovie.status.title)
                .appFont(.caption)
                .foregroundColor(statusColor)
        }
    }

    private var statusColor: Color {
        switch savedMovie.status {
        case .wantToWatch: return .appInfo
        case .watched: return .appSuccess
        }
    }

    private var userRatingView: some View {
        HStack(spacing: 2) {
            Text("Đánh giá")
                .appFont(.caption)
                .foregroundColor(.appTextSecondary)

            ForEach(1 ... 5, id: \.self) { star in
                Image(systemName: Double(star) <= savedMovie.userRating ? "star.fill" : "star")
                    .foregroundColor(.appBrandSecondary)
                    .font(.system(size: 10))
            }
        }
    }
}
