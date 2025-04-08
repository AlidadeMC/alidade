//
//  MinecraftWorldRendererTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import Foundation
import Testing

@testable import CubiomesKit

struct MinecraftWorldRendererTests {
    @Test func snapshotMatchesOriginalImage() async throws {
        guard
            let originalDataURL = Bundle.module.url(
                forResource: "snapshotMatchesOriginalImage",
                withExtension: "1"
            )
        else {
            Issue.record("Original snapshot file is missing!")
            return
        }
        let originalData = try Data(contentsOf: originalDataURL)
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 3_257_840_388_504_953_787)
        let renderer = MinecraftWorldRenderer(world: mcWorld)
        renderer.options = [.centerPositions]
        let data = renderer.render(
            inRegion: .init(
                origin: .init(x: 116, y: 15, z: -31),
                scale: .init(length: 256, width: 256, height: 1)),
            dimension: .overworld)
        #expect(data.hashValue == originalData.hashValue)
    }

    @Test func naturalColorsLoads() async throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 3_257_840_388_504_953_787)
        let renderer = MinecraftWorldRenderer(world: mcWorld)
        #expect(renderer.naturalColorFile != nil)
    }
}
