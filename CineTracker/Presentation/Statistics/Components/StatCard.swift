//
//  StatCard.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 36, height: 36)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())

            Text(value)
                .appFont(.displayMedium)
                .foregroundColor(.appTextPrimary)

            Text(label)
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }
}

#Preview {
    HStack(spacing: AppSpacing.md) {
        StatCard(
            icon: "popcorn.fill",
            iconColor: .appBrand,
            value: "42",
            label: "Tổng phim"
        )
        StatCard(
            icon: "star.fill",
            iconColor: .appBrandSecondary,
            value: "4.2",
            label: "Rating TB"
        )
    }
    .padding()
}
