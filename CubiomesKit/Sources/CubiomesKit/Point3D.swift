//
//  Point3D.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 04-02-2025.
//

import Foundation

/// A representation of a point in three-dimensional space.
public struct Point3D<T: Numeric & Sendable>: Equatable, Sendable {
    /// The position coordinate along the X axis.
    public var x: T

    /// The position coordinate along the Y axis.
    public var y: T

    /// The position coordinate along the Z axis.
    public var z: T

    public init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Create a point from a two-dimensional coordinate.
    public init(cgPoint: CGPoint) where T == Int {
        self.x = Int(cgPoint.x)
        self.y = 1
        self.z = Int(cgPoint.y)
    }

    /// Create a point from a two-dimensional coordinate.
    public init(cgPoint: CGPoint) where T == Int32 {
        self.x = Int32(cgPoint.x)
        self.y = 1
        self.z = Int32(cgPoint.y)
    }
}
