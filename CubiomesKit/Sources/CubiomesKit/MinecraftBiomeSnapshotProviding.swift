//
//  MinecraftBiomeSnapshotProviding.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import CubiomesInternal
import Foundation

public protocol MinecraftBiomeSnapshotProviding {
    func snapshot(in range: MinecraftWorldRange, dimension: MinecraftWorld.Dimension, pixelScale pixelsPerCell: Int32)
        -> Data
}

extension MinecraftWorld: MinecraftBiomeSnapshotProviding {
    @available(*, deprecated, message: "Use the MinecraftWorldRenderer class to create an image.")
    public func snapshot(
        in range: MinecraftWorldRange,
        dimension: Dimension = .overworld,
        pixelScale pixelsPerCell: Int32 = 4
    ) -> Data {
        let renderer = MinecraftWorldRenderer(world: self)
        return renderer.render(inRegion: range, scale: pixelsPerCell, dimension: dimension)
    }
}
