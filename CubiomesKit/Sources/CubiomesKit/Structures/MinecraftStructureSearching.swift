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

/// A protocol that defines behavior for being able to search Minecraft structures.
public protocol MinecraftStructureSearching {
    /// Search for structures within a specific radius.
    /// - Parameter structureType: The structure to search for within the given radius.
    /// - Parameter position: The center position to begin searching from.
    /// - Parameter chunkRadius: The chunk radius from the center position to search in.
    /// - Parameter dimension: The world dimension to search in.
    /// - Returns: A set of Minecraft points representing the locations of the structures, if any were found.
    func findStructures(
        ofType structureType: MinecraftStructure,
        at position: MinecraftPoint,
        inRadius chunkRadius: Int32,
        dimension: MinecraftWorld.Dimension
    )
    -> Set<MinecraftPoint>
}

extension MinecraftWorld: MinecraftStructureSearching {
    /// Search for structures within a specific radius in a Minecraft world.
    /// - Parameter structureType: The structure to search for within the given radius.
    /// - Parameter position: The center position to begin searching from.
    /// - Parameter chunkRadius: The chunk radius from the center position to search in.
    /// - Parameter dimension: The world dimension to search in.
    /// - Returns: A set of Minecraft points representing the locations of the structures, if any were found.
    public func findStructures(
        ofType structureType: MinecraftStructure,
        at position: MinecraftPoint,
        inRadius chunkRadius: Int32 = 1,
        dimension: Dimension = .overworld
    ) -> Set<MinecraftPoint> {
        var structures = Set<MinecraftPoint>()
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
