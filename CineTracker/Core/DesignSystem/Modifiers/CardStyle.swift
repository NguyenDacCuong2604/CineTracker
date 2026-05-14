//
//  CardStyle.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.md
    var padding: CGFloat = AppSpacing.lg
    var backgroundColor: Color = .appBackgroundSecondary

    func body(content: Content) -> some View {
        content.padding(padding).background(backgroundColor).cornerRadius(cornerRadius)
    }
}

extension View {
    func cardStyle(
        cornerRadius: CGFloat = AppRadius.md,
        padding: CGFloat = AppSpacing.lg,
        backgroundColor: Color = .appBackgroundSecondary
    ) -> some View {
        modifier(CardStyleModifier(cornerRadius: cornerRadius, padding: padding, backgroundColor: backgroundColor))
    }
}
