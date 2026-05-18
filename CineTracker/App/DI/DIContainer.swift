//
//  DIContainer.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    lazy var apiClient: APIClient = APIClientImpl()
    lazy var movieRepository: MovieRepository = MovieRepositoryImpl(apiClient: apiClient)
    lazy var recentSearchesRepository: RecentSearchesRepository = RecentSearchesRepositoryImpl()
    lazy var watchlistRepository: WatchlistRepository = {
        do {
            return try WatchlistRepositoryImpl()
        } catch {
            fatalError("Cannot init WatchlistRepository: \(error)")
        }
    }()

    var fetchTrendingMoviesUseCase: FetchTrendingMoviesUseCase {
        FetchTrendingMoviesUseCase(repository: movieRepository)
    }

    var fetchPopularMoviesUseCase: FetchPopularMovieUseCase {
        FetchPopularMovieUseCase(repository: movieRepository)
    }

    var fetchTopRatedMoviesUseCase: FetchTopRatedMoviesUseCase {
        FetchTopRatedMoviesUseCase(repository: movieRepository)
    }

    var fetchUpcomingMoviesUseCase: FetchUpcomingMoviesUseCase {
        FetchUpcomingMoviesUseCase(repository: movieRepository)
    }

    var fetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCase {
        FetchNowPlayingMoviesUseCase(repository: movieRepository)
    }

    var searchMovieUseCase: SearchMoviesUseCase {
        SearchMoviesUseCase(repository: movieRepository)
    }

    var addToWatchlistUseCase: AddToWatchlistUseCase {
        AddToWatchlistUseCase(repository: watchlistRepository)
    }

    var removeFromWatchlistUseCase: RemoveFromWatchlistUseCase {
        RemoveFromWatchlistUseCase(repository: watchlistRepository)
    }

    var markAsWatchedUseCase: MarkAsWatchedUseCase {
        MarkAsWatchedUseCase(repository: watchlistRepository)
    }

    var getWatchlistUseCase: GetWatchlistUseCase {
        GetWatchlistUseCase(repository: watchlistRepository)
    }

    var getRecentSearchesUseCase: GetRecentSearchesUseCase {
        GetRecentSearchesUseCase(repository: recentSearchesRepository)
    }

    var saveRecentSearchUseCase: SaveRecentSearchUseCase {
        SaveRecentSearchUseCase(repository: recentSearchesRepository)
    }

    var removeRecentSearchUseCase: RemoveRecentSearchUseCase {
        RemoveRecentSearchUseCase(repository: recentSearchesRepository)
    }

    var clearRecentSearchesUseCase: ClearRecentSearchesUseCase {
        ClearRecentSearchesUseCase(repository: recentSearchesRepository)
    }

    private init() {}
}
