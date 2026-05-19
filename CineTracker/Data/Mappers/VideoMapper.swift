//
//  VideoMapper.swift
//  CineTracker
//
//  Created by MAC VN on 19/5/26.
//

import Foundation

enum VideoMapper {
    static func map(_ dto: VideoDTO) -> Video {
        Video(
            id: dto.id,
            key: dto.key,
            name: dto.name,
            site: Video.Site.from(dto.site),
            type: Video.VideoType.from(dto.type),
            isOfficial: dto.official
        )
    }
}
