//
//  Video.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

struct Video: Identifiable, Hashable {
    let id: String
    let key: String
    let name: String
    let site: Site
    let type: VideoType
    let isOfficial: Bool

    enum Site: String {
        case youtube = "YouTube"
        case vimeo = "Vimeo"
        case unknown = "Unknown"

        static func from(_ value: String) -> Site {
            switch value {
            case "YouTube": return .youtube
            case "Vimeo": return .vimeo
            default: return .unknown
            }
        }
    }

    enum VideoType: String {
        case trailer = "Trailer"
        case teaser = "Teaser"
        case clip = "Clip"
        case featurette = "Featurette"
        case behindTheScenes = "Behind the Scenes"
        case bloopers = "Bloopers"
        case other = "Other"

        static func from(_ value: String) -> VideoType {
            switch value {
            case "Trailer": return .trailer
            case "Teaser": return .teaser
            case "Clip": return .clip
            case "Featurette": return .featurette
            case "Behind the Scenes": return .behindTheScenes
            case "Bloopers": return .bloopers
            default: return .other
            }
        }
    }

    var youtubeEmbedURL: URL? {
        guard site == .youtube else { return nil }
        return URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1")
    }

    var youtubeThumbnaiURL: URL? {
        guard site == .youtube else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }

    var youtubeAppURL: URL? {
        guard site == .youtube else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
