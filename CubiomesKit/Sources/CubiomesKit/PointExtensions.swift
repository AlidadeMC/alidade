//
//  PointExtensions.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 07-04-2025.
//

import Foundation
import MapKit

/// A representation of a Minecraft world coordinate in three-dimensional space.
///
/// The X and Z values refer to the positions along a two-dimensional plane, while the Y value refers to the position
/// along the vertical axis.
public typealias MinecraftPoint = CubiomesKit.Point3D<Int32>

extension CGPoint {
    /// Initialize a CGPoint with an existing Minecraft coordinate.
    ///
    /// The X value of the Minecraft coordinate maps to the X value of the CGPoint, while the Z value of the Minecraft
    /// coordinate maps to the Y value of the CGPoint.
    ///
    /// - Parameter minecraftPoint: The Minecraft world coordinate to convert from.
    public init(minecraftPoint: MinecraftPoint) {
        self.init(x: Double(minecraftPoint.x), y: Double(minecraftPoint.z))
    }

    /// Initialize a CGPoint, performing a reverse projection of a Core Location coordinate.
    ///
    /// It is assumed this Core Location coordinate will cleanly be un-projected to a Minecraft world coordinate, where
    /// the latitude and longitude will map to X and Z values, respectively.
    ///
    /// - Parameter coordinate: The Core Location coordinate to un-project.
    public init(projectedFrom coordinate: CLLocationCoordinate2D) {
        self = CoordinateProjections.unproject(coordinate)
    }
}

extension CLLocationCoordinate2D {
    /// Initializes a Core Location coordinate by projecting a CGPoint representing a Minecraft coordinate.
    ///
    /// - Parameter minecraftCoordinate: The Minecraft coordinate to project into a Core Location coordinate.
    public init(projecting minecraftCoordinate: CGPoint) {
        self = CoordinateProjections.project(minecraftCoordinate)
    }
}

extension MinecraftPoint {
    /// Initialize a Point3D, performing a reverse projection of a Core Location coordinate.
    ///
    /// It is assumed this Core Location coordinate will cleanly be un-projected to a Minecraft world coordinate, where
    /// the latitude and longitude will map to X and Z values, respectively.
    ///
    /// > Note: This initializer assumed the Core Location coordinate corresponds to a value in the Minecraft
    /// > overworld, so a default Y value of `15` is provided.
    ///
    /// - Parameter coordinate: The Core Location coordinate to un-project.
    public init(projectedFrom coordinate: CLLocationCoordinate2D) {
        let cgPoint = CoordinateProjections.unproject(coordinate)
        self.x = Int32(cgPoint.x)
        self.y = 15
        self.z = Int32(cgPoint.y)
    }
}
