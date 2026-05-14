//
//  Colors.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//
import SwiftUI

extension Color {
    // Brand
    static let appBrand = Color("brandPrimary")
    static let appBrandSecondary = Color("brandSecondary")

    // Background
    static let appBackground = Color("backgroundPrimary")
    static let appBackgroundSecondary = Color("backgroundSecondary")
    static let appBackgroundTertiary = Color("backgroundTertiary")

    // Text
    static let appTextPrimary = Color("textPrimary")
    static let appTextSecondary = Color("textSecondary")
    static let appTextTertiary = Color("textTertiary")

    // Status
    static let appSuccess = Color("success")
    static let appWarning = Color("warning")
    static let appError = Color("error")
    static let appInfo = Color("info")
}

#Preview("Colors") {
    ScrollView {
        VStack(spacing: 16) {
            colorRow("Brand", color: .appBrand)
            colorRow("Brand Secondary", color: .appBrandSecondary)
            colorRow("Background", color: .appBackground)
            colorRow("Background 2", color: .appBackgroundSecondary)
            colorRow("Text Primary", color: .appTextPrimary)
            colorRow("Success", color: .appSuccess)
            colorRow("Warning", color: .appWarning)
            colorRow("Error", color: .appError)
            colorRow("Info", color: .appInfo)
        }
        .padding()
    }
}

private func colorRow(_ name: String, color: Color) -> some View {
    HStack {
        Text(name)
            .frame(width: 150, alignment: .leading)
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )
    }
}
