//
//  DiskCache.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

final class DiskCache<Value: Codable> {
    private let fileManager = FileManager.default
    private let directory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(name: String) throws {
        let caches = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        directory = caches.appendingPathComponent(name, isDirectory: true)

        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
        }
    }

    private struct Entry: Codable {
        let value: Value
        let expiresAt: Date

        var isExpired: Bool {
            Date() > expiresAt
        }
    }

    func set(_ value: Value, for key: String, ttl: TimeInterval) throws {
        let entry = Entry(
            value: value,
            expiresAt: Date().addingTimeInterval(ttl)
        )
        let data = try encoder.encode(entry)
        let url = fileURL(for: key)
        try data.write(to: url, options: .atomic)
    }

    func get(_ key: String) -> Value? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let entry = try? decoder.decode(Entry.self, from: data)
        else {
            return nil
        }

        if entry.isExpired {
            try? fileManager.removeItem(at: url)
            return nil
        }
        return entry.value
    }

    func remove(_ key: String) {
        try? fileManager.removeItem(at: fileURL(for: key))
    }

    func clear() throws {
        try fileManager.removeItem(at: directory)
        try fileManager.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
    }

    private func fileURL(for key: String) -> URL {
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return directory.appendingPathComponent(safeKey)
    }
}
