//
//  MinecraftWorldRange.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import Foundation

public struct MinecraftWorldRange: Sendable {
    public var position: Point3D<Int32>
    public var scale: Point3D<Int32>
    public var size: Int32

    public init(origin: Point3D<Int32>, scale: Point3D<Int32>, size: Int32 = 4) {
        self.position = origin
        self.scale = scale
        self.size = size
    }
}
