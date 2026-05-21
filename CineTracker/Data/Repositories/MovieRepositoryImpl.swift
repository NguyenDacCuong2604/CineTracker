//
//  MovieRepositoryImpl.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation
import OSLog

final class MovieRepositoryImpl: MovieRepository {
    private let apiClient: APIClient
    private let memoryCache: MemoryCache<Data>
    private let diskCache: DiskCache<Data>
    private let cacheTTL: TimeInterval = 30 * 60

    init(
        apiClient: APIClient,
        memoryCache: MemoryCache<Data> = MemoryCache(),
        diskCache: DiskCache<Data>? = nil
    ) {
        self.apiClient = apiClient
        self.memoryCache = memoryCache
        if let providedCache = diskCache {
            self.diskCache = providedCache
        } else {
            do {
                self.diskCache = try DiskCache<Data>(name: "movies")
            } catch {
                AppLogger.cache.error("Failed to init disk cache: \(error)")
                fatalError("Cannot create disk cache: \(error)")
            }
        }
    }

    func popularMovies(page: Int, forceRefresh: Bool) async throws -> [Movie] {
        try await fetchMovieList(
            cacheKey: "popular_\(page)",
            endpoint: .popularMovies(page: page),
            forceRefresh: forceRefresh
        )
    }

    func topRatedMovies(page: Int, forceRefresh: Bool) async throws -> [Movie] {
        try await fetchMovieList(
            cacheKey: "top_rated_\(page)",
            endpoint: .topRatedMovies(page: page),
            forceRefresh: forceRefresh
        )
    }

    func upcomingMovies(page: Int, forceRefresh: Bool) async throws -> [Movie] {
        try await fetchMovieList(
            cacheKey: "upcoming_\(page)",
            endpoint: .upcomingMovies(page: page),
            forceRefresh: forceRefresh
        )
    }

    func nowPlayingMovies(page: Int, forceRefresh: Bool) async throws -> [Movie] {
        try await fetchMovieList(
            cacheKey: "now_playing_\(page)",
            endpoint: .nowPlayingMovies(page: page),
            forceRefresh: forceRefresh
        )
    }

    func movieDetail(id: Int, forceRefresh: Bool = false) async throws -> MovieDetail {
        let cacheKey = "detail_\(id)"
        // Memory
        if !forceRefresh,
           let data = memoryCache.get(cacheKey),
           let dto = try? JSONDecoder().decode(MovieDetailDTO.self, from: data)
        {
            AppLogger.cache.debug("Cache hit (memory): \(cacheKey)")
            return MovieMapper.map(dto)
        }
        // Disk
        if !forceRefresh,
           let data = diskCache.get(cacheKey),
           let dto = try? JSONDecoder().decode(MovieDetailDTO.self, from: data)
        {
            AppLogger.cache.debug("Cache hit (disk): \(cacheKey)")
            memoryCache.set(data, for: cacheKey)
            return MovieMapper.map(dto)
        }
        // Network
        AppLogger.cache.debug("Cache miss: \(cacheKey)")
        let dto: MovieDetailDTO = try await apiClient.request(.movieDetail(id: id))

        if let data = try? JSONEncoder().encode(dto) {
            memoryCache.set(data, for: cacheKey)
            try? diskCache.set(data, for: cacheKey, ttl: cacheTTL)
        }

        return MovieMapper.map(dto)
    }

    func movieCast(id: Int) async throws -> [Cast] {
        let cacheKey = "cast_\(id)"

        if let data = memoryCache.get(cacheKey),
           let response = try? JSONDecoder().decode(CreditsResponse.self, from: data)
        {
            return MovieMapper.map(response.cast)
        }

        let response: CreditsResponse = try await apiClient.request(.movieCredits(id: id))

        if let data = try? JSONEncoder().encode(response) {
            memoryCache.set(data, for: cacheKey)
        }

        return MovieMapper.map(response.cast)
    }

