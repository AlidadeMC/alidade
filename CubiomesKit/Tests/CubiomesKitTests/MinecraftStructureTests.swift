//
//  MinecraftStructureTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import Testing

@testable import CubiomesKit

struct MinecraftStructureTests {
    @Test(arguments: MinecraftStructure.allCases)
    func structureTypeIsValid(structure: MinecraftStructure) async throws {
        #expect(structure.cbStructure != FEATURE_NUM)
    }
}
