//
//  APIClientImpl.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation
import OSLog

final class APIClientImpl: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL: URL
    private let apiKey: String
    private let interceptor: RequestInterceptor

    init(
        session: URLSession = .shared,
        baseURL: URL = Configuration.tmdbBaseURL,
        apiKey: String? = nil,
        interceptor: RequestInterceptor = RequestInterceptor()
    ) {
        self.session = session
        self.baseURL = baseURL
        self.interceptor = interceptor

        if let key = apiKey {
            self.apiKey = key
        } else {
            self.apiKey = (try? KeychainManager.shared.read(.tmdbAPIKey)) ?? ""
        }

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await performRequest(endpoint, retryCount: 0)
    }

    private func performRequest<T: Decodable>(
        _ endpoint: Endpoint,
        retryCount: Int
    ) async throws -> T {
        let url: URL
        do {
            url = try endpoint.url(baseURL: baseURL, apiKey: apiKey)
        } catch {
            AppLogger.network.error("Invalid URL for endpoint: \(endpoint.path)")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30

        interceptor.adapt(&request)

        AppLogger.network.info("→ \(endpoint.method.rawValue) \(endpoint.path)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            let apiError = mapURLError(error)

            if apiError.isRetriable, retryCount < interceptor.maxRetries {
                let delay = interceptor.retryDelay(for: retryCount)
                AppLogger.network.notice("Retrying after \(delay)s (attempt \(retryCount + 1))")
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                return try await performRequest(endpoint, retryCount: retryCount + 1)
            }

            throw apiError
        } catch {
            throw APIError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        AppLogger.network.info("← \(httpResponse.statusCode) \(endpoint.path)")

        try validateStatusCode(httpResponse.statusCode, data: data)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            AppLogger.network.error("Decoding failed: \(error)")
            if Configuration.isVerboseLoggingEnabled {
                let body = String(data: data, encoding: .utf8) ?? "non-utf8"
                AppLogger.network.debug("Response body: \(body.prefix(500))")
            }
            throw APIError.decodingFailed(error)
        }
    }

    private func mapURLError(_ error: URLError) -> APIError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .unknown(error)
        }
    }

    private func validateStatusCode(_ code: Int, data: Data) throws {
        switch code {
        case 200 ... 299:
            return
        case 400:
            let message = extractErrorMessage(from: data)
            throw APIError.badRequest(message: message)
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 500 ... 599:
            throw APIError.serverError(statusCode: code)
        default:
            let message = extractErrorMessage(from: data)
            throw APIError.httpError(statusCode: code, message: message)
        }
    }

    private func extractErrorMessage(from data: Data) -> String? {
        struct TMDBError: Decodable {
            let statusMessage: String?
        }
        if let error = try? JSONDecoder().decode(TMDBError.self, from: data) {
            return error.statusMessage
        }
        return nil
    }
}