    func similarMovies(id: Int, page: Int) async throws -> [Movie] {
        try await fetchMovieList(
            cacheKey: "similar_\(id)_\(page)",
            endpoint: .similarMovies(id: id, page: page),
            forceRefresh: false
        )
    }

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        let response: PagedResponse<MovieDTO> = try await apiClient.request(
            .searchMovies(query: query, page: page)
        )
        return MovieMapper.map(response.results)
    }

    private func fetchMovieList(cacheKey: String, endpoint: Endpoint, forceRefresh: Bool) async throws -> [Movie] {
        // Memory
        if !forceRefresh,
           let data = memoryCache.get(cacheKey),
           let response = try? JSONDecoder().decode(PagedResponse<MovieDTO>.self, from: data)
        {
            AppLogger.cache.debug("Cache hit (memory): \(cacheKey)")
            return MovieMapper.map(response.results)
        }
        // Disk
        if !forceRefresh,
           let data = diskCache.get(cacheKey),
           let response = try? JSONDecoder().decode(PagedResponse<MovieDTO>.self, from: data)
        {
            AppLogger.cache.debug("Cache hit (disk): \(cacheKey)")
            memoryCache.set(data, for: cacheKey)
            return MovieMapper.map(response.results)
        }
        // Network
        AppLogger.cache.debug("Cache miss: \(cacheKey)")
        let response: PagedResponse<MovieDTO> = try await apiClient.request(endpoint)

        if let data = try? JSONEncoder().encode(response) {
            memoryCache.set(data, for: cacheKey)
            try? diskCache.set(data, for: cacheKey, ttl: cacheTTL)
        }

        return MovieMapper.map(response.results)
    }

    func movieVideos(id: Int) async throws -> [Video] {
        let cacheKey = "videos_\(id)"

        if let data = memoryCache.get(cacheKey),
           let response = try? JSONDecoder().decode(VideosResponse.self, from: data)
        {
            return mapVideos(response.results)
        }

        let response: VideosResponse = try await apiClient.request(.movieVideos(id: id))

        if let data = try? JSONEncoder().encode(response) {
            memoryCache.set(data, for: cacheKey)
        }

        return mapVideos(response.results)
    }

    private func mapVideos(_ dtos: [VideoDTO]) -> [Video] {
        dtos
            .map(VideoMapper.map)
            .filter { $0.site == .youtube }
            .sorted { lhs, rhs in
                if lhs.type == .trailer, rhs.type != .trailer { return true }
                if lhs.type != .trailer, rhs.type == .trailer { return false }
                return lhs.isOfficial && !rhs.isOfficial
            }
    }

    func personDetail(id: Int) async throws -> Person {
        let cacheKey = "person_detail_\(id)"

        if let data = memoryCache.get(cacheKey),
           let dto = try? JSONDecoder().decode(PersonDetailDTO.self, from: data)
        {
            return PersonMapper.map(dto)
        }

        let dto: PersonDetailDTO = try await apiClient.request(.personDetail(id: id))

        if let data = try? JSONEncoder().encode(dto) {
            memoryCache.set(data, for: cacheKey)
        }

        return PersonMapper.map(dto)
    }

    func personMovieCredits(id: Int) async throws -> (cast: [PersonMovieCredit], crew: [PersonMovieCredit]) {
        let cacheKey = "person_credits_\(id)"

        if let data = memoryCache.get(cacheKey),
           let dto = try? JSONDecoder().decode(PersonCreditsDTO.self, from: data)
        {
            return (
                cast: dto.cast.map(PersonMovieCreditMapper.mapCast),
                crew: dto.crew.map(PersonMovieCreditMapper.mapCrew)
            )
        }

        let dto: PersonCreditsDTO = try await apiClient.request(.personMovieCredits(id: id))

        if let data = try? JSONEncoder().encode(dto) {
            memoryCache.set(data, for: cacheKey)
        }

        return (
            cast: dto.cast.map(PersonMovieCreditMapper.mapCast),
            crew: dto.crew.map(PersonMovieCreditMapper.mapCrew)
        )
    }
}
