//
//  CartographyBluemapServiceTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import Foundation
import MCMapFormat
import Testing

@testable import Alidade

struct CartographyBluemapServiceTests {
    @Test func getPlayers() async throws {
        let session = MockNetworkServicable()
        let integration = MCMapBluemapIntegration(baseURL: "bluemap.augenwaldburg.tld")
        let service = CartographyBluemapService(withConfiguration: integration, session: session)


        await #expect(throws: Never.self) {
            let resp: BluemapPlayerResponse? = try await service.fetch(endpoint: .players, for: .overworld)
            #expect(resp?.players.count == 1)
            #expect(resp?.players.first?.name == "paulstraw")
        }

        #expect(await !session.urlsVisited.isEmpty)
        #expect(
            await session.urlsVisited.first == URL(
                string: "https://bluemap.augenwaldburg.tld/maps/world/live/players.json"
            )
        )
    }

    @Test func getMarkers() async throws {
        let session = MockNetworkServicable()
        let integration = MCMapBluemapIntegration(baseURL: "bluemap.augenwaldburg.tld")
        let service = CartographyBluemapService(withConfiguration: integration, session: session)


        await #expect(throws: Never.self) {
            let resp: [String: BluemapMarkerAnnotationGroup]? = try await service.fetch(
                endpoint: .markers,
                for: .overworld
            )
            #expect(resp?.isEmpty == false)
            #expect(resp?["sample"]?.label == "Sample Set")
            #expect(resp?["sample"]?.markers.isEmpty == false)
        }

        #expect(await !session.urlsVisited.isEmpty)
        #expect(
            await session.urlsVisited.first == URL(
                string: "https://bluemap.augenwaldburg.tld/maps/world/live/markers.json"
            )
        )
    }
}
