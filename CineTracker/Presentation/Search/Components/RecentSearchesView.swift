//
//  RecentSearchesView.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct RecentSearchesView: View {
    let searches: [String]
    let onSelect: (String) -> Void
    let onRemove: (String) -> Void
    let onClearAll: () -> Void

    var body: some View {
        if searches.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    private var listContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(L10n.Search.recent)
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                Button(L10n.Search.clearAll) {
                    onClearAll()
                }
                .appFont(.bodySmall)
                .foregroundColor(.appBrand)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.md)

            ForEach(searches, id: \.self) { search in
                Button(action: { onSelect(search) }) {
                    HStack(spacing: AppSpacing.md) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.appTextTertiary)
                            .font(.system(size: 16))

                        Text(search)
                            .appFont(.bodyMedium)
                            .foregroundColor(.appTextPrimary)

                        Spacer()

                        Button(action: { onRemove(search) }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.appTextTertiary)
                                .font(.system(size: 12, weight: .medium))
                                .padding(AppSpacing.xs)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, AppSpacing.md)
                    .padding(.horizontal, AppSpacing.lg)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, AppSpacing.lg)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.appTextTertiary)

            Text(L10n.Search.startSearching)
                .appFont(.headlineMedium)
                .foregroundColor(.appTextPrimary)

            Text(L10n.Search.searchHint)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxxl)
    }
}

#Preview("With searches") {
    RecentSearchesView(
        searches: ["Inception", "Interstellar", "The Dark Knight", "Tenet"],
        onSelect: { _ in },
        onRemove: { _ in },
        onClearAll: {}
    )
}
