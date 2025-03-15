//
//  MinecraftBiomeSearching.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 02-03-2025.
//

import CubiomesInternal
import Foundation

private enum BiomeConstants {
    static let biomeScale: Int32 = 4
    static let minimumSize: Int32 = 1
    static let tolerance: Int32 = 8
    static let coordinateCount: Int = 10
}

public protocol MinecraftBiomeSearching {
    typealias Coordinate = Point3D<Int32>
    func findBiomes(
        ofType biome: MinecraftBiome, at position: Coordinate, inRadius blockRadius: Int32,
        dimension: MinecraftWorld.Dimension
    ) -> Set<Coordinate>
}

extension MinecraftWorld: MinecraftBiomeSearching {
    public func findBiomes(
        ofType biome: MinecraftBiome, at position: Coordinate, inRadius blockRadius: Int32 = 4000,
        dimension: Dimension = .overworld
    ) -> Set<Coordinate> {
        var relevantBiomes = Set<Point3D<Int32>>()
        let searchRadius = blockRadius / BiomeConstants.biomeScale
        let start = position.offset(by: -searchRadius)

        let range = Range(
            scale: 4,
            x: start.x,
            z: start.z,
            sx: 2 * searchRadius,
            sz: 2 * searchRadius,
            y: position.y,
            sy: 1
        )
        
        var generator = generator(in: dimension)

        var positions = Array(repeating: Pos(x: Int32.min, z: Int32.min), count: BiomeConstants.coordinateCount)
        getBiomeCenters(
            &positions,
            nil,
            Int32(BiomeConstants.coordinateCount),
            &generator,
            range,
            biome.rawValue,
            BiomeConstants.minimumSize,
            BiomeConstants.tolerance,
            nil
        )

        if positions.allSatisfy({ pos in
            pos.x == Int32.min && pos.z == Int32.min
        }) {
            return []
        }

        for pos in positions {
            relevantBiomes.insert(Point3D<Int32>(x: pos.x, y: position.y, z: pos.z))
        }
        return relevantBiomes
    }
}
