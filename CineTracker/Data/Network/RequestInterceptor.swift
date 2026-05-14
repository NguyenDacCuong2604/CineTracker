//
//  RequestInterceptor.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

struct RequestInterceptor {
    let maxRetries: Int
    let baseRetryDelay: TimeInterval

    init(maxRetries: Int = 3, baseRetryDelay: TimeInterval = 1.0) {
        self.maxRetries = maxRetries
        self.baseRetryDelay = baseRetryDelay
    }

    func adapt(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    func retryDelay(for attempt: Int) -> TimeInterval {
        baseRetryDelay * pow(2.0, Double(attempt))
    }
}
