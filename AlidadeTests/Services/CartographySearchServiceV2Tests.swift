//
//  CartographySearchServiceV2Tests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-10-2025.
//

import AlidadeSearchEngine
import CubiomesKit
import Foundation
import MCMap
import Testing

@testable import Alidade

struct CartographySearchServiceV2Tests {
    typealias SearchContext = CartographySearchService_v2.Context

    @Test("Empty query")
    func searchReturnsNoResultsOnEmptyQuery() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()

        let results = await service.search(query: "", in: SearchContext(world: world, file: file))
        #expect(results.isEmpty)
    }

    @Test(arguments: ["Spawn", "spawn", "Spa", "awn"])
    func searchReturnsPinsByName(query: AlidadeSearchQuery) async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()

        let results = await service.search(query: query, in: SearchContext(world: world, file: file))
        #expect(results.pins.count == 1)
        #expect(results.pins.first?.name == "Spawn")
        #expect(results.pins.first?.position == .zero)
    }

    @Test(arguments: ["#Tag test", "#Tag"])
    func searchReturnsPinsWithTag(query: AlidadeSearchQuery) async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        var file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()

        file.pins.append(contentsOf: [
            CartographyMapPin(named: "Testing", at: CGPoint(x: 12, y: 12), tags: ["Tag", "Forest"]),
            CartographyMapPin(named: "Testing Grounds", at: CGPoint(x: 10, y: 10), tags: ["Base"]),
            CartographyMapPin(named: "Test Test", at: CGPoint(x: 11, y: 11), tags: ["Tag"])
        ])

        let results = await service.search(query: query, in: SearchContext(world: world, file: file))
        #expect(results.pins.count == 2)
        #expect(results.pins.allSatisfy { $0.tags?.contains("Tag") != false })
    }

    @Test func searchReturnsNearbyStructures() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()

        let results = await service.search(
            query: "mineshaft",
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
        let service = CartographySearchService_v2()
        let results = await service.search(
            query: "Frozen River",
            in: SearchContext(world: world, file: file, position: .zero))
        #expect(!results.biomes.isEmpty)
    }

    @Test func searchReturnsNearbyBiomesRelativeToFilteredOrigin() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()
        let context = SearchContext(world: world, file: file, position: .zero)

        let originResults = await service.search(query: "Frozen River", in: context)
        
        let results = await service.search(
            query: "Frozen River @{1000, 1000}",
            in: context)

        #expect(originResults.biomes.map(\.position) != results.biomes.map(\.position))
    }

    @Test func searchReturnsBiomeResultsRelativeToDimensionInQuery() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()
        let context = SearchContext(world: world, file: file, position: .zero, dimension: .nether)

        let results = await service.search(query: "dimension: Overworld Frozen River", in: context)
        #expect(!results.isEmpty)
    }

    @Test func searchReturnsStructureResultsRelativeToDimensionInQuery() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        let file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()
        let context = SearchContext(world: world, file: file, position: .zero, dimension: .overworld)

        let results = await service.search(query: "dimension: Nether Bastion", in: context)
        #expect(!results.isEmpty)
    }

    @Test func searchReturnsPinsRelativeToDimensionInQuery() async throws {
        let world = try MinecraftWorld(version: "1.21.3", seed: 123)
        var file = CartographyMapFile(withManifest: .sampleFile)
        let service = CartographySearchService_v2()

        file.pins.append(contentsOf: [
            CartographyMapPin(named: "Testing", at: CGPoint(x: 12, y: 12), dimension: .nether, tags: ["Tag", "Forest"]),
            CartographyMapPin(named: "Testing Grounds", at: CGPoint(x: 10, y: 10), tags: ["Base"]),
            CartographyMapPin(named: "Test Test", at: CGPoint(x: 11, y: 11), tags: ["Tag"])
        ])

        let results = await service.search(query: "#Tag dimension: Nether", in: SearchContext(world: world, file: file))
        #expect(results.pins.count == 1)
        #expect(results.pins.allSatisfy { $0.tags?.contains("Tag") != false })
    }
}
