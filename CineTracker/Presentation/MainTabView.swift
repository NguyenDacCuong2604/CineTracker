//
//  MainTabView.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import OSLog
import SwiftUI

struct MainTabView: View {
    @State private var coordinator = AppCoordinator()
    @SceneStorage("selectedTab") private var savedTab: String = AppTab.discover.rawValue

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.discoverPath) {
                DiscoverView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.discover.title, systemImage: AppTab.discover.systemImage)
            }
            .tag(AppTab.discover)

            NavigationStack(path: $coordinator.searchPath) {
                SearchView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.search.title, systemImage: AppTab.search.systemImage)
            }
            .tag(AppTab.search)

            NavigationStack(path: $coordinator.watchlistPath) {
                WatchlistView()
                    .navigationDestination(for: Route.self) { router in
                        destinationView(for: router)
                    }
            }
            .tabItem {
                Label(AppTab.watchlist.title, systemImage: AppTab.watchlist.systemImage)
            }
            .tag(AppTab.watchlist)

            NavigationStack(path: $coordinator.statisticsPath) {
                PlaceholderView(tab: .statistics)
            }
            .tabItem {
                Label(AppTab.statistics.title, systemImage: AppTab.statistics.systemImage)
            }
            .tag(AppTab.statistics)

            NavigationStack(path: $coordinator.profilePath) {
                PlaceholderView(tab: .profile)
            }
            .tabItem {
                Label(AppTab.profile.title, systemImage: AppTab.profile.systemImage)
            }
            .tag(AppTab.profile)
        }
        .tint(.appBrand)
        .environment(coordinator)
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            if let restored = AppTab(rawValue: savedTab) {
                coordinator.selectedTab = restored
            }
        }
        .onChange(of: coordinator.selectedTab) { _, newTab in
            savedTab = newTab.rawValue
        }
    }

    private func handleDeepLink(_ url: URL) {
        AppLogger.navigation.info("Received deep link: \(url.absoluteString)")

        guard let result = DeepLinkHandler.parse(url) else {
            AppLogger.navigation.warning("Failed to parse deep link: \(url.absoluteString)")
            return
        }

        coordinator.handle(result)
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case let .movieDetail(id):
            MovieDetailView(movieID: id)
        case let .castDetail(id):
            PlaceholderDetailView(title: "Cast Detail", subtitle: "ID: \(id)")
        case let .allMovies(category):
            PlaceholderDetailView(title: category.title, subtitle: "All movies")
        }
    }
}

private struct PlaceholderDetailView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text(title)
                .appFont(.headlineLarge)
            Text(subtitle)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

private struct PlaceholderView: View {
    let tab: AppTab

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: tab.systemImage)
                .font(.system(size: 60))
                .foregroundColor(.appTextTertiary)
            Text(tab.title)
                .appFont(.headlineLarge)
            Text("Sẽ làm ở phase tiếp theo")
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationTitle(tab.title)
    }
}

#Preview {
    MainTabView()
}
