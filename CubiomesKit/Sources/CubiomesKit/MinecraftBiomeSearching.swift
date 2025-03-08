//
//  MinecraftBiomeSearching.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 02-03-2025.
//

import CubiomesInternal
import Foundation

private enum BiomeConstants {
    static let blocksPerChunk: Int32 = 16
}

public protocol MinecraftBiomeSearching {
    typealias Coordinate = Point3D<Int32>
    func findBiomes(
        ofType biome: BiomeID, at position: Coordinate, inRadius chunkRadius: Int32, dimension: MinecraftWorld.Dimension
    ) -> Set<Coordinate>
}

extension MinecraftWorld: MinecraftBiomeSearching {
    public func findBiomes(
        ofType biome: BiomeID, at position: Coordinate, inRadius chunkRadius: Int32 = 10,
        dimension: Dimension = .overworld
    ) -> Set<Coordinate> {
        var relevantBiomes = Set<Point3D<Int32>>()
        let blocksInChunkRadius = BiomeConstants.blocksPerChunk * chunkRadius
        let start = position.offset(by: -blocksInChunkRadius / 2)
        let end = position.offset(by: blocksInChunkRadius / 2)

        var generator = generator(in: dimension)

        for xVal in stride(from: start.x, to: end.x, by: 4) {
            for zVal in stride(from: start.z, to: end.z, by: 4) {
                let foundBiome = getBiomeAt(&generator, 4, xVal, position.y, zVal)
                if foundBiome != biome.rawValue {
                    continue
                }
                relevantBiomes.insert(.init(x: xVal, y: position.y, z: zVal))
            }
        }
        
        return relevantBiomes
    }
}
