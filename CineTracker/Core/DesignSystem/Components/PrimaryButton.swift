//
//  PrimaryButton.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//
import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title).appFont(.headlineSmall)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(isEnabled ? Color.appBrand : Color.gray))
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.6)
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        PrimaryButton(title: "Add to Watchlist") {}
        PrimaryButton(title: "Save", icon: "checkmark") {}
        PrimaryButton(title: "Loading...", isLoading: true) {}
        PrimaryButton(title: "Disabled", isEnabled: false) {}
    }
    .padding()
}
