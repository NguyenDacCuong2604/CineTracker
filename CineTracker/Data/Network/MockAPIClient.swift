//
//  MockAPIClient.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

#if DEBUG

    final class MockAPIClient: APIClient {
        var nextResult: Any?
        var nextError: APIError?
        var artificialDelay: TimeInterval = 0
        private(set) var calledEndpoints: [Endpoint] = []

        init() {}

        func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
            calledEndpoints.append(endpoint)

            if artificialDelay > 0 {
                try await Task.sleep(nanoseconds: UInt64(artificialDelay * 1_000_000_000))
            }

            if let error = nextError {
                throw error
            }

            guard let result = nextResult as? T else {
                throw APIError.unknown(NSError(
                    domain: "MockAPIClient",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No mock result configured"]
                ))
            }

            return result
        }

        func reset() {
            nextResult = nil
            nextError = nil
            calledEndpoints.removeAll()
            artificialDelay = 0
        }
    }

    extension MockAPIClient {
        static var preview: MockAPIClient {
            let mock = MockAPIClient()
            mock.nextResult = PagedResponse(
                page: 1,
                results: [
                    MovieDTO(
                        id: 1,
                        title: "Inception",
                        overview: "A mind-bending thriller",
                        posterPath: "/poster1.jpg",
                        backdropPath: "/backdrop1.jpg",
                        releaseDate: "2010-07-16",
                        voteAverage: 8.4,
                        voteCount: 30000,
                        popularity: 100.0,
                        originalLanguage: "en",
                        genreIds: [28, 878]
                    ),
                    MovieDTO(
                        id: 2,
                        title: "The Dark Knight",
                        overview: "Batman vs Joker",
                        posterPath: "/poster2.jpg",
                        backdropPath: "/backdrop2.jpg",
                        releaseDate: "2008-07-18",
                        voteAverage: 9.0,
                        voteCount: 28000,
                        popularity: 95.0,
                        originalLanguage: "en",
                        genreIds: [28, 80]
                    ),
                ],
                totalPages: 100,
                totalResults: 2000
            )
            return mock
        }
    }

#endif
