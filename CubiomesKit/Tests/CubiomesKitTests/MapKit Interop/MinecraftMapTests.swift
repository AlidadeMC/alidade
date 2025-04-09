//
//  MinecraftMapTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import MapKit
import SwiftUI
import Testing

@testable import CubiomesKit

@MainActor
struct MinecraftMapTests {
    @Test func viewInit() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let map = MinecraftMap(world: mcWorld)

        #expect(map.world.version == mcWorld.version)
        #expect(map.world.seed == mcWorld.seed)
        #expect(map.ornaments.isEmpty)
        #expect(map.centerCoordinate == nil)
        #expect(map.annotations.isEmpty)
        #expect(map.dimension == .overworld)
        #expect(map.preferNaturalColors == false)
    }

    @Test func viewAnnotationsModifier() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let map = MinecraftMap(world: mcWorld) {
            Marker(location: .zero, title: "Spawn")
        }

        #expect(map.annotations.count == 1)
        #expect(map.annotations.allSatisfy({ $0 is MinecraftMapMarkerAnnotation }))

        let mapTwo = MinecraftMap(world: mcWorld) {
            Array(repeating: Marker(location: CGPoint(x: 10, y: 10), title: "Foo"), count: 10)
        }

        #expect(mapTwo.annotations.count == 10)
        #expect(mapTwo.annotations.allSatisfy({ $0 is MinecraftMapMarkerAnnotation }))
    }

    @Test func viewOrnamentsModifier() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let map = MinecraftMap(world: mcWorld)
            .ornaments(.all)

        #expect(map.ornaments == .all)
    }

    @Test func viewMapColorSchemeModifier() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let map = MinecraftMap(world: mcWorld)
            .mapColorScheme(.natural)

        #expect(map.preferNaturalColors == true)
    }

    @Test func viewMapCreatesView() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let map = MinecraftMap(world: mcWorld)

        let mapView = map.createMapView()
        #expect(mapView.world.version == mcWorld.version)
        #expect(mapView.world.seed == mcWorld.seed)
        #expect(mapView.ornaments.isEmpty)
        #expect(mapView.dimension == .overworld)
        #expect(mapView.annotations.isEmpty)
        #expect(!mapView.renderOptions.contains(.naturalColors))
    }

    @Test func viewMapUpdatesView() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let mapView = MinecraftMapView(world: mcWorld, frame: .zero)
        let map = MinecraftMap(world: mcWorld) {
            Marker(location: .zero, title: "Spawn")
        }
            .ornaments(.all)
            .mapColorScheme(.natural)

        map.updateMapView(mapView)
        #expect(mapView.ornaments == .all)
        #expect(mapView.renderOptions.contains(.naturalColors))
        #expect(mapView.annotations.count == 1)
    }
}
