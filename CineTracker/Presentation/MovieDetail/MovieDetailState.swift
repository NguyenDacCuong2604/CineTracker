//
//  MovieDetailState.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct MovieDetailState {
    var detail: SectionState<MovieDetail> = .idle
    var cast: SectionState<Cast> = .idle
    var videos: SectionState<Video> = .idle
    var similar: SectionState<Movie> = .idle

    var isInWatchlist: Bool = false
    var isRefreshing: Bool = false
    var savedMovie: SavedMovie? = nil
}
