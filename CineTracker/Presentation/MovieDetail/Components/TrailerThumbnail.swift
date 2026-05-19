//
//  TrailerThumbnail.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI

struct TrailerThumbnail: View {
    let video: Video

    @Environment(\.openURL) private var openURL

    var body: some View {
        Button(action: openTrailer) {
            ZStack {
                CachedAsyncImage(url: video.youtubeThumbnaiURL, contentMode: .fill) {
                    SkeletonView()
                }
                .aspectRatio(16 / 9, contentMode: .fit)

                Color.black.opacity(0.3)

                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 70, height: 70)

                    Image(systemName: "play.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .offset(x: 3)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        }
        .buttonStyle(.plain)
    }

    private func openTrailer() {
        guard let url = video.youtubeAppURL else { return }
        openURL(url)
    }
}
