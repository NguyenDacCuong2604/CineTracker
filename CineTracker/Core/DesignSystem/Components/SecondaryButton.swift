//
//  SecondaryButton.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//
import SwiftUI

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title).appFont(.headlineSmall)
            }
            .foregroundColor(.appBrand)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appBrand, lineWidth: 1.5))
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        SecondaryButton(title: "Cancel") {}
        SecondaryButton(title: "Share", icon: "square.and.arrow.up") {}
        SecondaryButton(title: "Disabled", isEnabled: false) {}
    }
    .padding()
}
