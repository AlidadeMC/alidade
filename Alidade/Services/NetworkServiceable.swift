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

/// An enumeration of the errors that can be thrown by a ``NetworkServiceable`` type.
enum NetworkServicableError: Error {
    /// An error occurred with the session that initiated the request.
    /// - Parameter error: The error that was thrown by the original service.
    case session(any Error)

    /// The response that was returned wasn't an HTTP response.
    /// - Parameter response: The URL response that was returned from the session.
    case nonHTTPResponse(URLResponse)

    /// The response returned a non-OK status code.
    /// - Parameter statusCode: The status code that the response returned.
    case invalidResponseStatus(Int)

    var localizedDescription: String {
        switch self {
        case .session(let error):
            error.localizedDescription
        case .nonHTTPResponse(let response):
            "The response that was returned wasn't an HTTP response (\(type(of: response))"
        case .invalidResponseStatus(let code):
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
