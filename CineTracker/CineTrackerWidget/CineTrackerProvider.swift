//
//  CineTrackerProvider.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import RealmSwift
import UIKit
import WidgetKit

struct CineTrackerEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

struct CineTrackerProvider: TimelineProvider {
    private static let tmdbImageBase = "https://image.tmdb.org/t/p/w342"
    private static let posterTargetSize = CGSize(width: 200, height: 300)

    func placeholder(in _: Context) -> CineTrackerEntry {
        CineTrackerEntry(date: Date(), data: WidgetData.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (CineTrackerEntry) -> Void) {
        if context.isPreview {
            completion(CineTrackerEntry(date: Date(), data: WidgetData.placeholder))
            return
        }
        Task {
            let data = await fetchWidgetDataAsync()
            completion(CineTrackerEntry(date: Date(), data: data))
        }
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<CineTrackerEntry>) -> Void) {
        Task {
            let data = await fetchWidgetDataAsync()
            let entry = CineTrackerEntry(date: Date(), data: data)

            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))

            completion(timeline)
        }
    }

    private func fetchWidgetDataAsync() async -> WidgetData {
        let base = fetchBaseData()

        let uniqueMovies = mergeUnique(base.wantToWatchMovies, base.allMovies)
        let withImages = await loadImages(for: uniqueMovies)

        let want = base.wantToWatchMovies.compactMap { movie in withImages[movie.id] }
        let all = base.allMovies.compactMap { movie in withImages[movie.id] }

        return WidgetData(
            wantToWatchMovies: want,
            allMovies: all,
            totalCount: base.totalCount,
            lastUpdated: base.lastUpdated
        )
    }

    private func mergeUnique(_ a: [WidgetMovie], _ b: [WidgetMovie]) -> [WidgetMovie] {
        var seen = Set<Int>()
        var result: [WidgetMovie] = []
        for movie in a + b where !seen.contains(movie.id) {
            seen.insert(movie.id)
            result.append(movie)
        }
        return result
    }

    private func loadImages(for movies: [WidgetMovie]) async -> [Int: WidgetMovie] {
        await withTaskGroup(of: WidgetMovie.self) { group in
            for movie in movies {
                group.addTask {
                    let data = await loadImageData(from: movie.posterURL)
                    return WidgetMovie(
                        id: movie.id,
                        title: movie.title,
                        posterURL: movie.posterURL,
                        posterData: data,
                        userRating: movie.userRating,
                        status: movie.status
                    )
                }
            }

            var result: [Int: WidgetMovie] = [:]
            for await movie in group {
                result[movie.id] = movie
            }
            return result
        }
    }

    private func loadImageData(from url: URL?) async -> Data? {
        guard let url = url else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let http = response as? HTTPURLResponse, !(200 ..< 300).contains(http.statusCode) {
                return nil
            }
            return downsample(data: data, to: Self.posterTargetSize) ?? data
        } catch {
            return nil
        }
    }

    private func downsample(data: Data, to size: CGSize) -> Data? {
        let scale = UIScreen.main.scale
        let maxDimension = max(size.width, size.height) * scale

        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension,
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }

        let image = UIImage(cgImage: cgImage)
        return image.jpegData(compressionQuality: 0.85)
    }

    private func fetchBaseData() -> WidgetData {
        do {
            RealmConfig.configure()
            let realm = try Realm()

            let wantToWatchRaw = SavedMovieObject.WatchStatus.wantToWatch.rawValue

            let wantObjects = realm.objects(SavedMovieObject.self)
                .where { $0.statusRaw == wantToWatchRaw }
                .sorted(byKeyPath: "addedDate", ascending: false)
                .prefix(6)

            let allObjects = realm.objects(SavedMovieObject.self)
                .sorted(byKeyPath: "addedDate", ascending: false)
                .prefix(12)

            let want = wantObjects.map(Self.makeMovie)
            let all = allObjects.map(Self.makeMovie)

            let totalCount = realm.objects(SavedMovieObject.self).count

            return WidgetData(
                wantToWatchMovies: Array(want),
                allMovies: Array(all),
                totalCount: totalCount,
                lastUpdated: Date()
            )
        } catch {
            return WidgetData.empty
        }
    }

    private static func makeMovie(_ object: SavedMovieObject) -> WidgetMovie {
        WidgetMovie(
            id: object.id,
            title: object.title,
            posterURL: makePosterURL(from: object.posterURLString),
            posterData: nil,
            userRating: object.userRating,
            status: object.status == .wantToWatch ? L10n.MovieStatus.wantToWatch : L10n.MovieStatus.watched
        )
    }

    private static func makePosterURL(from raw: String?) -> URL? {
        guard let raw = raw, !raw.isEmpty else { return nil }

        if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://") {
            return URL(string: raw)
        }

        let path = raw.hasPrefix("/") ? raw : "/" + raw
        return URL(string: tmdbImageBase + path)
    }
}
