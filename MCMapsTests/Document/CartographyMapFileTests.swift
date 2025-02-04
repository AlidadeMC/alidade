//
//  MCMapsTests.swift
//  MCMapsTests
//
//  Created by Marquis Kurt on 31-01-2025.
//

@testable import Alidade
import Testing

struct CartographyMapFileTests {
    @Test func initEmpty() async throws {
        let file = CartographyMapFile(map: .sampleFile)
        
        #expect(file.map == .sampleFile)
    }
    
    @Test func initFromData() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)

        #expect(file.map.name == "Pack.mcmeta")
        #expect(file.map.mcVersion == "1.2")
        #expect(file.map.seed == 3257840388504953787)
        #expect(file.map.pins.count == 2)
        #expect(file.map.recentLocations?.count == 1)
    }

    @Test func preparesForExport() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareForExport()
        
        #expect(exported == map)
    }
}

extension CartographyMapFileTests {
    static let packMcmetaFile =
        """
        {
          "mcVersion" : "1.2",
          "name" : "Pack.mcmeta",
          "pins" : [
            {
              "name" : "Spawn",
              "position" : [
                0,
                0
              ]
            },
            {
              "color" : "brown",
              "name" : "Screenshot",
              "position" : [
                116,
                -31
              ]
            }
          ],
          "recentLocations" : [
            [
              116,
              -31
            ]
          ],
          "seed" : 3257840388504953787
        }
        """
}
