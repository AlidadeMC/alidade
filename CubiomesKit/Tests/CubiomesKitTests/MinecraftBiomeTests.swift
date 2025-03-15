//
//  MinecraftBiomeTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-03-2025.
//

import Foundation
import Testing

@testable import CubiomesKit

struct MinecraftBiomeTests {
    @Test func nameMatches() throws {
        let simpleBiome = plains.localizedString(for: MC_1_21_3)
        #expect(simpleBiome == "Plains")

        let complexBiome = mushroom_field_shore.localizedString(for: MC_1_21_3)
        #expect(complexBiome == "Mushroom Field Shore")
    }

    @Test func reverseLookup() throws {
        let biome = MinecraftBiome(localizedString: "Mushroom Field Shore", mcVersion: "1.21.3")
        #expect(biome?.rawValue == mushroom_field_shore.rawValue)
    }
}
