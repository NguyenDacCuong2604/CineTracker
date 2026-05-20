//
//  UndoToast.swift
//  CineTracker
//
//  Created by MAC VN on 20/5/26.
//
import SwiftUI

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "trash")
                .foregroundColor(.white)

            Text(message)
                .appFont(.bodyMedium)
                .foregroundColor(.white)
                .lineLimit(1)

            Spacer()

            Button(action: onUndo) {
                Text("Hoàn tác")
                    .appFont(.headlineSmall)
                    .foregroundColor(.appBrandSecondary)
            }

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .medium))
                    .padding(AppSpacing.xs)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appTextPrimary.opacity(0.9))
        )
        .padding(.horizontal, AppSpacing.lg)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
