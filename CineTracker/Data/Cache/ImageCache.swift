//
//  ImageCache.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation
import OSLog

final class ImageCache {
    static let share = ImageCache()
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let diskDirectory: URL?
    private let session: URLSession

    private init() {
        memoryCache.countLimit = 200
        memoryCache.totalCostLimit = 100_000_000

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        session = URLSession(configuration: config)

        diskDirectory = Self.setupDiskDirectory(fileManager: fileManager)

        if diskDirectory == nil {
            AppLogger.cache.warning("⚠️ Image disk cache disabled - using memory only")
        }
    }

    private static func setupDiskDirectory(fileManager: FileManager) -> URL? {
        do {
            let caches = try fileManager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let directory = caches.appendingPathComponent("images", isDirectory: true)

            if !fileManager.fileExists(atPath: directory.path) {
                try fileManager.createDirectory(
                    at: directory,
                    withIntermediateDirectories: true
                )
            }

            return directory
        } catch {
            AppLogger.cache.error("Failed to setup image disk cache: \(error)")
            return nil
        }
    }

    func imageData(for url: URL) async throws -> Data {
        let key = url.absoluteString as NSString

        // Memory
        if let cached = memoryCache.object(forKey: key) {
            AppLogger.cache.debug("Image hit (memory): \(url.lastPathComponent)")
            return cached as Data
        }

        // Disk
        if let fileURL = diskFileURL(for: url),
           fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL)
        {
            AppLogger.cache.debug("Image hit (disk): \(url.lastPathComponent)")
            memoryCache.setObject(data as NSData, forKey: key, cost: data.count)
            return data
        }

        // Network
        AppLogger.cache.debug("Image miss, fetching: \(url.lastPathComponent)")
        let (data, _) = try await session.data(from: url)

        guard isValidImageData(data) else {
            throw APIError.decodingFailed(
                NSError(
                    domain: "ImageCache",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]
                )
            )
        }

        memoryCache.setObject(data as NSData, forKey: key, cost: data.count)
        if let fileURL = diskFileURL(for: url) {
            try? data.write(to: fileURL, options: .atomic)
        }

        return data
    }

    func clear() {
        memoryCache.removeAllObjects()
        if let directory = diskDirectory {
            try? fileManager.removeItem(at: directory)
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        AppLogger.cache.info("Image cache cleared")
    }

    private func diskFileURL(for url: URL) -> URL? {
        guard let directory = diskDirectory else { return nil }
        let safeName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "image"
        return directory.appendingPathComponent(safeName)
    }

    private func isValidImageData(_ data: Data) -> Bool {
        guard data.count >= 4 else { return false }
        let bytes = [UInt8](data.prefix(4))

        // PNG
        if bytes[0] == 0x89, bytes[1] == 0x50, bytes[2] == 0x4E, bytes[3] == 0x47 {
            return true
        }
        // JPEG
        if bytes[0] == 0xFF, bytes[1] == 0xD8, bytes[2] == 0xFF {
            return true
        }
        // GIF
        if bytes[0] == 0x47, bytes[1] == 0x49, bytes[2] == 0x46 {
            return true
        }
        // WebP starts with "RIFF"
        if bytes[0] == 0x52, bytes[1] == 0x49, bytes[2] == 0x46, bytes[3] == 0x46 {
            return true
        }
        return false
    }
}
