//
//  EmptyStateView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: icon).font(.system(size: 70)).foregroundColor(.appTextTertiary)
            
            VStack(spacing: AppSpacing.sm) {
                Text(title).appFont(.headlineMedium).foregroundColor(.appTextPrimary)
                Text(message).appFont(.bodyMedium).foregroundColor(.appTextSecondary).multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action).frame(maxWidth: 240).padding(.top, AppSpacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    EmptyStateView(
        icon: "popcorn",
        title: "Chua co phim nao",
        message: "Hay kkham pha va them nhung bo phim yeu thich vao watchlist cua ban",
        actionTitle: "Kham pha ngay",
        action: {}
    )
}
