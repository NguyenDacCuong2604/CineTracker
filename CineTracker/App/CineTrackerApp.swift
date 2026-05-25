//
//  CineTrackerApp.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//

import OSLog
import RealmSwift
import SwiftUI

@main
struct CineTrackerApp: App {
    @State private var localizationManager = LocalizationManager.shared
    @State private var coordinator = AppCoordinator()

    init() {
        RealmConfig.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(coordinator)
                .environment(localizationManager)
                .id(localizationManager.currentLanguage)
        }
    }
}
