//
//  MinecraftWorldRenderer.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 23-03-2025.
//

import CubiomesInternal
import Foundation

/// A facility used to render Minecraft worlds as two-dimensional maps.
public class MinecraftWorldRenderer {
    /// A structure representing the various options available to the renderer.
    public struct Options: OptionSet, Sendable {
        /// The underlying raw value representing the options selected.
        public let rawValue: Int

        /// Use natural colors for the overworld when rendering the map, instead of the default behavior.
        ///
        /// This color scheme is bundled in CubiomesKit. It aims to represent real Minecraft blocks, providing a more
        /// natural and consistent look with the Minecraft world.
        ///
        /// > SeeAlso: To view the source for the color set, visit
        /// > [https://github.com/Cubitect/biome-colors](https://github.com/Cubitect/biome-colors).
        public static let naturalColors = Options(rawValue: 1 << 0)

        /// Render the map with the position at the center of the image.
        public static let centerPositions = Options(rawValue: 1 << 1)

        /// Create an option set from a raw value.
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    private enum Constants {
        static let naturalColormap = "sampled_colormap_optimized"
    }

    var naturalColorFile: String? {
        guard let resourceURL = Bundle.module.url(forResource: Constants.naturalColormap, withExtension: "txt") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: resourceURL)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to fetch natural colors: \(error.localizedDescription)")
            return nil
        }
    }

    /// The options configuring this renderer.
    public var options: Options = [.centerPositions]

    var world: MinecraftWorld

    /// Create a renderer for a Minecraft world.
    /// - Parameter world: The Minecraft world the renderer will generate image slices from.
    public init(world: MinecraftWorld) {
        self.world = world
    }

    /// Renders a world region as raw image data.
    /// - Parameter rect: The region to render in the world.
    /// - Parameter pixelsPerCell: The number of pixels that occupy a single cell in the rendered image.
    /// - Parameter dimension: The dimension to render the region in.
    public func render(
        inRegion rect: MinecraftWorldRect,
        scale pixelsPerCell: Int32 = 4,
        dimension: MinecraftWorld.Dimension = .overworld
    ) -> Data {
        var generator = world.generator(in: dimension)
        var rangeX = rect.origin.x
        var rangeZ = rect.origin.z
        let size = rect.mapScale.rawValue

        if options.contains(.centerPositions) {
            rangeX = (rangeX - (pixelsPerCell * rect.size.length / 2)) / size
            rangeZ = (rangeZ - (pixelsPerCell * rect.size.width / 2)) / size
        }
        
        let _range = Range(
            scale: size,
            x: rangeX,
            z: rangeZ,
            sx: rect.size.length,
            sz: rect.size.width,
            y: rect.origin.y,
            sy: rect.size.height
        )

        let biomeIds = allocCache(&generator, _range)
        genBiomes(&generator, biomeIds, _range)

        let imgWidth = pixelsPerCell * _range.sx
        let imgHeight = pixelsPerCell * _range.sz

        var biomeColors: (UInt8, UInt8, UInt8) = (0, 0, 0)
        if options.contains(.naturalColors), let naturalColorFile, dimension == .overworld {
            parseBiomeColors(&biomeColors, naturalColorFile)
        } else {
            initBiomeColors(&biomeColors)
        }

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
