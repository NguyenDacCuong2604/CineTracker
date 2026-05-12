//
//  SkeletonView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct SkeletonView: View {
    var cornerRadius: CGFloat = AppRadius.sm
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.appBackgroundTertiary).shimmer()
    }
}

struct MovieCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SkeletonView(cornerRadius: AppRadius.md).frame(width: 140, height: 210)
            SkeletonView().frame(width: 120, height: 14)
            SkeletonView().frame(width: 80, height: 12)
        }
    }
}

#Preview("Basic") {
    VStack(spacing: AppSpacing.lg) {
        SkeletonView().frame(width: 200, height: 30)
        SkeletonView().frame(width: 150, height: 20)
        SkeletonView().frame(width: 80, height: 12)
    }
    .padding()
}

#Preview("Movie Cards") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: AppSpacing.md) {
            ForEach(0..<5, id: \.self) { _ in MovieCardSkeleton()}
        }
        .padding()
    }
}
