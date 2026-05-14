//
//  CachedAsyncImage.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import OSLog
import SwiftUI

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL?
    let contentMode: ContentMode
    let placeholder: () -> Placeholder

    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var loadError = false

    init(
        url: URL?,
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let imageData = imageData,
               let image = imageFromData(imageData)
            {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private func imageFromData(_ data: Data) -> Image? {
        guard let provider = CGDataProvider(data: data as CFData) else {
            return nil
        }

        if let cgImage = CGImage(
            pngDataProviderSource: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) {
            return Image(decorative: cgImage, scale: 1.0)
        }

        if let cgImage = CGImage(
            jpegDataProviderSource: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) {
            return Image(decorative: cgImage, scale: 1.0)
        }

        return nil
    }

    private func loadImage() async {
        guard let url = url else {
            imageData = nil
            return
        }

        guard !isLoading else { return }

        isLoading = true
        loadError = false

        defer { isLoading = false }

        do {
            let data = try await ImageCache.share.imageData(for: url)
            try Task.checkCancellation()
            withAnimation(.easeIn(duration: 0.2)) {
                self.imageData = data
            }
        } catch is CancellationError {
            return
        } catch {
            AppLogger.cache.error("Failed to load image: \(error)")
            loadError = true
        }
    }
}

extension CachedAsyncImage where Placeholder == SkeletonView {
    init(url: URL?, contentMode: ContentMode = .fill) {
        self.init(url: url, contentMode: contentMode) {
            SkeletonView()
        }
    }
}

#Preview("With URL") {
    CachedAsyncImage(
        url: URL(string: "https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg")
    )
    .aspectRatio(2 / 3, contentMode: .fit)
    .frame(width: 200)
    .padding()
}

#Preview("Nil URL") {
    CachedAsyncImage(url: nil)
        .aspectRatio(2 / 3, contentMode: .fit)
        .frame(width: 200)
        .padding()
}

#Preview("With Custom Placeholder") {
    CachedAsyncImage(
        url: URL(string: "https://invalid.url/image.jpg")
    ) {
        Rectangle()
            .fill(Color.appBackgroundTertiary)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.appTextTertiary)
            )
    }
    .aspectRatio(2 / 3, contentMode: .fit)
    .frame(width: 200)
    .padding()
}
