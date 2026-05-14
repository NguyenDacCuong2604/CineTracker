//
//  MemoryCache.swift
//  CineTracker
//
//  Created by MAC VN on 13/5/26.
//

import Foundation

final class MemoryCache<Value> {
    private let cache = NSCache<NSString, Entry>()

    private final class Entry {
        let value: Value
        let expiresAt: Date

        init(value: Value, expiresAt: Date) {
            self.value = value
            self.expiresAt = expiresAt
        }

        var isExpired: Bool {
            Date() > expiresAt
        }
    }

    var defaultTTL: TimeInterval = 5 * 60

    init(countLimit: Int = 100) {
        cache.countLimit = countLimit
    }

    func set(_ value: Value, for key: String, ttl: TimeInterval? = nil) {
        let expiresAt = Date().addingTimeInterval(ttl ?? defaultTTL)
        let entry = Entry(value: value, expiresAt: expiresAt)
        cache.setObject(entry, forKey: key as NSString)
    }

    func get(_ key: String) -> Value? {
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil
        }
        if entry.isExpired {
            cache.removeObject(forKey: key as NSString)
            return nil
        }
        return entry.value
    }

    func remove(_ key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }
}
