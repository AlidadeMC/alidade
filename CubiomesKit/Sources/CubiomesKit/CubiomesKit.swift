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

    public func snapshot(
        in range: MinecraftWorldRange,
        dimension: Dimension = .overworld,
        pixelScale pixelsPerCell: Int32 = 4
    ) -> Data {
        var generator = Generator()
        let flags: UInt32 = UInt32(largeBiomes ? LARGE_BIOMES : 0)
        seedGenerator(&generator, Int32(version.rawValue), flags, seed, dimension.cbDimension.rawValue)

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

@available(*, deprecated, message: "Use Data(ppm:) and provide a PPMData type.")
func ppmData(_ pixels: [CUnsignedChar], size: CGSize) -> Data {
    let header = "P6\n\(Int(size.width)) \(Int(size.height))\n255\n"
    var file = Data(header.utf8)
    file.append(contentsOf: pixels)
    return file
}
