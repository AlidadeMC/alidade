//
//  MinecraftStructureNameTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import CubiomesKit
import Foundation
import Testing

@testable import Alidade

struct MinecraftStructureNameTests {
    @Test(arguments: [
        ("Mineshaft", MinecraftStructure.mineshaft),
        ("Trial Chamber", MinecraftStructure.trialChambers),
        ("End City", MinecraftStructure.endCity),
    ])
    func nameReturnsValidMatch(name: String, expected: MinecraftStructure) async throws {
        let potentialStruct = MinecraftStructure(string: name)
        #expect(potentialStruct == expected)
        #expect(potentialStruct?.name == name)
    }
}
