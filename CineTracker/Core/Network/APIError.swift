//
//  APIError.swift
//  CineTracker
//
//  Created by MAC VN on 12/5/26.
//

import Foundation

enum APIError: Error {
    case noInternet
    case timeout
    case cancelled
    case badRequest(message: String?)
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case httpError(statusCode: Int, message: String?)
    case decodingFailed(Error)
    case invalidURL
    case invalidResponse
    case unknown(Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Không có kết nối internet. Vui long kiểm tra mạng."
        case .timeout:
            return "Kết nối quá lâu. Vui lòng thử lại."
        case .cancelled:
            return "Yêu cầu đã bị huỷ."
        case .badRequest(let message):
            return message ?? "Yêu cầu không hợp lệ."
        case .unauthorized:
            return "API key không hợp lệ hoặc đã hết hạn."
        case .forbidden:
            return "Bạn không có quyền truy cập tài nguyên này."
        case .notFound:
            return "Không tìm thấy nội dung."
        case .serverError(let code):
            return "Lỗi máy chủ (\(code)). Vui lòng thử lại sau."
        case .httpError(let code, let message):
            return message ?? "Lỗi HTTP \(code)"
        case .decodingFailed(let error):
            return "Không xử lý được dữ liệu: \(error.localizedDescription)"
        case .invalidURL:
            return "URL không hợp lệ."
        case.invalidResponse:
            return "Phản hồi không hợp lệ."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

extension APIError {
    var isRetriable: Bool {
        switch self {
        case .timeout, .serverError, .noInternet:
            return true
        default:
            return false
        }
    }
    
    var isUserFacing: Bool {
        switch self {
        case .cancelled:
            return false
        default:
            return true
        }
    }
}
