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
    public func snapshot(
        in range: MinecraftWorldRange,
        dimension: Dimension = .overworld,
        pixelScale pixelsPerCell: Int32 = 4
    ) -> Data {
        var generator = generator(in: dimension)
        let _range = Range(
            scale: range.size,
            x: (range.position.x - (pixelsPerCell * range.scale.x / 2)) / range.size,
            z: (range.position.z - (pixelsPerCell * range.scale.z / 2)) / range.size,
            sx: range.scale.x,
            sz: range.scale.z,
            y: range.position.y,
            sy: range.scale.y
        )

        let biomeIds = allocCache(&generator, _range)
        genBiomes(&generator, biomeIds, _range)

        let imgWidth = pixelsPerCell * _range.sx
        let imgHeight = pixelsPerCell * _range.sz

        var biomeColors: (UInt8, UInt8, UInt8) = (0, 0, 0)
        initBiomeColors(&biomeColors)

        var rgbData = [CUnsignedChar](repeating: 0, count: Int(3 * imgWidth * imgHeight))
        biomesToImage(
            &rgbData,
            &biomeColors,
            UnsafePointer(biomeIds),
            UInt32(_range.sx),
            UInt32(_range.sz),
            UInt32(pixelsPerCell),
            2
        )
        biomeIds?.deallocate()

        let ppmData = PPMData(pixels: rgbData, size: .init(width: Double(imgWidth), height: Double(imgHeight)))
        return Data(ppm: ppmData)
    }
}
