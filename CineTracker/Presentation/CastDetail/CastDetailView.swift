//
//  CastDetailView.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import SwiftUI

struct CastDetailView: View {
    @State private var viewModel: CastDetailViewModel
    @State private var showBiographyExpanded = false

    @Environment(AppCoordinator.self) private var coordinator

    init(personID: Int) {
        let container = DIContainer.shared
        _viewModel = State(
            initialValue: CastDetailViewModel(
                personID: personID,
                fetchDetail: container.fetchPersonDetailUseCase,
                fetchCredits: container.fetchPersonMovieCreditsUseCase
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                content
            }
        }
        .background(Color.appBackground)
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state.person {
        case .idle, .loading:
            loadingView
        case let .loaded(persons):
            if let person = persons.first {
                loadedContent(person: person)
            }
        case let .error(error):
            errorView(message: error.localizedDescription)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: AppSpacing.lg) {
            ErrorView(
                message: message,
                onRetry: { Task { await viewModel.load() } }
            )
        }
        .frame(minHeight: 500)
    }

    private var loadingView: some View {
        VStack(spacing: AppSpacing.lg) {
            SkeletonView(cornerRadius: 0)
                .frame(height: 320)

            VStack(spacing: AppSpacing.md) {
                SkeletonView()
                    .frame(height: 32)
                SkeletonView()
                    .frame(width: 200, height: 16)
                SkeletonView()
                    .frame(height: 100)
            }

            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private func loadedContent(person: Person) -> some View {
        VStack(spacing: 0) {
            ParallaxHeader(backdropURL: person.profileURL, height: 320)

            personInfoHeader(person: person)
                .padding(.top, AppSpacing.lg)

            personInfoCard(person: person)
                .padding(.top, AppSpacing.lg)

            if !person.biography.isEmpty {
                biographySection(person: person)
                    .padding(.top, AppSpacing.xl)
            }

            filmographySection
                .padding(.top, AppSpacing.xl)

            Spacer(minLength: AppSpacing.xxl)
        }
    }

    private func personInfoHeader(person: Person) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(person.name)
                .appFont(.displayMedium)
                .foregroundColor(.appTextPrimary)

            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "person.fill")
                    .foregroundColor(.appBrand)
                    .font(.system(size: 12))
                Text(person.departmentTitle)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.lg)
    }

    private func personInfoCard(person: Person) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if let birthday = person.formattedBirthday {
                infoRow(
                    icon: "calendar",
                    label: "Sinh nhật",
                    value: birthday
                )
            }

            if let lifeStatus = person.lifeStatus {
                infoRow(
                    icon: person.deathday == nil ? "heart.fill" : "heart.slash.fill",
                    label: person.deathday == nil ? "Hiện tại" : "Đã mất",
                    value: lifeStatus
                )
            }

            if let placeOfBirth = person.placeOfBirth, !placeOfBirth.isEmpty {
                infoRow(
                    icon: "mappin.circle.fill",
                    label: "Nơi sinh",
                    value: placeOfBirth
                )
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color.appBackgroundSecondary)
        )
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(.appBrand)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .appFont(.caption)
                    .foregroundColor(.appTextSecondary)
                Text(value)
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextPrimary)
            }

            Spacer()
        }
    }

    private func biographySection(person: Person) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Tiểu sử")
                .appFont(.headlineLarge)

            Text(person.biography)
                .appFont(.bodyMedium)
                .foregroundColor(.appTextSecondary)
                .lineLimit(showBiographyExpanded ? nil : 6)
                .animation(.easeInOut(duration: 0.2), value: showBiographyExpanded)
                .fixedSize(horizontal: false, vertical: true)

            if person.biography.count > 300 {
                Button(showBiographyExpanded ? "Thu gọn" : "Đọc thêm") {
                    withAnimation { showBiographyExpanded.toggle() }
                }
                .appFont(.headlineSmall)
                .foregroundColor(.appBrand)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    @ViewBuilder
    private var filmographySection: some View {
        switch viewModel.state.credits {
        case .idle, .loading:
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Phim đã tham gia")
                    .appFont(.headlineLarge)
                    .padding(.horizontal, AppSpacing.lg)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(0 ..< 5, id: \.self) { _ in
                            MovieCardFilmoSkeleton()
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
            }

        case let .loaded(credits) where credits.isEmpty:
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Phim đã tham gia")
                    .appFont(.headlineLarge)
                    .padding(.horizontal, AppSpacing.lg)
                Text("Không có thông tin filmography")
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
                    .padding(.horizontal, AppSpacing.lg)
            }

        case let .loaded(credits):
            filmographyContent(credits: credits)

        case .error:
            EmptyView()
        }
    }

    private func filmographyContent(credits: [PersonMovieCredit]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Phim đã tham gia")
                    .appFont(.headlineLarge)

                Text("(\(credits.count))")
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, AppSpacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(credits) { credit in
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            MoviePosterCard(
                                movie: credit.toMovie(),
                                width: 120,
                                onTap: {
                                    coordinator.push(
                                        .movieDetail(id: credit.id),
                                        on: coordinator.selectedTab
                                    )
                                }
                            )

                            if let character = credit.character, !character.isEmpty {
                                Text("Vai: \(character)")
                                    .appFont(.caption)
                                    .foregroundColor(.appTextTertiary)
                                    .lineLimit(2)
                                    .frame(width: 120, height: 32, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

private struct MovieCardFilmoSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SkeletonView()
                .frame(width: 120, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))

            SkeletonView()
                .frame(width: 120, height: 14)

            SkeletonView()
                .frame(width: 80, height: 10)
        }
    }
}
