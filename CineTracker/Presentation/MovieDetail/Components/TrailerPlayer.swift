//
//  TrailerPlayer.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerPlayer: View {
    let videoID: String

    var body: some View {
        YouTubePlayerView(YouTubePlayer(source: .video(id: videoID)))
    }
}
