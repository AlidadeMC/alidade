//
//  MinecraftRenderedTileOverlay.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit

final class MinecraftRenderedTileOverlay: MKTileOverlay {
    var world: MinecraftWorld
    var dimension: MinecraftWorld.Dimension = .overworld
    let renderer: MinecraftWorldRenderer

    init(world: MinecraftWorld, dimension: MinecraftWorld.Dimension = .overworld) {
        self.world = world
        self.dimension = dimension
        self.renderer = MinecraftWorldRenderer(world: world)
        self.renderer.options = []
        super.init(urlTemplate: nil)
        self.canReplaceMapContent = true
    }

    enum Constants {
        // NOTE(alicerunsonfedora): This needs to be a power of 2!

        static let minBoundary = -33_554_432  // -29_999_984 is world border
        static let maxBoundary = 33_554_432  // 29_999_984 is world border
    }

    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, (any Error)?) -> Void) {
        var posX = Int32(Constants.minBoundary)
        var posZ = Int32(Constants.minBoundary)

        let totalTilesOnAxis = (1 << path.z)
        let span = Constants.maxBoundary - Constants.minBoundary

        let blockPerTile = span / totalTilesOnAxis
        posX += Int32(blockPerTile * path.x)
        posZ += Int32(blockPerTile * path.y)

        let chunk = MinecraftWorldRange(
            origin: Point3D(x: posX, y: 15, z: posZ),
            scale: Point3D<Int32>(x: Int32(blockPerTile), y: 1, z: Int32(blockPerTile)))

        #if DEBUG
            print("🔳 \(totalTilesOnAxis), 🧱 \(blockPerTile)")
            print(
                "🗺️ [\(path.x), \(path.y) @ \(path.z)] -> 🍱 [\(chunk.position.x), \(chunk.position.z) @ \(blockPerTile)]"
            )
        #endif

        let data = renderer.render(
            inRegion: chunk, scale: Int32(path.contentScaleFactor) * 1, dimension: dimension)
        result(data, nil)
    }
}
