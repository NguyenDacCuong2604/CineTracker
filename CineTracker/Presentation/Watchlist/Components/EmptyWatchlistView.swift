//
//  EmptyWatchlistView.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//

import SwiftUI

struct EmptyWatchlistView: View {
    let filterDescription: String
    var onDiscover: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "popcorn")
                .font(.system(size: 70))
                .foregroundColor(.appTextTertiary)

            VStack(spacing: AppSpacing.sm) {
                Text(emptyTitle)
                    .appFont(.headlineMedium)
                    .foregroundColor(.appTextPrimary)
                Text(emptyMessage)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }

            if let onDiscover = onDiscover {
                PrimaryButton(
                    title: L10n.Watchlist.exploreCTA,
                    icon: "sparkles",
                    action: onDiscover
                )
                .frame(maxWidth: 240)
                .padding(.top, AppSpacing.sm)
            }

            Spacer()
            Spacer()
        }
    }

    private var emptyTitle: String {
        switch filterDescription {
        case "favorites":
            return L10n.Watchlist.emptyFavoritesTitle
        case "watched":
            return L10n.Watchlist.emptyWatchedTitle
        case "wantToWatch":
            return L10n.Watchlist.emptyWantToWatchTitle
        default:
            return L10n.Watchlist.empty
        }
    }

    private var emptyMessage: String {
        switch filterDescription {
        case "favorites":
            return L10n.Watchlist.emptyFavoritesMessage
        case "watched":
            return L10n.Watchlist.emptyWatchedMessage
        case "wantToWatch":
            return L10n.Watchlist.emptyWantToWatchMessage
        default:
            return L10n.Watchlist.emptyAllMessage
        }
    }
}
