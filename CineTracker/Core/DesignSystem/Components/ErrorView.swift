//
//  ErrorView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct ErrorView: View {
    var icon: String = "exclamationmark.triangle.fill"
    var title: String = L10n.Common.errorTitle
    let message: String
    var retryTitle: String = L10n.Common.retry
    let onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: icon).font(.system(size: 60)).foregroundColor(.appError)

            VStack(spacing: AppSpacing.sm) {
                Text(title).appFont(.headlineMedium).foregroundColor(.appTextPrimary)
                Text(message).appFont(.bodyMedium).foregroundColor(.appTextSecondary).multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.xl)

            if let onRetry = onRetry {
                PrimaryButton(
                    title: retryTitle,
                    icon: "arrow.clockwise",
                    action: onRetry
                )
                .frame(maxWidth: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    ErrorView(
        message: "Kết nối mạng không ổn định. Vui lòng kiểm tra lại.",
        onRetry: {}
    )
}
