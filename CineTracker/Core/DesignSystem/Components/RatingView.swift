//
//  RatingView.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Double
    var maxRating: Int = 5
    var isInteractive: Bool = false
    var starSize: CGFloat = 20
    var filledColor: Color = .appBrandSecondary
    var emptyColor: Color = .appTextTertiary
    
    init(rating: Double, maxRating: Int = 5, starSize: CGFloat = 20) {
        self._rating = .constant(rating)
        self.maxRating = maxRating
        self.isInteractive = false
        self.starSize = starSize
    }
    
    init(rating: Binding<Double>, maxRating: Int = 5, starSize: CGFloat = 32, isInteractive: Bool = true) {
        self._rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        self.isInteractive = isInteractive
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(1...maxRating, id: \.self) {
                index in starImage(for: index)
                    .resizable()
                    .scaledToFit()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(Double(index) <= rating ? filledColor : emptyColor)
                    .onTapGesture {
                        if isInteractive {
                            withAnimation(.spring(response: 0.3)) {
                                rating = Double(index)
                            }
                        }
                    }
            }
        }
    }
    
    private func starImage(for index: Int) -> Image {
        let position = Double(index)
        if rating >= position {
            return Image(systemName: "star.fill")
        } else if rating >= position - 0.5 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}

#Preview("Display") {
    VStack(spacing: AppSpacing.lg) {
        RatingView(rating: 4.5)
        RatingView(rating: 3.0)
        RatingView(rating: 5.0)
        RatingView(rating: 2.5, starSize: 30)
    }
}

#Preview("Interactive") {
    struct InteractivePreview: View {
        @State var rating: Double = 2.5
        
        var body: some View {
            VStack(spacing: AppSpacing.lg) {
                RatingView(rating: $rating)
                Text("Rating: \(rating, specifier: "%.1f")").appFont(.bodyMedium)
            }
            .padding()
        }
    }
    return InteractivePreview()
}
