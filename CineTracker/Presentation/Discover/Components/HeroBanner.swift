//
//  HeroBanner.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import SwiftUI

struct HeroBanner: View {
    let movies: [Movie]
    var onMovieTap: ((Movie) -> Void)? = nil

    @State private var currentIndex = 0
    @State private var timerCancellable: Timer?

    private let autoScrollInterval: TimeInterval = 4
    private let bannerHeight: CGFloat = 280

    private let aspectRatio: CGFloat = 16.0 / 9.0
    private let minHeight: CGFloat = 240
    private let maxHeight: CGFloat = 360

    var body: some View {
        GeometryReader { geometry in
            let bannerHeight = calculateBannerHeight(for: geometry.size.width)

            Group {
                if movies.isEmpty {
                    placeholder(height: bannerHeight)
                } else {
                    bannerContent(height: bannerHeight)
                }
            }
            .frame(width: geometry.size.width, height: bannerHeight)
        }
        .frame(height: calculateBannerHeight(for: UIScreen.main.bounds.width))
    }

    private func calculateBannerHeight(for width: CGFloat) -> CGFloat {
        let calculated = width / aspectRatio
        return max(minHeight, min(calculated, maxHeight))
    }

    private func placeholder(height: CGFloat) -> some View {
        SkeletonView(cornerRadius: 0)
            .frame(height: height)
    }

    private func bannerContent(height: CGFloat) -> some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                bannerItem(movie: movie, height: height)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onAppear { startAutoScroll() }
        .onDisappear { stopAutoScroll() }
        .onChange(of: currentIndex) { _, _ in
            restartAutoScroll()
        }
    }

    private func startAutoScroll() {
        timerCancellable = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            Task { @MainActor in withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % movies.count
            }
            }
        }
    }

    private func stopAutoScroll() {
        timerCancellable?.invalidate()
        timerCancellable = nil
    }

    private func restartAutoScroll() {
        stopAutoScroll()
        startAutoScroll()
    }

    private func bannerItem(movie: Movie, height: CGFloat) -> some View {
        Button(action: { onMovieTap?(movie) }) {
            ZStack(alignment: .bottomLeading) {
                // Backdrop image - fill the entire container
                CachedAsyncImage(
                    url: movie.backdropURL ?? movie.posterURL,
                    contentMode: .fill
                ) {
                    SkeletonView(cornerRadius: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

                // Gradient overlay - mạnh hơn ở bottom để text rõ
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.9),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)

                // Info content
                infoContent(movie: movie)
            }
            .frame(height: height)
            .clipped()
        }
        .buttonStyle(.plain)
    }

    private func infoContent(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Trending badge
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.appBrand)
                Text("Trending")
                    .appFont(.label)
                    .foregroundColor(.white)
            }

            // Title
            Text(movie.title)
                .appFont(.displayMedium)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // Meta info
            HStack(spacing: AppSpacing.md) {
                Label(movie.formattedRating, systemImage: "star.fill")
                    .appFont(.bodySmall)
                    .foregroundColor(.appBrandSecondary)

                Text(movie.releaseYear)
                    .appFont(.bodySmall)
                    .foregroundColor(.white.opacity(0.85))
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xxl) // ← tăng padding bottom để tránh page dots
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HeroBanner(
        movies: [
            Movie(id: 1, title: "Inception", overview: "", posterURL: nil, backdropURL: URL(string: "https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg"), releaseDate: Date(), rating: 8.4, voteCount: 0, genreIDs: []),
            Movie(id: 2, title: "Interstellar", overview: "", posterURL: nil, backdropURL: URL(string: "https://image.tmdb.org/t/p/w780/pbrkL804c8yAv3zBZR4QPEafpAR.jpg"), releaseDate: Date(), rating: 8.6, voteCount: 0, genreIDs: []),
        ]
    )
}
