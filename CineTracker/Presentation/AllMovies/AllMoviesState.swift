//
//  AllMoviesState.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct AllMoviesState {
    var movies: [Movie] = []
    var loadingState: LoadingState = .idle
    var currentPage: Int = 0
    var hasMorePages: Bool = true
    var isLoadingMore: Bool = false

    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(String)
    }
}
