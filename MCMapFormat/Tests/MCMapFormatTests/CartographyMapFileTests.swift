//
//  MCMapsTests.swift
//  MCMapsTests
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI
import Testing

@testable import MCMapFormat

struct CartographyMapFileTests {
    @Test func initEmpty() async throws {
        let file = CartographyMapFile(withManifest: .sampleFile)

        #expect(file.manifest == .sampleFile)
    }

    @Test func initFromData() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)

        #expect(file.manifest.name == "Pack.mcmeta")
        #expect(file.manifest.worldSettings.version == "1.2")
        #expect(file.manifest.worldSettings.seed == 3_257_840_388_504_953_787)
        #expect(file.manifest.pins.count == 2)
        #expect(file.manifest.recentLocations?.count == 1)
    }

    @Test func initFromFileWrappers() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
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

    @Test func preparesForExport() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()

        #expect(exported == map)
    }

    @Test func handlesMigrationToV2() async throws {
        guard let map = Self.packMcmetaFile_V1.data(using: .utf8),
              let mapV2 = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()
        
        #expect(exported == mapV2)
    }

    @Test func fileWrapper() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        var file = try CartographyMapFile(decoding: map)
        file.images = ["foo.png": Data()]
        file.appState.tabCustomization = TabViewCustomization()
    
        let wrapper = try file.wrapper()

        #expect(wrapper.isDirectory == true)
        #expect(wrapper.fileWrappers?["Info.json"] != nil)
        #expect(wrapper.fileWrappers?["Images"] != nil)
        #expect(wrapper.fileWrappers?["AppState"] != nil)

        let infoWrapper = wrapper.fileWrappers?["Info.json"]!
        #expect(infoWrapper?.isRegularFile == true)
        #expect(infoWrapper?.regularFileContents == map)

        let imagesWrapper = wrapper.fileWrappers?["Images"]!
        #expect(imagesWrapper?.isDirectory == true)
        #expect(imagesWrapper?.fileWrappers?["foo.png"] != nil)

        let appStateWrapper = wrapper.fileWrappers?["AppState"]!
        #expect(appStateWrapper?.isDirectory == true)
        #expect(appStateWrapper?.fileWrappers?["Tabs.json"] != nil)

        let integrations = wrapper.fileWrappers?["Integrations"]!
        #expect(integrations?.isDirectory == true)
        #expect(integrations?.fileWrappers?["Bluemap.json"] != nil)
    }

    @Test func pinDeletesAtIndex() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data()
        ])
        file.manifest.pins[0].images = ["foo.png"]
        file.removePin(at: file.manifest.pins.startIndex)
        #expect(file.images["foo.png"] == nil)
        #expect(file.images.isEmpty)
        #expect(file.manifest.pins.isEmpty)
    }

    @Test func pinDeletesAtOffsets() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data(),
            "bar.png": Data()
        ])
        file.manifest.pins[0].images = ["foo.png"]
        file.manifest.pins.append(MCMapManifestPin(position: .init(x: 2, y: 2), name: "Don't delete me"))
        file.manifest.pins.append(MCMapManifestPin(position: .zero, name: "Alt Point", images: ["bar.png"]))
        file.removePins(at: [0, 2])
        #expect(file.images.isEmpty)
        #expect(file.manifest.pins.count == 1)
        #expect(file.manifest.pins[0].name == "Don't delete me")
    }
}

extension CartographyMapFileTests {
    static let packMcmetaFile_V1 =
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

    static let packMcmetaFile_V2 =
        """
        {
          "manifestVersion" : 2,
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
          "world" : {
            "largeBiomes" : false,
            "seed" : 3257840388504953787,
            "version" : "1.2"
          }
        }
        """
}
