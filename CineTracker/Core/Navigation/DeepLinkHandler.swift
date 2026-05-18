//
//  DeepLinkHandler.swift
//  CineTracker
//
//  Created by MAC VN on 18/5/26.
//

import Foundation
import OSLog

enum DeepLinkHandler {
    private enum Scheme {
        static let app = "cinetracker"
        static let universalHost = "cinetracker.app"
    }

    static func parse(_ url: URL) -> DeepLinkResult? {
        let path = parsePath(from: url)

        guard let path = path else {
            AppLogger.navigation.warning("Invalid deep link: \(url.absoluteString)")
            return nil
        }
        return mapToRoute(path: path)
    }

    private static func parsePath(from url: URL) -> [String]? {
        guard let scheme = url.scheme?.lowercased() else { return nil }
        if scheme == Scheme.app {
            guard let host = url.host else { return nil }
            let pathComponents = url.pathComponents.filter { $0 != "/" }
            return [host] + pathComponents
        } else if scheme == "https" {
            guard url.host?.lowercased() == Scheme.universalHost else { return nil }
            return url.pathComponents.filter { $0 != "/" }
        }

        return nil
    }

    private static func mapToRoute(path: [String]) -> DeepLinkResult? {
        guard path.count >= 2 else { return nil }

        let type = path[0]
        let idString = path[1]

        guard let id = Int(idString) else {
            AppLogger.navigation.warning("Invalid ID in deep link: \(idString)")
            return nil
        }

        switch type.lowercased() {
        case "movie":
            return DeepLinkResult(
                route: .movieDetail(id: id),
                targetTab: .discover
            )
        case "cast":
            return DeepLinkResult(
                route: .castDetail(id: id),
                targetTab: .discover
            )
        default:
            AppLogger.navigation.warning("Unknown deep link type: \(type)")
            return nil
        }
    }
}

struct DeepLinkResult: Equatable {
    let route: Route
    let targetTab: AppTab
}
