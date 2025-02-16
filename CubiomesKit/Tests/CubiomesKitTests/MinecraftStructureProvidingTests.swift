//
//  MinecraftStructureProvidingTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import CubiomesInternal
import CubiomesKit
import Foundation
import Testing

struct MinecraftStructureProvidingTests {
    @Test func nearbyStructuresFound() async throws {
        let mcWorld = try MinecraftWorld(version: "1.8", seed: 123)
        let structures = mcWorld.findStructures(ofType: .mineshaft, at: .init(x: 864, y: 15, z: -20), inRadius: 7)
        print(structures)
        #expect(structures.count == 3)
    }
}
