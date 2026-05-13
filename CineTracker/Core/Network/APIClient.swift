//
//  APIClient.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
