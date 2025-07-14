//
//  NetworkServiceable.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import Foundation

/// A protocol that defines a networking service.
protocol NetworkServiceable: Sendable {
    /// Retrieve the contents from a given URL and decode it.
    /// - Parameter url: The URL to get the contents of.
    func get<T: Codable>(url: URL) async throws(NetworkServicableError) -> T
}

enum NetworkServicableError: Error {
    case session(any Error)
    case nonHTTPResponse(URLResponse)
    case invalidResponseStatus(Int)

    var localizedDescription: String {
        switch self {
        case let .session(error):
            error.localizedDescription
        case let .nonHTTPResponse(response):
            "The response that was returned wasn't an HTTP response (\(type(of: response))"
        case let .invalidResponseStatus(code):
            "The response return a non-OK code: \(code)"
        }
    }
}

extension URLSession: NetworkServiceable {
    func get<T: Codable>(url: URL) async throws(NetworkServicableError) -> T {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await data(for: request)
            guard let resp = response as? HTTPURLResponse else {
                throw NetworkServicableError.nonHTTPResponse(response)
            }
            guard (200..<300).contains(resp.statusCode) else {
                throw NetworkServicableError.invalidResponseStatus(resp.statusCode)
            }

            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw .session(error)
        }
    }
}
