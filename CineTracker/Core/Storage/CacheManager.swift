//
//  CacheManager.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//
import Foundation
import OSLog

final class CacheManager {
    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private init() {}

    private var cachesURL: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    private var imagesCacheURL: URL? {
        cachesURL?.appendingPathComponent("images")
    }

    private var dataCacheURL: URL? {
        cachesURL?.appendingPathComponent("movies")
    }

    func totalCacheSize() async -> Int64 {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                var total: Int64 = 0

                if let imageSize = self.directorySize(at: self.imagesCacheURL) {
                    total += imageSize
                }
                if let dataSize = self.directorySize(at: self.dataCacheURL) {
                    total += dataSize
                }

                continuation.resume(returning: total)
            }
        }
    }

    func imageCacheSize() async -> Int64 {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let size = self.directorySize(at: self.imagesCacheURL) ?? 0
                continuation.resume(returning: size)
            }
        }
    }

    func dataCacheSize() async -> Int64 {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let size = self.directorySize(at: self.dataCacheURL) ?? 0
                continuation.resume(returning: size)
            }
        }
    }

    func clearAll() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                self.clearDirectory(at: self.imagesCacheURL)
                self.clearDirectory(at: self.dataCacheURL)
                continuation.resume()
            }
        }
    }

    func clearImages() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                self.clearDirectory(at: self.imagesCacheURL)
                continuation.resume()
            }
        }
    }

    func clearData() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                self.clearDirectory(at: self.dataCacheURL)
                continuation.resume()
            }
        }
    }

    private func directorySize(at url: URL?) -> Int64? {
        guard let url = url, fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        var total: Int64 = 0
        guard let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey]
        ) else {
            return 0
        }

        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey]),
                  resourceValues.isDirectory == false,
                  let size = resourceValues.fileSize
            else {
                continue
            }
            total += Int64(size)
        }

        return total
    }

    private func clearDirectory(at url: URL?) {
        guard let url = url, fileManager.fileExists(atPath: url.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: url)
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        } catch {
            AppLogger.app.error("Failed to clear cache at \(url): \(error.localizedDescription)")
        }
    }
}
