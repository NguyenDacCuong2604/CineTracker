//
//  ParallaxHeader.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI

struct ParallaxHeader: View {
    let backdropURL: URL?
    let height: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let size = proxy.size

            let isScrollingDown = minY > 0
            let parallaxHeight = isScrollingDown ? size.height + minY : size.height
            let yOffset = isScrollingDown ? -minY : 0

            CachedAsyncImage(url: backdropURL, contentMode: .fill) {
                SkeletonView(cornerRadius: 0)
            }
            .frame(width: size.width, height: parallaxHeight)
            .clipped()
            .offset(y: yOffset)
            .overlay(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.3),
                        Color.appBackground,
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
            )
        }
        .frame(height: height)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 0) {
            ParallaxHeader(
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg"),
                height: 320
            )

            ForEach(0 ..< 20) { i in
                Text("Content \(i)")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
}
