//
//  CartographyBluemapService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import CubiomesKit
import Foundation
import MCMapFormat

actor CartographyBluemapService {
    enum Endpoint: String, Sendable {
        case markers = "/live/markers.json"
        case players = "/live/players.json"
    }

    var configuration: MCMapBluemapIntegration

    private var session: any NetworkServiceable

    init(
        withConfiguration configuration: MCMapBluemapIntegration,
        session: any NetworkServiceable = URLSession(configuration: .default)
    ) {
        self.configuration = configuration
        self.session = session
    }

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
