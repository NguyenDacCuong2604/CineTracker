//
//  RecentSearchesRepository.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Combine
import Foundation

protocol RecentSearchesRepository {
    var recentSearchesPublisher: AnyPublisher<[String], Never> { get }
    func all() -> [String]
    func add(_ query: String)
    func remove(_ query: String)
    func clear()
}
