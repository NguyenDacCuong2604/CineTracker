//
//  DesignSystemCatalog.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct DesignSystemCatalog: View {
    @State private var interactiveRating: Double = 3
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    section("🎨 Colors") {
                        colorGrid
                    }
                    
                    section("✍️ Typography") {
                        typographyList
                    }
                    
                    section("🔘 Buttons") {
                        buttonsList
                    }
                    
                    section("⏳ Loading & Skeleton") {
                        loadingList
                    }
                    
                    section("⭐ Rating") {
                        ratingList
                    }
                    
                    section("📦 Cards") {
                        cardsList
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Design System")
        }
    }
    
    @ViewBuilder
    private func section<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .appFont(.headlineLarge)
                .foregroundColor(.appTextPrimary)
            content()
        }
    }
    
    private var colorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
            colorTile("Brand", .appBrand)
            colorTile("Brand 2", .appBrandSecondary)
            colorTile("BG", .appBackground)
            colorTile("BG 2", .appBackgroundSecondary)
            colorTile("Success", .appSuccess)
            colorTile("Warning", .appWarning)
            colorTile("Error", .appError)
            colorTile("Info", .appInfo)
        }
    }
    
    private func colorTile(_ name: String, _ color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: AppRadius.sm)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .stroke(Color.appTextTertiary.opacity(0.3))
                )
            Text(name)
                .appFont(.bodySmall)
            Spacer()
        }
    }
       
    private var typographyList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Display Large").appFont(.displayLarge)
            Text("Display Medium").appFont(.displayMedium)
            Text("Headline Large").appFont(.headlineLarge)
            Text("Headline Medium").appFont(.headlineMedium)
            Text("Headline Small").appFont(.headlineSmall)
            Text("Body Large - sample text").appFont(.bodyLarge)
            Text("Body Medium - sample text").appFont(.bodyMedium)
            Text("Body Small - sample text").appFont(.bodySmall)
            Text("LABEL TEXT").appFont(.label)
            Text("Caption text").appFont(.caption)
        }
        .foregroundColor(.appTextPrimary)
    }
       
    private var buttonsList: some View {
        VStack(spacing: AppSpacing.md) {
            PrimaryButton(title: "Primary Button") {}
            PrimaryButton(title: "With Icon", icon: "plus") {}
            PrimaryButton(title: "Loading", isLoading: true) {}
            PrimaryButton(title: "Disabled", isEnabled: false) {}
            
            SecondaryButton(title: "Secondary Button") {}
            SecondaryButton(title: "With Icon", icon: "square.and.arrow.up") {}
        }
    }
       
    private var loadingList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.appBrand)
                Text("Spinner").appFont(.bodyMedium)
            }
            
            Text("Skeleton placeholders:")
                .appFont(.bodyMedium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(0..<3, id: \.self) { _ in
                        MovieCardSkeleton()
                    }
                }
            }
        }
    }
      
    private var ratingList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Display:").appFont(.bodyMedium)
                RatingView(rating: 4.5)
            }
            HStack {
                Text("Half star:").appFont(.bodyMedium)
                RatingView(rating: 3.5)
            }
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Interactive (tap to rate):").appFont(.bodyMedium)
                RatingView(rating: $interactiveRating)
                Text("You rated: \(interactiveRating, specifier: "%.1f")")
                    .appFont(.bodySmall)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .foregroundColor(.appTextPrimary)
    }
     
    private var cardsList: some View {
        VStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Card Title").appFont(.headlineMedium)
                Text("This is a card with default styling using .cardStyle() modifier.")
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
            }
            .cardStyle()
            
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Custom Card").appFont(.headlineSmall)
                    Text("With different colors").appFont(.bodySmall)
                }
                Spacer()
                Image(systemName: "popcorn.fill")
                    .font(.title)
                    .foregroundColor(.appBrand)
            }
            .cardStyle(backgroundColor: .appBrand.opacity(0.1))
        }
    }
}

#Preview {
    DesignSystemCatalog()
}
