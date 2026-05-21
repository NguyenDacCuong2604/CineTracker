//
//  ActivityHeatmap.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct ActivityHeatmap: View {
    let activities: [DailyActivity]

    @State private var selectedActivity: DailyActivity? = nil

    private let cellSize: CGFloat = 12
    private let cellSpacing: CGFloat = 3
    private let weekdayLabelWidth: CGFloat = 28
    private let calendar = Calendar.current

    /// Năm hiện tại
    private var currentYear: Int {
        calendar.component(.year, from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hoạt động xem phim")
                        .appFont(.headlineLarge)
                    Text("Năm \(currentYear)")
                        .appFont(.bodySmall)
                        .foregroundColor(.appTextSecondary)
                }

                Spacer()

                if totalThisYear > 0 {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(totalThisYear)")
                            .appFont(.headlineMedium)
                            .foregroundColor(.appBrand)
                        Text("phim")
                            .appFont(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }

            if let selected = selectedActivity {
                tooltipView(activity: selected)
            }

            if activities.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: cellSpacing) {
                        monthLabels

                        HStack(alignment: .top, spacing: cellSpacing) {
                            weekdayLabels
                            heatmapGrid
                        }
                    }
                }

                legendView
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private var totalThisYear: Int {
        activities.reduce(0) { $0 + $1.movieCount }
    }

    private var weeks: [[DailyActivity?]] {
        guard let first = activities.first else { return [] }

        let firstWeekday = calendar.component(.weekday, from: first.date)
        let mondayOffset = (firstWeekday + 5) % 7

        var result: [[DailyActivity?]] = []
        var currentWeek: [DailyActivity?] = Array(repeating: nil, count: mondayOffset)

        for activity in activities {
            currentWeek.append(activity)

            if currentWeek.count == 7 {
                result.append(currentWeek)
                currentWeek = []
            }
        }

        if !currentWeek.isEmpty {
            while currentWeek.count < 7 {
                currentWeek.append(nil)
            }
            result.append(currentWeek)
        }

        return result
    }

    private var monthLabels: some View {
        HStack(alignment: .top, spacing: cellSpacing) {
            Color.clear.frame(width: weekdayLabelWidth, height: 16)

            ZStack(alignment: .topLeading) {
                HStack(spacing: cellSpacing) {
                    ForEach(0 ..< weeks.count, id: \.self) { _ in
                        Color.clear
                            .frame(width: cellSize, height: 16)
                    }
                }

                ForEach(monthPositions, id: \.month) { position in
                    Text(position.label)
                        .appFont(.caption)
                        .foregroundColor(.appTextSecondary)
                        .offset(x: position.x)
                }
            }
        }
    }

    private var monthPositions: [(month: Int, label: String, x: CGFloat)] {
        var seenMonths: Set<Int> = []
        var positions: [(month: Int, label: String, x: CGFloat)] = []

        for (weekIndex, week) in weeks.enumerated() {
            guard let firstDayOfWeek = week.compactMap({ $0 }).first else { continue }

            let month = calendar.component(.month, from: firstDayOfWeek.date)

            if !seenMonths.contains(month) {
                seenMonths.insert(month)

                let x = CGFloat(weekIndex) * (cellSize + cellSpacing)
                let label = monthName(month)
                positions.append((month: month, label: label, x: x))
            }
        }

        return positions
    }

    private func monthName(_ month: Int) -> String {
        let months = ["T1", "T2", "T3", "T4", "T5", "T6",
                      "T7", "T8", "T9", "T10", "T11", "T12"]
        guard month >= 1 && month <= 12 else { return "" }
        return months[month - 1]
    }

    private var weekdayLabels: some View {
        VStack(alignment: .leading, spacing: cellSpacing) {
            ForEach(0 ..< 7, id: \.self) { day in
                Text(showWeekdayLabel(day) ? weekdayName(day) : "")
                    .appFont(.caption)
                    .foregroundColor(.appTextSecondary)
                    .frame(width: weekdayLabelWidth, height: cellSize, alignment: .leading)
            }
        }
    }

    private func showWeekdayLabel(_ day: Int) -> Bool {
        // Show: Monday (1), Wednesday (3), Friday (5)
        return day == 1 || day == 3 || day == 5
    }

    private func weekdayName(_ day: Int) -> String {
        // 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri, 5=Sat, 6=Sun
        let names = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
        return names[day]
    }

    private var heatmapGrid: some View {
        HStack(alignment: .top, spacing: cellSpacing) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                VStack(spacing: cellSpacing) {
                    ForEach(0 ..< 7, id: \.self) { dayIndex in
                        if let activity = week[dayIndex] {
                            cell(for: activity)
                        } else {
                            Color.clear
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
        }
    }

    private func cell(for activity: DailyActivity) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color(for: activity.intensity))
            .frame(width: cellSize, height: cellSize)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .strokeBorder(
                        selectedActivity?.id == activity.id ? Color.appBrand : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    if selectedActivity?.id == activity.id {
                        selectedActivity = nil
                    } else {
                        selectedActivity = activity
                    }
                }
            }
    }

    private func color(for intensity: Int) -> Color {
        switch intensity {
        case 0: return Color.appBackgroundTertiary
        case 1: return Color.appBrand.opacity(0.3)
        case 2: return Color.appBrand.opacity(0.55)
        case 3: return Color.appBrand.opacity(0.8)
        default: return Color.appBrand
        }
    }

    private func tooltipView(activity: DailyActivity) -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.appBrand)
                .font(.system(size: 12))

            Text(formatTooltipDate(activity.date))
                .appFont(.bodySmall)
                .foregroundColor(.appTextPrimary)

            Spacer()

            if activity.movieCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "popcorn.fill")
                        .foregroundColor(.appBrand)
                        .font(.system(size: 11))
                    Text("\(activity.movieCount) phim")
                        .appFont(.headlineSmall)
                        .foregroundColor(.appBrand)
                }
            } else {
                Text("Không xem phim")
                    .appFont(.caption)
                    .foregroundColor(.appTextTertiary)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.sm)
                .fill(Color.appBackgroundTertiary)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func formatTooltipDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: date)
    }

    private var legendView: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("Ít")
                .appFont(.caption)
                .foregroundColor(.appTextSecondary)

            HStack(spacing: cellSpacing) {
                ForEach(0 ... 4, id: \.self) { intensity in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color(for: intensity))
                        .frame(width: cellSize, height: cellSize)
                }
            }

            Text("Nhiều")
                .appFont(.caption)
                .foregroundColor(.appTextSecondary)

            Spacer()

            Text("Chạm ô để xem chi tiết")
                .appFont(.caption)
                .foregroundColor(.appTextTertiary)
        }
    }

    private var emptyState: some View {
        Text("Chưa có hoạt động xem phim trong năm \(currentYear)")
            .appFont(.bodyMedium)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
    }
}
