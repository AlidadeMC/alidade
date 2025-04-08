//
//  MinecraftWorldRange.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import Foundation

public struct MinecraftWorldRange: Sendable {
    enum Scale {
        case xSmall, small, medium, large, xLarge
    }
    public var position: MinecraftPoint
    public var scale: Point3D<Int32>
    public var size: Int32

    public init(origin: MinecraftPoint, scale: Point3D<Int32>, size: Int32 = 4) {
        self.position = origin
        self.scale = scale
        self.size = size
    }

    public init(origin: MinecraftPoint, scalingTo tileSize: Int32, mapSize: Int32 = 4) {
        self.position = origin
        self.scale = Point3D(x: tileSize, y: 1, z: tileSize)
        self.size = mapSize
    }
}

extension Int32 {
    init(minecraftWorldScale scale: MinecraftWorldRange.Scale) {
        self =
            switch scale {
            case .xSmall: 1
            case .small: 4
            case .medium: 16
            case .large: 64
            case .xLarge: 256
            }
    }
}
