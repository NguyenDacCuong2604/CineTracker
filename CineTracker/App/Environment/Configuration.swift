//
//  Configuration.swift
//  CineTracker
//
//  Created by MAC VN on 11/5/26.
//
import Foundation

enum Configuration {
    /// Error
    enum ConfigError: Error, LocalizedError {
        case missingKey(String)
        case invalidValue(String)

        var errorDescription: String? {
            switch self {
            case let .missingKey(key):
                return "Missing required configuration key: \(key)"
            case let .invalidValue(key):
                return "Invalid value for configuration key: \(key)"
            }
        }
    }

    /// TMDB API key v3
    static var tmdbAPIKey: String {
        do {
            return try value(for: "TMDB_API_KEY")
        } catch {
            fatalError("TMDB_API_KEY missing. Check Secrets.xcconfig")
        }
    }

    /// TMDB base URL
    static var tmdbBaseURL: URL {
        do {
            let urlString: String = try value(for: "TMDB_BASE_URL")
            guard let url = URL(string: urlString) else {
                throw ConfigError.invalidValue("TMDB_BASE_URL")
            }
            return url
        } catch {
            fatalError("TMDB_BASE_URL invalid: \(error)")
        }
    }

    /// TMDB image base URL
    static var tmdbImageBaseURL: URL {
        do {
            let urlString: String = try value(for: "TMDB_IMAGE_BASE_URL")
            guard let url = URL(string: urlString) else {
                throw ConfigError.invalidValue("TMDB_IMAGE_BASE_URL")
            }
            return url
        } catch {
            fatalError("TMDB_IMAGE_BASE_URL invalid: \(error)")
        }
    }

    /// is On verbose logging
    static var isVerboseLoggingEnabled: Bool {
        (try? value(for: "ENABLE_VERBOSE_LOGGING")) ?? false
    }

    /// function read value
    private static func value<T>(for key: String) throws -> T {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw ConfigError.missingKey(key)
        }

        if T.self == Bool.self {
            let boolValue = (object as? Bool)
                ?? ((object as? String).map { $0 == "YES" || $0 == "true" })

            if let result = boolValue as? T {
                return result
            }
        }

        guard let result = object as? T else {
            throw ConfigError.invalidValue(key)
        }

        return result
    }
}
