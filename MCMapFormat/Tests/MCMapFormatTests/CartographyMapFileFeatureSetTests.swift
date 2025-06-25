//
//  CartographyMapFileFeatureSetTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-06-2025.
//

import Foundation
import Testing

@testable import MCMapFormat

struct CartographyMapFileFeatureSetTests {
    @Test func featureSet_v1() async throws {
        let file = CartographyMapFile(
            withManifest: MCMapManifest(
                manifestVersion: 1,
                name: "Augenwaldburg",
                worldSettings: MCMapManifest.WorldSettings(version: "1.21.3", seed: 184719632014, largeBiomes: false),
                pins: []
            )
        )
        
        #expect(file.supportedFeatures.contains(.minimumDefault))
        #expect(!file.supportedFeatures.contains(.pinTagging))
        #expect(!file.supportedFeatures.contains(.largeBiomes))
    }

    @Test func featureSet_v2() async throws {
        let file = CartographyMapFile(
            withManifest: MCMapManifest(
                manifestVersion: 2,
                name: "Augenwaldburg",
                worldSettings: MCMapManifest.WorldSettings(version: "1.21.3", seed: 184719632014, largeBiomes: false),
                pins: []
            )
        )
        
        #expect(file.supportedFeatures.contains(.minimumDefault))
        #expect(file.supportedFeatures.contains(.pinTagging))
        #expect(file.supportedFeatures.contains(.largeBiomes))
    }
}
