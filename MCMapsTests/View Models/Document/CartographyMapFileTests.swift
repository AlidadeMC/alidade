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
    @Test(.tags(.document))
    func initEmpty() async throws {
        let file = CartographyMapFile(withManifest: .sampleFile)

        #expect(file.manifest == .sampleFile)
    }

    @Test(.tags(.document))
    func initFromData() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)

        #expect(file.manifest.name == "Pack.mcmeta")
        #expect(file.manifest.mcVersion == "1.2")
        #expect(file.manifest.seed == 3_257_840_388_504_953_787)
        #expect(file.manifest.pins.count == 2)
        #expect(file.manifest.recentLocations?.count == 1)
    }

    @Test(.tags(.document))
    func initFromFileWrappers() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        var file = try CartographyMapFile(decoding: map)
        file.images = ["foo.png": Data()]
        let wrapper = try file.wrapper()

        let newFile = try CartographyMapFile(fileWrappers: wrapper.fileWrappers)
        #expect(newFile.manifest == file.manifest)
        #expect(newFile.images == ["foo.png": Data()])
    }

    @Test(.tags(.document))
    func preparesForExport() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()

        #expect(exported == map)
    }

    @Test(.tags(.document))
    func fileWrapper() async throws {
        guard let map = Self.packMcmetaFile.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        var file = try CartographyMapFile(decoding: map)
        file.images = ["foo.png": Data()]
        let wrapper = try file.wrapper()

        #expect(wrapper.isDirectory == true)
        #expect(wrapper.fileWrappers?["Info.json"] != nil)
        #expect(wrapper.fileWrappers?["Images"] != nil)

        let infoWrapper = wrapper.fileWrappers?["Info.json"]!
        #expect(infoWrapper?.isRegularFile == true)
        #expect(infoWrapper?.regularFileContents == map)

        let imagesWrapper = wrapper.fileWrappers?["Images"]!
        #expect(imagesWrapper?.isDirectory == true)
        #expect(imagesWrapper?.fileWrappers?["foo.png"] != nil)
    }

    @Test(.tags(.document))
    func pinDeletesAtIndex() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data()
        ])
        file.manifest.pins[0].images = ["foo.png"]
        file.removePin(at: file.manifest.pins.startIndex)
        #expect(file.images["foo.png"] == nil)
        #expect(file.images.isEmpty)
        #expect(file.manifest.pins.isEmpty)
    }

    @Test(.tags(.document))
    func pinDeletesAtOffsets() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data(),
            "bar.png": Data()
        ])
        file.manifest.pins[0].images = ["foo.png"]
        file.manifest.pins.append(CartographyMapPin(position: .init(x: 2, y: 2), name: "Don't delete me"))
        file.manifest.pins.append(CartographyMapPin(position: .zero, name: "Alt Point", images: ["bar.png"]))
        file.removePins(at: [0, 2])
        #expect(file.images.isEmpty)
        #expect(file.manifest.pins.count == 1)
        #expect(file.manifest.pins[0].name == "Don't delete me")
    }
}

extension CartographyMapFileTests {
    static let packMcmetaFile =
        """
        {
          "manifestVersion" : 1,
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
