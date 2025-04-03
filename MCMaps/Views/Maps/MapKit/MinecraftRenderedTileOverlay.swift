//
//  MinecraftRenderedTileOverlay.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-04-2025.
//

import CubiomesKit
import MapKit

final class MinecraftRenderedTileOverlay: MKTileOverlay {
    private enum Constants {
        static let minBoundary = -29_999_984
        static let maxBoundary = 29_999_984
    }
    var world: MinecraftWorld
    let renderer: MinecraftWorldRenderer

    init(world: MinecraftWorld) {
        self.world = world
        self.renderer = MinecraftWorldRenderer(world: world)
        self.renderer.options = [.naturalColors]
        super.init(urlTemplate: nil)
        self.canReplaceMapContent = true
    }

    // TODO(alicerunsonfedora): Figure out how to properly map a path to a Minecraft world snapshot!
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, (any Error)?) -> Void) {
        var originX = Int32(Constants.minBoundary)
        var originZ = Int32(Constants.minBoundary)

        let totalTilesInMap = pow(4.0, Float(path.z))
        let totalTilesOnAxis = sqrt(totalTilesInMap)

        let blockPerTile = Constants.maxBoundary / Int(totalTilesOnAxis)
        originX += Int32(blockPerTile * path.x)
        originZ += Int32(blockPerTile * path.y)

        let chunk = MinecraftWorldRange(
            origin: Point3D(x: originX, y: 15, z: originZ),
            scale: Point3D<Int32>(x: Int32(blockPerTile), y: 1, z: Int32(blockPerTile)))

        print("📦 \(path) -> \(chunk.position)")

        let data = renderer.render(
            inRegion: chunk, scale: Int32(path.contentScaleFactor * 2), dimension: .overworld)
        result(data, nil)
    }
}
