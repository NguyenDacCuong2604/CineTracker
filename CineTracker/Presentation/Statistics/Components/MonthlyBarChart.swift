//
//  MonthlyBarChart.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import Charts
import SwiftUI

struct MonthlyBarChart: View {
    let monthlyStats: [MonthlyStats]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Phim đã xem theo tháng")
                .appFont(.headlineLarge)

            Text("12 tháng gần nhất")
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)

            Chart(monthlyStats) { stat in
                BarMark(
                    x: .value("Tháng", stat.date, unit: .month),
                    y: .value("Số phim", stat.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.appBrand, Color.appBrand.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(4)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 2)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }
}

#Preview {
    let now = Date()
    let calendar = Calendar.current
    let stats = (0 ..< 12).map { offset -> MonthlyStats in
        let date = calendar.date(byAdding: .month, value: -offset, to: now)!
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return MonthlyStats(
            id: "\(year)-\(month)",
            year: year,
            month: month,
            count: Int.random(in: 0 ... 8)
        )
    }.reversed()

    return MonthlyBarChart(monthlyStats: Array(stats))
        .padding()
}
