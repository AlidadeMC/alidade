//
//  BiomeIDTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 07-03-2025.
//

import CubiomesInternal
import Foundation
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct BiomeIDTests {
    @Test func nameMatches() throws {
        let simpleBiome = try plains.name(for: "1.21.3")
        #expect(simpleBiome == "Plains")

        let complexBiome = try mushroom_field_shore.name(for: "1.21.3")
        #expect(complexBiome == "Mushroom Field Shore")
    }

    @Test func reverseLookup() throws {
        let biome = try BiomeID(string: "Mushroom Field Shore", mcVersion: "1.21.3")
        #expect(biome?.rawValue == mushroom_field_shore.rawValue)
    }
}
