//
//  MinecraftRenderedTileOverlayTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import Foundation
import MapKit
import Testing

@testable import CubiomesKit

struct MinecraftRenderedTileOverlayTests {
    @Test func overlayReturnsCorrectTile() async throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let overlayPath = MKTileOverlayPath(x: 0, y: 0, z: 18, contentScaleFactor: 1)
        let overlay = MinecraftRenderedTileOverlay(world: mcWorld)
        let chunk = overlay.chunk(forOverlayPath: overlayPath)

        #expect(chunk.origin == MinecraftPoint(x: -33_554_432, y: 15, z: -33_554_432))
        #expect(chunk.size == MinecraftWorldRect.Size(length: 256, width: 256, height: 1))
    }

    @Test func overlayReturnsValidData() async throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let overlayPath = MKTileOverlayPath(x: 0, y: 0, z: 18, contentScaleFactor: 1)
        let overlay = MinecraftRenderedTileOverlay(world: mcWorld)
        await #expect(throws: Never.self) {
            try await overlay.loadTile(at: overlayPath)
        }
    }
}
