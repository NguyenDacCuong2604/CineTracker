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
import WidgetKit

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
            .map { SavedMovieRealmMapper.toDomain($0) }
        subject.send(Array(movies))
    }

    func add(_ movie: Movie) throws {
        if contains(id: movie.id) { return }
        try realm.write {
            let object = SavedMovieRealmMapper.toRealmObject(movie)
            realm.add(object)
        }
        AppLogger.database.info("Added movie to watchlist: \(movie.title)")
        WidgetCenter.shared.reloadAllTimelines()
    }

    func remove(id: Int) throws {
        guard let object = realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) else {
            return
        }
        try realm.write {
            realm.delete(object)
        }

        WidgetCenter.shared.reloadAllTimelines()
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

        WidgetCenter.shared.reloadAllTimelines()
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
                .map { SavedMovieRealmMapper.toDomain($0) }
        )
    }

    func filter(by status: SavedMovie.Status?) -> [SavedMovie] {
        let base = realm.objects(SavedMovieObject.self)
            .sorted(byKeyPath: "addedDate", ascending: false)

        if let status = status {
            return Array(
                base
                    .where { $0.statusRaw == status.rawValue }
                    .map { SavedMovieRealmMapper.toDomain($0) }
            )
        }
        return Array(base.map { SavedMovieRealmMapper.toDomain($0) })
    }

    func search(query: String) -> [SavedMovie] {
        guard !query.isEmpty else { return all() }
        return Array(
            realm.objects(SavedMovieObject.self)
                .where { $0.title.contains(query, options: .caseInsensitive) }
                .sorted(byKeyPath: "addedDate", ascending: false)
                .map { SavedMovieRealmMapper.toDomain($0) }
        )
    }

    func batchRemove(ids: [Int]) throws {
        let objects = realm.objects(SavedMovieObject.self)
            .where { $0.id.in(ids) }

        try realm.write {
            realm.delete(objects)
        }

        AppLogger.database.info("Batch removed \(ids.count) movies")
    }

    func restore(_ savedMovie: SavedMovie) throws {
        let object = SavedMovieObject()
        object.id = savedMovie.id
        object.title = savedMovie.movie.title
        object.overview = savedMovie.movie.overview
        object.posterURLString = savedMovie.movie.posterURL?.absoluteString
        object.backdropURLString = savedMovie.movie.backdropURL?.absoluteString
        object.releaseDate = savedMovie.movie.releaseDate
        object.rating = savedMovie.movie.rating
        object.voteCount = savedMovie.movie.voteCount
        object.statusRaw = savedMovie.status.rawValue
        object.userRating = savedMovie.userRating
        object.userReview = savedMovie.userReview
        object.watchedDate = savedMovie.watchedDate
        object.addedDate = savedMovie.addedDate
        object.isFavorite = savedMovie.isFavorite

        try realm.write {
            realm.add(object)
        }

        AppLogger.database.info("Restored movie: \(savedMovie.movie.title)")
    }

    func filteredMovies(status: SavedMovie.Status?, sortBy: WatchlistSortOption, query: String) -> [SavedMovie] {
        var results = realm.objects(SavedMovieObject.self)

        if let status = status {
            results = results.where { $0.statusRaw == status.rawValue }
        }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedQuery.isEmpty {
            results = results.where { $0.title.contains(trimmedQuery, options: .caseInsensitive) }
        }

        let sorted: Results<SavedMovieObject>
        switch sortBy {
        case .dateAddedDesc:
            sorted = results.sorted(byKeyPath: "addedDate", ascending: false)
        case .dateAddedAsc:
            sorted = results.sorted(byKeyPath: "addedDate", ascending: true)
        case .ratingDesc:
            sorted = results.sorted(byKeyPath: "rating", ascending: false)
        case .ratingAsc:
            sorted = results.sorted(byKeyPath: "rating", ascending: true)
        case .titleDesc:
            sorted = results.sorted(byKeyPath: "title", ascending: false)
        case .titleAsc:
            sorted = results.sorted(byKeyPath: "title", ascending: true)
        case .releaseDateDesc:
            sorted = results.sorted(byKeyPath: "releaseDate", ascending: false)
        case .releaseDateAsc:
            sorted = results.sorted(byKeyPath: "releaseDate", ascending: true)
        }

        return Array(sorted.map { SavedMovieRealmMapper.toDomain($0) })
    }

    func savedMovie(id: Int) -> SavedMovie? {
        guard let object = realm.object(ofType: SavedMovieObject.self, forPrimaryKey: id) else {
            return nil
        }
        return SavedMovieRealmMapper.toDomain(object)
    }

    func allWatchedMovies() -> [SavedMovie] {
        let objects = realm.objects(SavedMovieObject.self)
            .where { $0.statusRaw == SavedMovie.Status.watched.rawValue }

        return objects.map { SavedMovieRealmMapper.toDomain($0) }
    }

    func allFavoriteMovies() -> [SavedMovie] {
        let objects = realm.objects(SavedMovieObject.self)
            .where { $0.isFavorite == true }

        return objects.map { SavedMovieRealmMapper.toDomain($0) }
    }
}
