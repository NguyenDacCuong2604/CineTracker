//
//  Typography.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct AppFont {
    let font: Font
    let lineHeight: CGFloat

    // Display
    static let displayLarge = AppFont(font: .system(size: 36, weight: .bold, design: .default), lineHeight: 44)
    static let displayMedium = AppFont(font: .system(size: 28, weight: .bold, design: .default), lineHeight: 36)

    // Headline
    static let headlineLarge = AppFont(font: .system(size: 22, weight: .semibold, design: .default), lineHeight: 28)
    static let headlineMedium = AppFont(font: .system(size: 18, weight: .semibold, design: .default), lineHeight: 24)
    static let headlineSmall = AppFont(font: .system(size: 16, weight: .semibold, design: .default), lineHeight: 18)

    // Body
    static let bodyLarge = AppFont(font: .system(size: 17, weight: .regular, design: .default), lineHeight: 24)
    static let bodyMedium = AppFont(font: .system(size: 15, weight: .regular, design: .default), lineHeight: 20)
    static let bodySmall = AppFont(font: .system(size: 13, weight: .regular, design: .default), lineHeight: 18)

    // Label
    static let label = AppFont(font: .system(size: 12, weight: .medium, design: .default), lineHeight: 16)
    static let caption = AppFont(font: .system(size: 11, weight: .regular, design: .default), lineHeight: 14)
}

extension View {
    func appFont(_ appFont: AppFont) -> some View {
        font(appFont.font)
            .lineSpacing(appFont.lineHeight - UIFont.systemFont(ofSize: 17).lineHeight)
    }
}

#Preview("Typography") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Display Large").appFont(.displayLarge)
                Text("Display Medium").appFont(.displayMedium)
                Text("Headline Large").appFont(.headlineLarge)
                Text("Headline Medium").appFont(.headlineMedium)
                Text("Headline Small").appFont(.headlineSmall)
            }
            Group {
                Text("Body Large - The quick brown fox jumps over the lazy dog")
                    .appFont(.bodyLarge)
                Text("Body Medium - The quick brown fox jumps over the lazy dog")
                    .appFont(.bodyMedium)
                Text("Body Small - The quick brown fox jumps over the lazy dog")
                    .appFont(.bodySmall)
                Text("LABEL").appFont(.label)
                Text("Caption text").appFont(.caption)
            }
        }
        .padding()
    }
}
