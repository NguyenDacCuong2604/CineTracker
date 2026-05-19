//
//  MovieDetailViewModel.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MovieDetailViewModel {
     let movieID: Int
     private(set) var state = MovieDetailState()
     
     private let fetchDetail: FetchMovieDetailUseCase
     private let fetchCast: FetchMovieCastUseCase
     private let fetchVideos: FetchMovieVideosUseCase
     private let fetchSimilar: FetchSimilarMoviesUseCase
     private let isInWatchlist: IsInWatchlistUseCase
     private let addToWatchlist: AddToWatchlistUseCase
     private let removeFromWatchlist: RemoveFromWatchlistUseCase
     
     private var loadTask: Task<Void, Never>?
     
     init(
         movieID: Int,
         fetchDetail: FetchMovieDetailUseCase,
         fetchCast: FetchMovieCastUseCase,
         fetchVideos: FetchMovieVideosUseCase,
         fetchSimilar: FetchSimilarMoviesUseCase,
         isInWatchlist: IsInWatchlistUseCase,
         addToWatchlist: AddToWatchlistUseCase,
         removeFromWatchlist: RemoveFromWatchlistUseCase
     ) {
         self.movieID = movieID
         self.fetchDetail = fetchDetail
         self.fetchCast = fetchCast
         self.fetchVideos = fetchVideos
         self.fetchSimilar = fetchSimilar
         self.isInWatchlist = isInWatchlist
         self.addToWatchlist = addToWatchlist
         self.removeFromWatchlist = removeFromWatchlist
     }
     
     func load() async {
         loadTask?.cancel()
         
         loadTask = Task { [weak self] in
             guard let self else { return }
             await self.loadAll(forceRefresh: false, isInitialLoad: true)
             
             guard !Task.isCancelled else { return }
             self.refreshWatchlistStatus()
         }
         
         await loadTask?.value
     }
     
     func refresh() async {
         loadTask?.cancel()
         
         state.isRefreshing = true
         
         loadTask = Task { [weak self] in
             guard let self else { return }
             await self.loadAll(forceRefresh: true, isInitialLoad: false)
             
             guard !Task.isCancelled else {
                 self.state.isRefreshing = false
                 return
             }
             
             self.refreshWatchlistStatus()
             self.state.isRefreshing = false
         }
         
         await loadTask?.value
     }
     
     func toggleWatchlist() async {
         guard case .loaded(let details) = state.detail,
               let detail = details.first else { return }
         
         let wasInWatchlist = state.isInWatchlist
         state.isInWatchlist.toggle()
         
         do {
             if wasInWatchlist {
                 try await removeFromWatchlist.execute(movieID)
                 AppLogger.app.info("Removed from watchlist: \(detail.title)")
             } else {
                 let movie = Movie(
                     id: detail.id,
                     title: detail.title,
                     overview: detail.overview,
                     posterURL: detail.posterURL,
                     backdropURL: detail.backdropURL,
                     releaseDate: detail.releaseDate,
                     rating: detail.rating,
                     voteCount: detail.voteCount,
                     genreIDs: detail.genres.map { $0.id }
                 )
                 try await addToWatchlist.execute(movie)
                 AppLogger.app.info("Added to watchlist: \(detail.title)")
             }
         } catch {
             state.isInWatchlist = wasInWatchlist
             AppLogger.app.error("Toggle watchlist failed: \(error.localizedDescription)")
         }
     }
     
     private func loadAll(forceRefresh: Bool, isInitialLoad: Bool) async {
         async let detail: Void = loadDetail(forceRefresh: forceRefresh, isInitialLoad: isInitialLoad)
         async let cast: Void = loadCast(isInitialLoad: isInitialLoad)
         async let videos: Void = loadVideos(isInitialLoad: isInitialLoad)
         async let similar: Void = loadSimilar(isInitialLoad: isInitialLoad)
         
         _ = await [detail, cast, videos, similar]
     }
     
     private func loadDetail(forceRefresh: Bool, isInitialLoad: Bool) async {
         if isInitialLoad {
             state.detail = .loading
         }
         
         do {
             let detail = try await fetchDetail.execute(.init(id: movieID, forceRefresh: forceRefresh))
             state.detail = .loaded([detail])
         } catch is CancellationError {
             return
         } catch let apiError as APIError where apiError == .cancelled {
             return
         } catch {
             AppLogger.app.error("Fetch detail failed: \(error.localizedDescription)")
             if isInitialLoad {
                 state.detail = .error(error)
             }
         }
     }
     
     private func loadCast(isInitialLoad: Bool) async {
         if isInitialLoad {
             state.cast = .loading
         }
         
         do {
             let cast = try await fetchCast.execute(movieID)
             state.cast = .loaded(cast)
         } catch is CancellationError {
             return
         } catch let apiError as APIError where apiError == .cancelled {
             return
         } catch {
             AppLogger.app.error("Fetch cast failed: \(error.localizedDescription)")
             if isInitialLoad {
                 state.cast = .error(error)
             }
         }
     }
     
     private func loadVideos(isInitialLoad: Bool) async {
         if isInitialLoad {
             state.videos = .loading
         }
         
         do {
             let videos = try await fetchVideos.execute(movieID)
             state.videos = .loaded(videos)
         } catch is CancellationError {
             return
         } catch let apiError as APIError where apiError == .cancelled {
             return
         } catch {
             AppLogger.app.error("Fetch videos failed: \(error.localizedDescription)")
             if isInitialLoad {
                 state.videos = .error(error)
             }
         }
     }
     
     private func loadSimilar(isInitialLoad: Bool) async {
         if isInitialLoad {
             state.similar = .loading
         }
         
         do {
             let movies = try await fetchSimilar.execute(.init(movieID: movieID))
             state.similar = .loaded(movies)
         } catch is CancellationError {
             return
         } catch let apiError as APIError where apiError == .cancelled {
             return
         } catch {
             AppLogger.app.error("Fetch similar failed: \(error.localizedDescription)")
             if isInitialLoad {
                 state.similar = .error(error)
             }
         }
     }
     
     private func refreshWatchlistStatus() {
         state.isInWatchlist = isInWatchlist.execute(movieID)
     }
}
