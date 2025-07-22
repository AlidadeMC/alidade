//
//  CartographyRouteTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import MCMap
import Testing

@testable import Alidade

struct CartographyRouteTests {
    @Test func routeIdentifiableConformance() async throws {
        let route = CartographyRoute.editWorld
        #expect(!route.id.uuidString.isEmpty)
    }
    @Test func requiresModalDisplay() async throws {
        let routes = [
            CartographyRoute.editWorld,
            CartographyRoute.createPin(.zero),
            
            CartographyRoute.pin(0, pin: CartographyMapPin(named: "Spawn", at: .zero)),
            CartographyRoute.recent(.init(x: 1, y: 1)),
        ]
        #if os(iOS)
            for route in routes {
                #expect(route.requiresModalDisplay == false)
            }
        #else
            for (route, expectation) in zip(routes, [true, true, false, false]) {
                #expect(route.requiresModalDisplay == expectation)
            }
        #endif
    }

    @Test func requiresInspectorDisplay() async throws {
        let routes = [
            CartographyRoute.editWorld,
            CartographyRoute.createPin(.zero),
            CartographyRoute.pin(0, pin: CartographyMapPin(named: "Spawn", at: .zero)),
            CartographyRoute.recent(.init(x: 1, y: 1)),
        ]
        #if os(iOS)
            for route in routes {
                #expect(route.requiresInspectorDisplay == false)
            }
        #else
            for (route, expectation) in zip(routes, [false, false, true, false]) {
                #expect(route.requiresInspectorDisplay == expectation)
            }
        #endif
    }
}
