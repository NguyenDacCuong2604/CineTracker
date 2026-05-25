//
//  CineTrackerWidgetView.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import SwiftUI
import WidgetKit

struct CineTrackerWidgetView: View {
    let entry: CineTrackerEntry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(data: entry.data)
        case .systemMedium:
            MediumWidgetView(data: entry.data)
        case .systemLarge:
            LargeWidgetView(data: entry.data)
        default:
            EmptyView()
        }
    }
}

struct SmallWidgetView: View {
    let data: WidgetData

    var body: some View {
        if let movie = data.movies.first {
            ZStack {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }

                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading) {
                    Spacer()
                    Text(movie.status)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            }
            .widgetURL(URL(string: "cinetracker://movie/\(movie.id)"))
        } else {
            emptyState
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "popcorn.fill")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            Text(L10n.Widget.emptySmall)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct MediumWidgetView: View {
    let data: WidgetData

    var body: some View {
        if data.movies.isEmpty {
            emptyState
        } else {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "popcorn.fill")
                        .foregroundColor(.orange)
                    Text(L10n.Widget.watchlistHeader(data.totalCount))
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                }

                HStack(spacing: 8) {
                    ForEach(Array(data.movies.prefix(3))) { movie in
                        movieCard(movie)
                    }
                }
            }
            .padding(12)
            .widgetURL(URL(string: "cinetracker://watchlist"))
        }
    }

    private func movieCard(_ movie: WidgetMovie) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(2 / 3, contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2 / 3, contentMode: .fit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))

            Text(movie.title)
                .font(.caption2)
                .lineLimit(1)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "popcorn.fill")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            Text(L10n.Widget.emptyMedium)
                .font(.caption)
        }
    }
}

struct LargeWidgetView: View {
    let data: WidgetData

    var body: some View {
        if data.movies.isEmpty {
            emptyState
        } else {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "popcorn.fill")
                        .foregroundColor(.orange)
                    Text("CineTracker")
                        .font(.headline)
                    Spacer()
                    Text(L10n.Widget.movieCount(data.totalCount))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                ], spacing: 8) {
                    ForEach(Array(data.movies.prefix(6))) { movie in
                        movieCard(movie)
                    }
                }

                Spacer()
            }
            .padding(12)
            .widgetURL(URL(string: "cinetracker://watchlist"))
        }
    }

    private func movieCard(_ movie: WidgetMovie) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(2 / 3, contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2 / 3, contentMode: .fit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))

            Text(movie.title)
                .font(.caption2)
                .lineLimit(1)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "popcorn.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            Text(L10n.Widget.emptyLargeTitle)
                .font(.headline)
            Text(L10n.Widget.emptyLargeMessage)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
