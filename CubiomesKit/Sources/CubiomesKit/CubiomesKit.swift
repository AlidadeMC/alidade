// The Swift Programming Language
// https://docs.swift.org/swift-book

import CubiomesInternal
import Foundation

public struct MinecraftWorld {
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


    init(version: MCVersion, seed: Int64) {
        self.version = version
        self.seed = seed
    }

    public init(version: String, seed: Int64) throws(WorldError) {
        let mcVersion = MCVersion(rawValue: UInt32(str2mc(version)))
        guard mcVersion != MC_UNDEF else { throw .invalidVersionNumber }
        self.version = mcVersion
        self.seed = seed
    }

    func generator(in dimension: Dimension = .overworld) -> Generator {
        var generator = Generator()
        let flags: UInt32 = UInt32(largeBiomes ? LARGE_BIOMES : 0)
        seedGenerator(&generator, Int32(version.rawValue), flags, seed, dimension.cbDimension.rawValue)
        return generator
    }
}
