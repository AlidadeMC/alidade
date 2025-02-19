//
//  Data+PPM.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import Foundation

/// A structure for representing data in the portable pixmap format.
public struct PPMData {
    /// The array of pixels contained in the image.
    public var pixels: [CUnsignedChar]

    /// The image's size.
    public var size: CGSize

    /// Creates a PPM data type from an array of pixels with a given size.
    public init(pixels: [CUnsignedChar], size: CGSize) {
        self.pixels = pixels
        self.size = size
    }
}

extension Data {
    /// Initializes a data object from a PPM data block.
    public init(ppm: PPMData) {
        let header = "P6\n\(Int(ppm.size.width)) \(Int(ppm.size.height))\n255\n"
        var newData = Data(header.utf8)
        newData.append(contentsOf: ppm.pixels)
        self = newData
    }
}
