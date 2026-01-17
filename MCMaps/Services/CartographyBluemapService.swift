//
//  CartographyBluemapService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import CubiomesKit
import Foundation
import MCMap

/// A service that pulls information from a Bluemap server.
actor CartographyBluemapService {
    /// An enumeration of all available endpoints for the service to pull from.
    enum Endpoint: String, Sendable {
        /// Retrieves all live markers from a given world.
        case markers = "/live/markers.json"

        /// Retrieves all live players from a given world.
        case players = "/live/players.json"
    }

    /// The configuration model used to configure the service.
    var configuration: MCMapBluemapIntegration

    private var session: any NetworkServiceable

    /// Create a service with a given configuration and session.
    /// - Parameter configuration: The configuration model used to configure the service.
    /// - Parameter session: The networking session used to make network requests.
    init(
        withConfiguration configuration: MCMapBluemapIntegration,
        session: any NetworkServiceable = URLSession(configuration: .default)
    ) {
        self.configuration = configuration
        self.session = session
    }

    /// Fetches data from a specified endpoint and decodes it into the specified type.
    /// - Parameter endpoint: The endpoint to fetch data from.
    /// - Parameter dimension: The dimension from which to pull the data.
    func fetch<T: Codable & Sendable>(
        endpoint: Endpoint,
        for dimension: MinecraftWorld.Dimension
    ) async throws(NetworkServicableError) -> T {
        var urlToConstruct = "https://\(configuration.baseURL)/maps/"
        switch dimension {
        case .overworld:
            urlToConstruct.append(configuration.mapping.overworld)
        case .nether:
            urlToConstruct.append(configuration.mapping.nether)
        case .end:
            urlToConstruct.append(configuration.mapping.end)
        }
        urlToConstruct.append(endpoint.rawValue)

        // NOTE(alicerunsonfedora): Bad! Bad!
        let url = URL(string: urlToConstruct)!
        return try await session.get(url: url)
    }
}
