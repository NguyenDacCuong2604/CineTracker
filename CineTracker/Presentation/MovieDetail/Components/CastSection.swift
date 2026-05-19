//
//  CastSection.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI

struct CastSection: View {
    let cast: [Cast]
    var onCastTap: ((Cast) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Diễn viên")
                .appFont(.headlineLarge)
                .padding(.horizontal, AppSpacing.lg)

            if cast.isEmpty {
                Text("Không có thông tin diễn viên")
                    .appFont(.bodyMedium)
                    .foregroundColor(.appTextSecondary)
                    .padding(.horizontal, AppSpacing.lg)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(cast) { member in
                            CastCard(cast: member) {
                                onCastTap?(member)
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
            }
        }
    }
}

private struct CastCard: View {
    let cast: Cast
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: AppSpacing.xs) {
                CachedAsyncImage(url: cast.profileURL, contentMode: .fill) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.appTextTertiary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.appBackgroundTertiary)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.appBackgroundTertiary, lineWidth: 1)
                )

                Text(cast.name)
                    .appFont(.headlineSmall)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 110, height: 40, alignment: .center)

                Text(cast.character)
                    .appFont(.caption)
                    .foregroundColor(.appTextSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 110, height: 28, alignment: .top)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CastSection(
        cast: [
            Cast(id: 1, name: "Nguyễn Đắc Cường", character: "Cuongnd", profileURL: URL(string: "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/670933890_3805580749748744_4678205791711388062_n.jpg?stp=cp6_dst-jpg_tt6&_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=eYTvtVSoNQYQ7kNvwHFVt9h&_nc_oc=AdrxKGVJfRKPefzmVCPchd3r_0LACo1z_fdJetp8w2_-2XgVLPZwqhnopFjy0_yrkok&_nc_zt=23&_nc_ht=scontent.fsgn19-1.fna&_nc_gid=dTewRnVTiZk-hX_fVdXIrg&_nc_ss=7b2a8&oh=00_Af4_rtiMXzu_LCLepWU7gNjOUIIEU7bcZNtThvzS1P-s2Q&oe=6A11DFDE"), order: 0),
            Cast(id: 2, name: "Joseph Gordon-Levitt", character: "Arthur", profileURL: nil, order: 1),
        ]
    )
}
