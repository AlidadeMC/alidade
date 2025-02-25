//
//  MCMapsTests.swift
//  MCMapsTests
//
//  Created by Marquis Kurt on 31-01-2025.
//

import Foundation
import Testing

@testable import Alidade

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
        #expect(file.map.seed == 3_257_840_388_504_953_787)
        #expect(file.map.pins.count == 2)
        #expect(file.map.recentLocations?.count == 1)
    }

    @Test func preparesForExport() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()

        #expect(exported == map)
    }

    @Test func pinDeletesAtIndex() async throws {
        var file = CartographyMapFile(map: .sampleFile, images: [
            "foo.png": Data()
        ])
        file.map.pins[0].images = ["foo.png"]
        file.removePin(at: file.map.pins.startIndex)
        #expect(file.images["foo.png"] == nil)
        #expect(file.images.isEmpty)
        #expect(file.map.pins.isEmpty)
    }

    @Test func pinDeletesAtOffsets() async throws {
        var file = CartographyMapFile(map: .sampleFile, images: [
            "foo.png": Data(),
            "bar.png": Data()
        ])
        file.map.pins[0].images = ["foo.png"]
        file.map.pins.append(.init(position: .init(x: 2, y: 2), name: "Don't delete me"))
        file.map.pins.append(.init(position: .zero, name: "Alt Point", images: ["bar.png"]))
        file.removePins(at: [0, 2])
        #expect(file.images.isEmpty)
        #expect(file.map.pins.count == 1)
        #expect(file.map.pins[0].name == "Don't delete me")
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
