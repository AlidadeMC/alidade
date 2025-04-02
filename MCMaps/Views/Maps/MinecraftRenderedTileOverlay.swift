//
//  MinecraftRenderedTileOverlay.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-04-2025.
//

import CubiomesKit
import MapKit

final class MinecraftRenderedTileOverlay: MKTileOverlay {
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
        let scale = 128
        let chunk = MinecraftWorldRange(
            origin: Point3D(x: Int32(path.x * scale * 4), y: 15, z: Int32(path.y * scale * 4)),
            scale: Point3D<Int32>(x: Int32(scale), y: 1, z: Int32(scale)))
        print(chunk)

        let data = renderer.render(inRegion: chunk, scale: 1, dimension: .overworld)
        result(data, nil)
    }
}
