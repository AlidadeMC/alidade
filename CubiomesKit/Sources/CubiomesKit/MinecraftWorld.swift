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
    /// Errors that can occur when attempting to create a Minecraft world.
    public enum WorldError: Error {
        /// The version of Minecraft provided was invalid.
        case invalidVersionNumber
    }

    /// An enumeration for the dimensions in a Minecraft world.
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

    /// The version of Minecraft used to generate the world.
    public var version: MCVersion

    /// The seed used to generate the world.
    public var seed: Int64

    /// Whether to enable the large biomes feature.
    public var largeBiomes = false

    /// Initialized a Minecraft world for a specified version and seed.
    ///
    /// > Note: If an invalid version is provided, or the version string failed to map to a valid Minecraft version.
    ///
    /// - Parameter version: The version of Minecraft used to generate the world.
    /// - Parameter seed: The seed used to generate the world.
    public init(version: String, seed: Int64) throws(WorldError) {
        let mcVersion = MinecraftVersion(version)
        guard !mcVersion.isUndefined else { throw .invalidVersionNumber }
        self.version = mcVersion
        self.seed = seed
    }

    init(version: MinecraftVersion, seed: Int64) {
        self.version = version
        self.seed = seed
    }

    func generator(in dimension: Dimension = .overworld) -> Generator {
        var generator = Generator()
        let flags: UInt32 = UInt32(largeBiomes ? LARGE_BIOMES : 0)
        seedGenerator(&generator, version.versionValue, flags, seed, dimension.cbDimension.rawValue)

        return generator
    }
}
