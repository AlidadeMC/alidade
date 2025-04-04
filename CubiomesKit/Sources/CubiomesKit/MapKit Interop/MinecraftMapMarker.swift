//
//  MinecraftMapMarker.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

/// A marker on a Minecraft map.
///
/// Markers are generally used to indicate points of interest on a Minecraft world map.
public struct MinecraftMapMarker {
    /// The location of the marker in blocks.
    public var location: CGPoint

    public var color: Color

    /// The name of the marker.
    public var title: String


    public init(location: CGPoint, title: String, color: Color = .accentColor) {
        self.location = location
        self.title = title
        self.color = color
    }
}

class MinecraftMapMarkerAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    #if canImport(UIKit)
        var color: UIColor
    #else
        var color: NSColor
    #endif
    var title: String?
    var subtitle: String?

    init(marker: MinecraftMapMarker) {
        self.coordinate = Self.project(marker.location)
        self.title = marker.title

        let xCoord = Int(marker.location.x)
        let zCoord = Int(marker.location.y)
        self.subtitle = "(\(xCoord), \(zCoord))"
        #if canImport(UIKit)
            self.color = UIColor(marker.color)
        #else
            self.color = NSColor(marker.color)
        #endif
    }

    static func project(_ minecraftLocation: CGPoint) -> CLLocationCoordinate2D {
        // NOTE: The implementation of this has been pulled from the Terra121 project and assumes projections are
        // similar.
        //
        // x = latitude * 10^5
        // z = longitude * 10^5
        //
        // See also: https://github.com/orangeadam3/terra121/blob/master/CALCULATECOORDS.md
        CLLocationCoordinate2D(latitude: -minecraftLocation.y / 100_000, longitude: minecraftLocation.x / 100_000)
    }

    static func unproject(_ location: CLLocationCoordinate2D) -> CGPoint {
        CGPoint(x: location.latitude * 100_000, y: location.longitude * 100_000)
    }
}
