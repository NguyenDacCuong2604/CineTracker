//
//  CineTrackerProvider.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import RealmSwift
import WidgetKit

struct CineTrackerEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

struct CineTrackerProvider: TimelineProvider {
    func placeholder(in _: Context) -> CineTrackerEntry {
        CineTrackerEntry(date: Date(), data: WidgetData.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (CineTrackerEntry) -> Void) {
        let data = context.isPreview ? WidgetData.placeholder : fetchWidgetData()
        let entry = CineTrackerEntry(date: Date(), data: data)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<CineTrackerEntry>) -> Void) {
        Task {
            let data = await fetchWidgetDataAsync() // ← async version
            let entry = CineTrackerEntry(date: Date(), data: data)

            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))

            completion(timeline)
        }
    }

    private func fetchWidgetDataAsync() async -> WidgetData {
        let data = fetchWidgetData()

        // Pre-warm image cache
        await prefetchImages(urls: data.movies.compactMap { $0.posterURL })

        return data
    }

    private func prefetchImages(urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    // Trigger URLSession cache
                    _ = try? await URLSession.shared.data(from: url)
                }
            }
        }
    }

    private func fetchWidgetData() -> WidgetData {
        do {
            RealmConfig.configure()
            let realm = try Realm()

            let wantToWatchRaw = SavedMovieObject.WatchStatus.wantToWatch.rawValue

            let objects = realm.objects(SavedMovieObject.self)
                .where { $0.statusRaw == wantToWatchRaw }
                .sorted(byKeyPath: "addedDate", ascending: false)
                .prefix(6)

            let movies = objects.map { object in
                let posterURL: URL? = object.posterURLString.flatMap {
                    URL(string: $0) ?? URL(string: "https://image.tmdb.org/t/p/w342\($0)")
                }

                // DEBUG
                print("  → Final URL: \(posterURL?.absoluteString ?? "nil")")

                return WidgetMovie(
                    id: object.id,
                    title: object.title,
                    posterURL: posterURL,
                    userRating: object.userRating,
                    status: object.status == .wantToWatch ? "Muốn xem" : "Đã xem"
                )
            }

            let totalCount = realm.objects(SavedMovieObject.self).count

            return WidgetData(
                movies: Array(movies),
                totalCount: totalCount,
                lastUpdated: Date()
            )
        } catch {
            print("Widget Realm error: \(error)")
            return WidgetData.empty
        }
    }
}
