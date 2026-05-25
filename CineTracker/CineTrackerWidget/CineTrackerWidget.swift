//
//  CineTrackerWidget.swift
//  CineTrackerWidget
//
//  Created by MAC VN on 25/5/26.
//

import SwiftUI
import WidgetKit

struct CineTrackerWidget: Widget {
    let kind: String = "CineTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CineTrackerProvider()) { entry in
            CineTrackerWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("CineTracker Watchlist")
        .description("Hiển thị danh sách phim trong watchlist của bạn.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    CineTrackerWidget()
} timeline: {
    CineTrackerEntry(date: .now, data: WidgetData.placeholder)
    CineTrackerEntry(date: .now, data: WidgetData.empty)
}

#Preview(as: .systemMedium) {
    CineTrackerWidget()
} timeline: {
    CineTrackerEntry(date: .now, data: WidgetData.placeholder)
}

#Preview(as: .systemLarge) {
    CineTrackerWidget()
} timeline: {
    CineTrackerEntry(date: .now, data: WidgetData.placeholder)
}
