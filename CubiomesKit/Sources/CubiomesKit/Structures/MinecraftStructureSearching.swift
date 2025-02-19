//
//  MinecraftStructureProviding.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import CubiomesInternal
import Foundation

private enum StructureConstants {
    static let blocksPerChunk: Int32 = 16
}

public protocol MinecraftStructureSearching {
    typealias Coordinate = Point3D<Int32>
    func findStructures(
        ofType structureType: MinecraftStructure, at position: Coordinate, inRadius chunkRadius: Int32,
        dimension: MinecraftWorld.Dimension
    )
        -> Set<Coordinate>
}

extension MinecraftWorld: MinecraftStructureSearching {
    public func findStructures(
        ofType structureType: MinecraftStructure, at position: Coordinate, inRadius chunkRadius: Int32 = 1,
        dimension: Dimension = .overworld
    ) -> Set<Coordinate> {
        var structures = Set<Coordinate>()
        var generator = generator(in: dimension)
        let blocksInChunkRadius = chunkRadius * StructureConstants.blocksPerChunk
        let sType = Int32(structureType.cbStructure.rawValue)

        var surfaceNoise = SurfaceNoise()
        if dimension == .end, structureType == .endCity {
            initSurfaceNoise(&surfaceNoise, dimension.cbDimension.rawValue, generator.seed)
        }

        let start = position.offset(by: -blocksInChunkRadius)
        let end = position.offset(by: blocksInChunkRadius)
        var structConfig = StructureConfig()
        guard getStructureConfig(sType, generator.mc, &structConfig) > 0 else {
            return structures
        }

        let blocksPerRegion: Double = Double(structConfig.regionSize) * Double(StructureConstants.blocksPerChunk)
        let regionStart = Point3D<Int32>(
            x: Int32(floor(Double(start.x) / blocksPerRegion)),
            y: start.y,
            z: Int32(floor(Double(start.z) / blocksPerRegion))
        )
        let regionEnd = Point3D<Int32>(
            x: Int32(floor(Double(end.x) / blocksPerRegion)),
            y: end.y,
            z: Int32(floor(Double(end.z) / blocksPerRegion))
        )

        for zCoord in regionStart.z...regionEnd.z {
            for xCoord in regionStart.x...regionEnd.x {
                var pos = Pos()
                guard getStructurePos(sType, generator.mc, generator.seed, xCoord, zCoord, &pos) > 0 else {
                    continue
                }

                guard (start.x...end.x).contains(pos.x), (start.z...end.z).contains(pos.z) else {
                    continue
                }

                guard isViableStructurePos(sType, &generator, pos.z, pos.x, 0) > 0 else {
                    continue
                }

                if dimension == .end, structureType == .endCity {
                    guard isViableEndCityTerrain(&generator, &surfaceNoise, pos.x, pos.z) > 0 else {
                        continue
                    }
                } else if version.rawValue >= MC_1_18.rawValue {
                    guard isViableStructureTerrain(sType, &generator, pos.x, pos.z) > 0 else {
                        continue
                    }
                }

                structures.insert(Point3D<Int32>(x: pos.x, y: 1, z: pos.z))
            }
        }

        return structures
    }
}
