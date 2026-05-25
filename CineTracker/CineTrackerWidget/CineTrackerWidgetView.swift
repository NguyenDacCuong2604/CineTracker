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

// MARK: - Small (vertical list 3 phim "muốn xem")

struct SmallWidgetView: View {
    let data: WidgetData

    private var movies: [WidgetMovie] {
        data.wantToWatchMovies
    }

    var body: some View {
        if movies.isEmpty {
            EmptyStateView(
                size: .small,
                title: L10n.Widget.emptySmall,
                message: nil
            )
        } else {
            VStack(alignment: .leading, spacing: 4) {
                header

                ForEach(Array(movies.prefix(3))) { movie in
                    movieRow(movie)
                }

                Spacer(minLength: 0)
            }
            .widgetURL(URL(string: "cinetracker://watchlist"))
        }
    }

    private var header: some View {
        HStack(spacing: 4) {
            Image(systemName: "popcorn.fill")
                .foregroundColor(.orange)
                .font(.system(size: 10))

            Text(L10n.Widget.watchlistHeader(data.totalCount))
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding(.bottom, 2)
    }

    private func movieRow(_ movie: WidgetMovie) -> some View {
        HStack(spacing: 6) {
            WidgetPoster(data: movie.posterData, contentMode: .fill)
                .frame(width: 26, height: 39)
                .clipShape(RoundedRectangle(cornerRadius: 3))

            Text(movie.title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Medium (hero có title + list nhỏ bên phải)

struct MediumWidgetView: View {
    let data: WidgetData

    private var movies: [WidgetMovie] {
        data.wantToWatchMovies
    }

    var body: some View {
        if movies.isEmpty {
            EmptyStateView(
                size: .medium,
                title: L10n.Widget.emptyMedium,
                message: nil
            )
        } else {
            HStack(alignment: .top, spacing: 10) {
                if let hero = movies.first {
                    heroCard(hero)
                }

                listColumn
            }
            .widgetURL(URL(string: "cinetracker://watchlist"))
        }
    }

    private func heroCard(_ movie: WidgetMovie) -> some View {
        Link(destination: URL(string: "cinetracker://movie/\(movie.id)")!) {
            ZStack(alignment: .bottomLeading) {
                WidgetPoster(data: movie.posterData, contentMode: .fill)
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                LinearGradient(
                    colors: [.clear, .clear, .black.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(movie.status)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    Text(movie.title)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(6)
            }
        }
    }

    private var listColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "popcorn.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 11))

                Text(L10n.Widget.watchlistHeader(data.totalCount))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)

                Spacer()
            }

            ForEach(Array(movies.dropFirst().prefix(3))) { movie in
                listRow(movie)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private func listRow(_ movie: WidgetMovie) -> some View {
        Link(destination: URL(string: "cinetracker://movie/\(movie.id)")!) {
            HStack(spacing: 6) {
                WidgetPoster(data: movie.posterData, contentMode: .fill)
                    .frame(width: 22, height: 33)
                    .clipShape(RoundedRectangle(cornerRadius: 3))

                Text(movie.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Large (grid 4 cột × 3 hàng — ALL phim trong watchlist)

struct LargeWidgetView: View {
    let data: WidgetData

    private var movies: [WidgetMovie] {
        data.allMovies
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        if movies.isEmpty {
            EmptyStateView(
                size: .large,
                title: L10n.Widget.emptyLargeTitle,
                message: L10n.Widget.emptyLargeMessage
            )
        } else {
            VStack(alignment: .leading, spacing: 10) {
                header

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(movies.prefix(12))) { movie in
                        movieCell(movie)
                    }
                }

                Spacer(minLength: 0)
            }
            .widgetURL(URL(string: "cinetracker://watchlist"))
        }
    }

    private var header: some View {
        HStack(spacing: 6) {
            Image(systemName: "popcorn.fill")
                .foregroundColor(.orange)
                .font(.system(size: 14))

            Text("CineTracker")
                .font(.system(size: 14, weight: .semibold))

            Spacer()

            Text(L10n.Widget.movieCount(data.totalCount))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
    }

    private func movieCell(_ movie: WidgetMovie) -> some View {
        Link(destination: URL(string: "cinetracker://movie/\(movie.id)")!) {
            VStack(alignment: .leading, spacing: 3) {
                WidgetPoster(data: movie.posterData, contentMode: .fill)
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                Text(movie.title)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Shared subviews

private struct WidgetPoster: View {
    let data: Data?
    let contentMode: ContentMode

    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.25))
            .overlay(
                Image(systemName: "film")
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.6))
            )
    }
}

private struct EmptyStateView: View {
    enum Size {
        case small
        case medium
        case large
    }

    let size: Size
    let title: String
    let message: String?

    var body: some View {
        VStack(spacing: spacing) {
            Image(systemName: "popcorn.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.orange)

            Text(title)
                .font(titleFont)
                .multilineTextAlignment(.center)

            if let message = message {
                Text(message)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var iconSize: CGFloat {
        switch size {
        case .small: return 28
        case .medium: return 32
        case .large: return 48
        }
    }

    private var titleFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .subheadline
        case .large: return .headline
        }
    }

    private var spacing: CGFloat {
        switch size {
        case .small: return 6
        case .medium: return 8
        case .large: return 12
        }
    }
}
