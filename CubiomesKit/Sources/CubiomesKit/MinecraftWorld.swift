//
//  MinecraftWorld.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import CubiomesInternal
import Foundation

/// A structure representing a Minecraft world.
public struct MinecraftWorld: Sendable {
    public enum WorldError: Error {
        case invalidVersionNumber
    }
    public enum Dimension: Sendable {
        case overworld, nether, end

        var cbDimension: CubiomesInternal.Dimension {
            switch self {
            case .overworld: DIM_OVERWORLD
            case .nether: DIM_NETHER
            case .end: DIM_END
            }
        }
    }
    public var version: MCVersion
    public var seed: Int64
    public var largeBiomes = false

    public init(version: MinecraftVersion, seed: Int64) {
        self.version = version
        self.seed = seed
    }

    public init(version: String, seed: Int64) throws(WorldError) {
        let mcVersion = MinecraftVersion(version)
        guard mcVersion != MC_UNDEF else { throw .invalidVersionNumber }
        self.version = mcVersion
        self.seed = seed
    }

    func generator(in dimension: Dimension = .overworld) -> Generator {
        var generator = Generator()
        let flags: UInt32 = UInt32(largeBiomes ? LARGE_BIOMES : 0)
        seedGenerator(&generator, version.versionValue, flags, seed, dimension.cbDimension.rawValue)
    
        return generator
    }
}
