//
//  AddReviewSheet.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct AddReviewSheet: View {
    let movie: SavedMovie
    let onSubmit: (Double, String) async -> Void

    @State private var rating: Double = 0
    @State private var review: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    HStack(spacing: AppSpacing.md) {
                        CachedAsyncImage(url: movie.movie.posterURL, contentMode: .fill) {
                            SkeletonView()
                        }
                        .frame(width: 80, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(movie.movie.title)
                                .appFont(.headlineMedium)
                            Text(movie.movie.releaseYear)
                                .appFont(.bodyMedium)
                                .foregroundColor(.appTextSecondary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)

                    VStack(spacing: AppSpacing.md) {
                        Text(L10n.Review.yourRating)
                            .appFont(.headlineSmall)

                        RatingView(rating: $rating, starSize: 40)

                        if rating > 0 {
                            Text("\(rating, specifier: "%.1f") \(L10n.Review.maxRating)")
                                .appFont(.bodyMedium)
                                .foregroundColor(.appTextSecondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(L10n.Review.yourFeelings)
                            .appFont(.headlineSmall)
                            .padding(.horizontal, AppSpacing.lg)

                        TextEditor(text: $review)
                            .appFont(.bodyMedium)
                            .frame(minHeight: 150)
                            .padding(AppSpacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: AppRadius.md)
                                    .fill(Color.appBackgroundSecondary)
                            )
                            .padding(.horizontal, AppSpacing.lg)
                            .overlay(alignment: .topLeading) {
                                if review.isEmpty {
                                    Text(L10n.Review.placeholder)
                                        .appFont(.bodyMedium)
                                        .foregroundColor(.appTextTertiary)
                                        .padding(.horizontal, AppSpacing.lg + AppSpacing.sm + 4)
                                        .padding(.top, AppSpacing.md)
                                        .allowsHitTesting(false)
                                }
                            }

                        Text(L10n.Review.characterCount(review.count))
                            .appFont(.caption)
                            .foregroundColor(review.count > 1000 ? .appError : .appTextTertiary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, AppSpacing.lg)
                    }
                }
                .padding(.vertical, AppSpacing.lg)
            }
            .background(Color.appBackground)
            .navigationTitle(L10n.Review.sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Common.cancel) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.save) {
                        Task {
                            await onSubmit(rating, review)
                            dismiss()
                        }
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                rating = movie.userRating
                review = movie.userReview
            }
        }
    }

    private var isValid: Bool {
        rating > 0 && review.count <= 1000
    }
}
