// The Swift Programming Language
// https://docs.swift.org/swift-book

import CubiomesInternal
import Foundation

public struct Point3D<T: Numeric> {
    public var x: T
    public var y: T
    public var z: T

    public init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(cgPoint: CGPoint) where T == Int {
        self.x = Int(cgPoint.x)
        self.y = 1
        self.z = Int(cgPoint.y)
    }

    public init(cgPoint: CGPoint) where T == Int32 {
        self.x = Int32(cgPoint.x)
        self.y = 1
        self.z = Int32(cgPoint.y)
    }
}

public struct MinecraftWorldRange {
    public var position: Point3D<Int32>
    public var scale: Point3D<Int32>
    public var size: Int32

    public init(origin: Point3D<Int32>, scale: Point3D<Int32>, size: Int32 = 4) {
        self.position = origin
        self.scale = scale
        self.size = size
    }
}

public struct MinecraftWorld {
    public enum Dimension {
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
    
    public init(version: String, seed: Int64) {
        self.version = MCVersion(rawValue: UInt32(str2mc(version)))
        self.seed = seed
    }

    public func snapshot(
        in range: MinecraftWorldRange,
        dimension: Dimension = .overworld,
        pixelScale pixelsPerCell: Int32 = 4
    ) -> Data? {
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
        
        return ppmData(rgbData, size: .init(width: Double(imgWidth), height: Double(imgHeight)))
    }
}

func ppmData(_ pixels: [CUnsignedChar], size: CGSize) -> Data? {
    let header = "P6\n\(Int(size.width)) \(Int(size.height))\n255\n"
    var file = Data(header.utf8)
    file.append(contentsOf: pixels)
    return file
}
