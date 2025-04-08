//
//  MinecraftWorldRange.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import Foundation

/// A structure that defines a rectangular frame or slice in a Minecraft world.
public struct MinecraftWorldRect: Sendable {
    /// A structure that defines a size in three-dimensional space.
    public struct Size: Equatable, Hashable, Sendable {
        /// The size's length along the X axis.
        public var length: Int32

        /// The size's width along the Z axis.
        public var width: Int32

        /// The size's height (along the Y axis).
        public var height: Int32

        public init(length: Int32, width: Int32, height: Int32) {
            self.length = length
            self.width = width
            self.height = height
        }

        public init(squaring tileSize: Int32, height: Int32 = 1) {
            self.length = tileSize
            self.width = tileSize
            self.height = height
        }
    }

    /// An enumeration of the Minecraft map scales available.
    public enum Scale: Int32, Sendable {
        case xSmall = 1
        case small = 4
        case medium = 16
        case large = 64
        case xLarge = 256
    }

    /// The origin or reference point of the rectangle.
    public var origin: MinecraftPoint

    /// The size or volume of the rectangle.
    public var size: Size

    /// The scale of the map.
    ///
    /// This is generally used for rendering purposes, but it does not affect the rectangle itself.
    public var mapScale: Scale

    /// Creates a world rectangle.
    /// - Parameter origin: The origin or reference point of the rectangle.
    /// - Parameter scale: The scale or volume of the rectangle.
    /// - Parameter mapScale: The scale of the map.
    public init(origin: MinecraftPoint, scale: Size, mapScale: Scale = .small) {
        self.origin = origin
        self.size = scale
        self.mapScale = mapScale
    }
}
