//
//  Point3D.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 04-02-2025.
//

import Foundation

/// A representation of a point in three-dimensional space.
///
/// - Note: To use a three-dimensional point that refers to a Minecraft coordinate, use the ``MinecraftPoint``.
public struct Point3D<T: Numeric & Sendable & Hashable>: Equatable, Hashable, Sendable {
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

    public func offset(by scalarValue: T, appliesToY: Bool = false) -> Self {
        Self(x: x + scalarValue, y: appliesToY ? y + scalarValue : y, z: z + scalarValue)
    }
}

extension Point3D where T == Int32 {
    public static let zero = Point3D<Int32>(x: 0, y: 0, z: 0)
}

extension Point3D where T == Int {
    public static let zero = Point3D<Int>(x: 0, y: 0, z: 0)
}
