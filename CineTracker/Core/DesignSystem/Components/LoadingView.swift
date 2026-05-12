//
//  LoadingView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct LoadingView: View {
    var message: String? = nil
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            ProgressView().scaleEffect(1.5).tint(.appBrand)
            if let message = message {
                Text(message).appFont(.bodyMedium).foregroundColor(.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

#Preview {
    LoadingView(message: "Đang tải phim...")
}
