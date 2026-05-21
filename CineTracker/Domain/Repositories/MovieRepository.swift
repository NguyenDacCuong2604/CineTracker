//
//  MovieRepository.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

protocol MovieRepository {
    func popularMovies(page: Int, forceRefresh: Bool) async throws -> [Movie]
    func topRatedMovies(page: Int, forceRefresh: Bool) async throws -> [Movie]
    func upcomingMovies(page: Int, forceRefresh: Bool) async throws -> [Movie]
    func nowPlayingMovies(page: Int, forceRefresh: Bool) async throws -> [Movie]
    func movieDetail(id: Int, forceRefresh: Bool) async throws -> MovieDetail
    func movieCast(id: Int) async throws -> [Cast]
    func similarMovies(id: Int, page: Int) async throws -> [Movie]
    func searchMovies(query: String, page: Int) async throws -> [Movie]
    func movieVideos(id: Int) async throws -> [Video]
    func personDetail(id: Int) async throws -> Person
    func personMovieCredits(id: Int) async throws -> (cast: [PersonMovieCredit], crew: [PersonMovieCredit])
}
