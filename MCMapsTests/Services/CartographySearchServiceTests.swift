//
//  CartographySearchServiceTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import CubiomesKit
import Foundation
import MCMap
import Testing

@testable import Alidade

struct CartographySearchServiceTests {
    typealias SearchContext = CartographySearchService.SearchContext
    typealias SearchFilterGroup = CartographySearchService.SearchFilterGroup

    @Test("Empty query")
    func searchReturnsNoResultsOnEmptyQuery() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()

        let results = await service.search(for: "", in: SearchContext(world: world, file: file))
        #expect(results.isEmpty)
    }

    @Test(arguments: ["Spawn", "spawn", "Spa", "awn"])
    func searchReturnsPinsByName(query: String) async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()

        let results = await service.search(for: query, in: SearchContext(world: world, file: file))
        #expect(results.pins.count == 1)
        #expect(results.pins.first?.name == "Spawn")
        #expect(results.pins.first?.position == .zero)
    }

    @Test(arguments: ["test", ""])
    func searchReturnsPinsWithTag(query: CartographySearchService.Query) async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        var file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()

        file.pins.append(contentsOf: [
            CartographyMapPin(named: "Testing", at: CGPoint(x: 12, y: 12), tags: ["Tag", "Forest"]),
            CartographyMapPin(named: "Testing Grounds", at: CGPoint(x: 10, y: 10), tags: ["Base"]),
            CartographyMapPin(named: "Test Test", at: CGPoint(x: 11, y: 11), tags: ["Tag"])
        ])

        let results = await service.search(
            for: query,
            in: SearchContext(world: world, file: file),
            filters: SearchFilterGroup(filters: [.tag("Tag")]))
        #expect(results.pins.count == 2)
        #expect(results.pins.allSatisfy { $0.tags?.contains("Tag") != false })
    }

    @Test(
        arguments: [
            ("1847, 1847", CGPoint(x: 1847, y: 1847)),
            ("-19, 20", CGPoint(x: -19, y: 20)),
            ("-11, -11", CGPoint(x: -11, y: -11)),
        ]
    )
    func searchReturnsJumpingLink(query: String, position: CGPoint) async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()

        let results = await service.search(for: query, in: SearchContext(world: world, file: file))
        #expect(results.coordinates.count == 1)
        #expect(results.coordinates.first == position)
    }

    @Test func searchReturnsNearbyStructures() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()

        let results = await service.search(
            for: "mineshaft",
            in: SearchContext(
                world: world,
                file: file,
                position: MinecraftPoint(x: 113, y: 15, z: 430)))
        #expect(results.structures.count == 11)
        #expect(results.structures.allSatisfy { $0.name == "Mineshaft" })
    }

    @Test func searchReturnsNearbyBiomes() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()
        let results = await service.search(
            for: "Frozen River",
            in: SearchContext(world: world, file: file, position: .zero))
        #expect(!results.biomes.isEmpty)
    }

    @Test func searchReturnsNearbyBiomesRelativeToFilteredOrigin() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService()
        let context = SearchContext(world: world, file: file, position: .zero)

        let originResults = await service.search(for: "Frozen River", in: context)
        
        let results = await service.search(
            for: "Frozen River",
            in: context,
            filters: SearchFilterGroup(
                filters: [.origin(CGPoint(x: 1000, y: 1000))]
            )
        )

        #expect(originResults.biomes.map(\.position) != results.biomes.map(\.position))
    }
}
