//
//  SettingView.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance: String = "system"

    @State private var localizationManager = LocalizationManager.shared

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(L10n.Settings.appearance) {
                Picker(L10n.Settings.theme, selection: $appearance) {
                    Text(L10n.Settings.themeSystem).tag("system")
                    Text(L10n.Settings.themeLight).tag("light")
                    Text(L10n.Settings.themeDark).tag("dark")
                }
            }

            Section(L10n.Settings.language) {
                ForEach(LocalizationManager.Language.allCases) { language in
                    Button {
                        localizationManager.setLanguage(language)
                    } label: {
                        HStack {
                            Text(language.flag)
                                .font(.title3)
                            Text(language.displayName)
                                .foregroundColor(.appTextPrimary)

                            Spacer()

                            if localizationManager.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.appBrand)
                            }
                        }
                    }
                }
            }

            Section(L10n.Settings.about) {
                Link(destination: URL(string: "https://www.themoviedb.org")!) {
                    HStack {
                        Text("Powered by TMDB")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.appTextSecondary)
                    }
                }

                Link(destination: URL(string: "https://github.com/NguyenDacCuong2604/CineTracker")!) {
                    HStack {
                        Text(L10n.Settings.sourceCode)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
        }
        .navigationTitle(L10n.Settings.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.Common.done) {
                    dismiss()
                }
            }
        }
        .preferredColorScheme(colorScheme)
    }

    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
