//
//  WatchlistRepositoryImpl.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Combine
import Foundation
import OSLog
import Realm
import RealmSwift

final class WatchlistRepositoryImpl: WatchlistRepository {
    private let realm: Realm
    private let subject = CurrentValueSubject<[SavedMovie], Never>([])
    private var notificationToken: NotificationToken?

    var savedMoviesPublisher: AnyPublisher<[SavedMovie], Never> {
        subject.eraseToAnyPublisher()
    }

    @MainActor
    init() throws {
        realm = try Realm()
        observeChanges()
    }

    deinit {
        notificationToken?.invalidate()
    }

    private func observeChanges() {
        let results = realm.objects(SavedMovieObject.self)
        notificationToken = results.observe { [weak self] _ in
            self?.publishCurrent()
        }
        publishCurrent()
    }

    private func publishCurrent() {
        let movies = realm.objects(SavedMovieObject.self)
            .sorted(byKeyPath: "addedDate", ascending: false)
            .map { $0.toSavedMovie() }
        subject.send(Array(movies))
    }

    func add(_ movie: Movie) throws {
        if contains(id: movie.id) { return }
        try realm.write {
            let object = SavedMovieObject(from: movie)
            realm.add(object)
        }
        AppLogger.database.info("Added movie to watchlist: \(movie.title)")
    }

    func remove(id: Int) throws {
        guard let object = realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) else {
            return
        }
        try realm.write {
            realm.delete(object)
        }
    }

    func contains(id: Int) -> Bool {
        realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) != nil
    }

    func markAsWatched(id: Int, rating: Double, review: String) throws {
        guard let object = realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) else {
            return
        }
        try realm.write {
            object.statusRaw = SavedMovieObject.WatchStatus.watched.rawValue
            object.userRating = rating
            object.userReview = review
            object.watchedDate = Date()
        }
    }

    func toggleFavorite(id: Int) throws {
        guard let object = realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) else {
            return
        }
        try realm.write {
            object.isFavorite.toggle()
        }
    }

    func all() -> [SavedMovie] {
        Array(
            realm.objects(SavedMovieObject.self)
                .sorted(byKeyPath: "addedDate", ascending: false)
                .map { $0.toSavedMovie() }
        )
    }

    func filter(by status: SavedMovie.Status?) -> [SavedMovie] {
        let base = realm.objects(SavedMovieObject.self)
            .sorted(byKeyPath: "addedDate", ascending: false)

        if let status = status {
            return Array(
                base
                    .where { $0.statusRaw == status.rawValue }
                    .map { $0.toSavedMovie() }
            )
        }
        return Array(base.map { $0.toSavedMovie() })
    }

    func search(query: String) -> [SavedMovie] {
        guard !query.isEmpty else { return all() }
        return Array(
            realm.objects(SavedMovieObject.self)
                .where { $0.title.contains(query, options: .caseInsensitive) }
                .sorted(byKeyPath: "addedDate", ascending: false)
                .map { $0.toSavedMovie() }
        )
    }
}
