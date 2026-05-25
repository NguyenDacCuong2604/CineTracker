//
//  ProfileView.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel(
        getWatchlist: DIContainer.shared.getWatchlistUseCase,
        cacheManager: DIContainer.shared.cacheManager
    )

    @Environment(AppCoordinator.self) private var coordinator
    @State private var showSettings = false
    @State private var showClearCacheAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                headerSection
                    .padding(.top, AppSpacing.xl)

                statsSection

                menuSection

                appInfoSection

                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .background(Color.appBackground)
        .navigationTitle(L10n.Profile.title)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView()
            }
        }
        .alert(L10n.Profile.clearCacheTitle, isPresented: $showClearCacheAlert) {
            Button(L10n.Common.cancel, role: .cancel) {}
            Button(L10n.Common.confirm, role: .destructive) {
                Task { await viewModel.clearAllCache() }
            }
        } message: {
            Text(L10n.Profile.clearCacheMessage)
        }
        .task {
            await viewModel.calculateCacheSize()
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.appBrand)

            Text(L10n.Profile.welcome)
                .appFont(.headlineLarge)

            Text(L10n.Profile.subtitle)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
        }
    }

    private var statsSection: some View {
        HStack(spacing: AppSpacing.md) {
            statCard(
                value: "\(viewModel.state.totalMoviesInWatchlist)",
                label: L10n.Profile.totalMovies,
                icon: "bookmark.fill",
                color: .appBrand
            )

            statCard(
                value: "\(viewModel.state.totalMoviesWatched)",
                label: L10n.Profile.watched,
                icon: "checkmark.circle.fill",
                color: .appSuccess
            )
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .appFont(.displayMedium)
                .foregroundColor(.appTextPrimary)

            Text(label)
                .appFont(.bodySmall)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            menuRow(
                icon: "gearshape.fill",
                title: L10n.Profile.settings,
                action: { showSettings = true }
            )

            Divider().padding(.leading, 56)

            menuRow(
                icon: "trash.fill",
                title: L10n.Profile.clearCache,
                detail: viewModel.state.cacheSize,
                action: { showClearCacheAlert = true }
            )
        }
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private func menuRow(
        icon: String,
        title: String,
        detail: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .foregroundColor(.appBrand)
                    .frame(width: 24)

                Text(title)
                    .appFont(.bodyLarge)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                if let detail = detail {
                    Text(detail)
                        .appFont(.bodySmall)
                        .foregroundColor(.appTextSecondary)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.appTextTertiary)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(.plain)
    }

    private var appInfoSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("CineTracker")
                .appFont(.headlineMedium)

            Text(L10n.Profile.version(viewModel.state.appVersion))
                .appFont(.caption)
                .foregroundColor(.appTextSecondary)

            Text(L10n.Profile.madeWith)
                .appFont(.caption)
                .foregroundColor(.appTextTertiary)
                .padding(.top, AppSpacing.xs)
        }
        .padding(.top, AppSpacing.xl)
    }
}
