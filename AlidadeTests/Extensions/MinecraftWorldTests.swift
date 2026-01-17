//
//  MinecraftWorldTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-08-2025.
//

import CubiomesKit
import MCMap
import Testing

@testable import Alidade

struct MinecraftWorldTests {
    @Test func worldInitFromSettings() async throws {
        let worldSettings = MCMapManifestWorldSettings(version: "1.21", seed: 123)
        let world = try MinecraftWorld(worldSettings: worldSettings)

        #expect(world.version == MC_1_21)
        #expect(world.seed == 123)
    }
}
