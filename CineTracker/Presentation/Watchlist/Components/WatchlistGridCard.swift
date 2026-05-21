//
//  WatchlistGridCard.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct WatchlistGridCard: View {
    let savedMovie: SavedMovie
    var isSelected: Bool = false
    var isEditMode: Bool = false
    var onTap: (() -> Void)? = nil
    var onSelectToggle: (() -> Void)? = nil

    var body: some View {
        Button(action: handleTap) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    CachedAsyncImage(url: savedMovie.movie.posterURL, contentMode: .fill) {
                        SkeletonView(cornerRadius: AppRadius.md)
                    }
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    .overlay(alignment: .topLeading) {
                        if savedMovie.isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.appError)
                                .padding(6)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .padding(AppSpacing.xs)
                        }
                    }

                    Text(savedMovie.movie.title)
                        .appFont(.headlineSmall)
                        .foregroundColor(.appTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 40, alignment: .top)

                    HStack(spacing: AppSpacing.xs) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 6, height: 6)
                        Text(savedMovie.movie.formattedRating)
                            .appFont(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }

                if isEditMode {
                    selectionOverlay
                }
            }
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

    private var statusColor: Color {
        switch savedMovie.status {
        case .wantToWatch: return .appInfo
        case .watched: return .appSuccess
        }
    }

    private var selectionOverlay: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.title2)
            .foregroundColor(isSelected ? .appBrand : .white)
            .background(
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .padding(2)
            )
            .padding(AppSpacing.sm)
    }
}
