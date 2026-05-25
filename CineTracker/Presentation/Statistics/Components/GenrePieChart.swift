//
//  GenrePieChart.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Charts
import SwiftUI

struct GenrePieChart: View {
    let genreStats: [GenreStats]

    private let colors: [Color] = [
        .appBrand, .appBrandSecondary, .appInfo,
        .appSuccess, .appWarning, .appError,
        .purple, .pink,
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(L10n.Statistics.genres)
                .appFont(.headlineLarge)

            if genreStats.isEmpty {
                emptyState
            } else {
                HStack(alignment: .top, spacing: AppSpacing.lg) {
                    chartView
                    legendView
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private var chartView: some View {
        Chart(genreStats) { stat in
            SectorMark(
                angle: .value("Count", stat.count),
                innerRadius: .ratio(0.5),
                angularInset: 1.5
            )
            .cornerRadius(4)
            .foregroundStyle(by: .value("Genre", stat.name))
        }
        .chartForegroundStyleScale(range: colors)
        .chartLegend(.hidden)
        .frame(width: 160, height: 160)
    }

    private var legendView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            ForEach(Array(genreStats.enumerated()), id: \.element.id) { index, stat in
                HStack(spacing: AppSpacing.xs) {
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 10, height: 10)

                    Text(stat.name)
                        .appFont(.bodySmall)
                        .lineLimit(1)

                    Spacer()

                    Text("\(stat.count)")
                        .appFont(.caption)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyState: some View {
        Text(L10n.Statistics.noGenreData)
            .appFont(.bodyMedium)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
    }
}
