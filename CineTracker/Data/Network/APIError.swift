//
//  APIError.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

enum APIError: Error {
    case noInternet
    case timeout
    case cancelled
    case badRequest(message: String?)
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case httpError(statusCode: Int, message: String?)
    case decodingFailed(Error)
    case invalidURL
    case invalidResponse
    case unknown(Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return L10n.APIError.noInternet
        case .timeout:
            return L10n.APIError.timeout
        case .cancelled:
            return L10n.APIError.cancelled
        case let .badRequest(message):
            return message ?? L10n.APIError.badRequest
        case .unauthorized:
            return L10n.APIError.unauthorized
        case .forbidden:
            return L10n.APIError.forbidden
        case .notFound:
            return L10n.APIError.notFound
        case let .serverError(code):
            return L10n.APIError.serverError(code)
        case let .httpError(code, message):
            return message ?? L10n.APIError.httpError(code)
        case let .decodingFailed(error):
            return L10n.APIError.decodingFailed(error.localizedDescription)
        case .invalidURL:
            return L10n.APIError.invalidURL
        case .invalidResponse:
            return L10n.APIError.invalidResponse
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}

extension APIError {
    var isRetriable: Bool {
        switch self {
        case .timeout, .serverError, .noInternet:
            return true
        default:
            return false
        }
    }

    var isUserFacing: Bool {
        switch self {
        case .cancelled:
            return false
        default:
            return true
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternet, .noInternet),
             (.timeout, .timeout),
             (.cancelled, .cancelled),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.serverError(l), .serverError(r)):
            return l == r
        case let (.badRequest(l), .badRequest(r)):
            return l == r
        case let (.httpError(lc, lm), .httpError(rc, rm)):
            return lc == rc && lm == rm
        case (.decodingFailed, .decodingFailed),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
