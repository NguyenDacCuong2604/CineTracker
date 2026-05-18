//
//  RecentSearchesRepositoryImpl.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Combine
import Foundation
import OSLog

final class RecentSearchesRepositoryImpl: RecentSearchesRepository {
    private let userDefaults: UserDefaults
    private let subject: CurrentValueSubject<[String], Never>

    var recentSearchesPublisher: AnyPublisher<[String], Never> {
        subject.eraseToAnyPublisher()
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let initial = userDefaults.stringArray(forKey: Constants.key) ?? []
        subject = CurrentValueSubject(initial)
    }

    func all() -> [String] {
        userDefaults.stringArray(forKey: Constants.key) ?? []
    }

    func add(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var current = all()

        current.removeAll { $0.lowercased() == trimmed.lowercased() }
        current.insert(trimmed, at: 0)

        if current.count > Constants.maxItems {
            current = Array(current.prefix(Constants.maxItems))
        }

        userDefaults.set(current, forKey: Constants.key)
        subject.send(current)

        AppLogger.app.debug("Added recent search: \(trimmed)")
    }

    func remove(_ query: String) {
        var current = all()
        current.removeAll { $0 == query }
        userDefaults.set(current, forKey: Constants.key)
        subject.send(current)
    }

    func clear() {
        userDefaults.removeObject(forKey: Constants.key)
        subject.send([])
        AppLogger.app.info("Cleared all recent searches")
    }

    private enum Constants {
        static let key = "com.cinetracker.recentSearches"
        static let maxItems = 10
    }
}
