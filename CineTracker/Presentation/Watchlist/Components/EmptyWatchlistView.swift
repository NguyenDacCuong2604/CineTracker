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
                    title: "Khám phá phim",
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
            return "Chưa có phim yêu thích"
        case "watched":
            return "Chưa xem phim nào"
        case "wantToWatch":
            return "Chưa có phim muốn xem"
        default:
            return "Watchlist trống"
        }
    }

    private var emptyMessage: String {
        switch filterDescription {
        case "favorites":
            return "Đánh dấu yêu thích những bộ phim ấn tượng nhất với bạn"
        case "watched":
            return "Đánh dấu các phim đã xem để theo dõi lịch sử xem"
        case "wantToWatch":
            return "Thêm những bộ phim bạn muốn xem vào danh sách"
        default:
            return "Khám phá và thêm những bộ phim yêu thích vào watchlist"
        }
    }
}
