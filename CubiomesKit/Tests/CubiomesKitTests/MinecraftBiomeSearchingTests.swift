//
//  MinecraftBiomeSearchingTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 07-03-2025.
//

import CubiomesInternal
import Foundation
import Testing

@testable import CubiomesKit

struct MinecraftBiomeSearchingTests {
    @Test func biomeSearches() async throws {
        let world = try MinecraftWorld(version: "1.8", seed: 123)
        let biomes = world.findBiomes(ofType: plains, at: .init(x: -255, y: 15, z: 1322))
        #expect(!biomes.isEmpty)
    }
}
