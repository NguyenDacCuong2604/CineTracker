//
//  RatingDistributionChart.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Charts
import SwiftUI

struct RatingDistributionChart: View {
    let ratingStats: [RatingStats]

    private var maxCount: Int {
        ratingStats.max(by: { $0.count < $1.count })?.count ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(L10n.Statistics.ratingDistribution)
                .appFont(.headlineLarge)

            Text(L10n.Statistics.ratingSubtitle)
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)

            if !hasAnyRating {
                emptyState
            } else {
                chartContent
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private var hasAnyRating: Bool {
        ratingStats.reduce(0) { $0 + $1.count } > 0
    }

    private var chartContent: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(ratingStats.reversed()) { stat in
                ratingRow(stat)
            }
        }
    }

    private func ratingRow(_ stat: RatingStats) -> some View {
        HStack(spacing: AppSpacing.md) {
            HStack(spacing: 1) {
                ForEach(0 ..< stat.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.appBrandSecondary)
                        .font(.system(size: 11))
                }
            }
            .frame(width: 75, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appBackgroundTertiary)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appBrand)
                        .frame(width: geo.size.width * barWidthRatio(for: stat))
                }
            }
            .frame(height: 16)

            Text("\(stat.count)")
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)
                .frame(width: 32, alignment: .trailing)
        }
    }

    private func barWidthRatio(for stat: RatingStats) -> CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(stat.count) / CGFloat(maxCount)
    }

    private var emptyState: some View {
        Text(L10n.Statistics.noRated)
            .appFont(.bodyMedium)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
    }
}
