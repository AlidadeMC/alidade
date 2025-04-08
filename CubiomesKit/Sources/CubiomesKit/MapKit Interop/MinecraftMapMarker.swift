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
/// Markers are generally used to indicate points of interest on a Minecraft world map. Tapping on a marker will
/// display its coordinate below as a subtitle.
public struct MinecraftMapMarker: MinecraftMapAnnotation {
    /// The location of the marker in blocks.
    public var location: CGPoint

    /// The marker's tint color as it appears on the map.
    public var color: Color

    /// The name of the marker.
    public var title: String

    /// Create a marker at a given position.
    /// - Parameter location: The Minecraft coordinate where the marker will be placed.
    /// - Parameter title: The name of the marker.
    /// - Parameter color: The marker's tint color.
    public init(location: CGPoint, title: String, color: Color = .accentColor) {
        self.location = location
        self.title = title
        self.color = color
    }

    public var mapKitAnnotation: any MKAnnotation {
        MinecraftMapMarkerAnnotation(marker: self)
    }
}

public class MinecraftMapMarkerAnnotation: NSObject, MKAnnotation {
    public private(set) var coordinate: CLLocationCoordinate2D
    #if canImport(UIKit)
        var color: UIColor
    #else
        var color: NSColor
    #endif
    public var title: String?

    public private(set) var subtitle: String?

    public init(marker: MinecraftMapMarker) {
        self.coordinate = CoordinateProjections.project(marker.location)
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

    public init(location: CGPoint, title: String, color: Color = .accentColor) {
        self.coordinate = CoordinateProjections.project(location)
        self.title = title

        let xCoord = Int(location.x)
        let zCoord = Int(location.y)
        self.subtitle = "(\(xCoord), \(zCoord))"
        #if canImport(UIKit)
            self.color = UIColor(color)
        #else
            self.color = NSColor(color)
        #endif
    }

    @available(*, deprecated, renamed: "CoordinateProjections.project")
    static func project(_ minecraftLocation: CGPoint) -> CLLocationCoordinate2D {
        let mineZ = minecraftLocation.y
        let mineX = minecraftLocation.x

        // NOTE(alicerunsonfedora): WTF is this magic voodoo shit? Shouldn't scaleX be 90 instead? I don't understand
        // projections... (but dear reader, let me project my woes onto you)
        let scaleZ = 45 / Double(MinecraftRenderedTileOverlay.Constants.maxBoundary)
        let scaleX = 45 / Double(MinecraftRenderedTileOverlay.Constants.maxBoundary)

        return CLLocationCoordinate2D(latitude: -mineZ * scaleZ, longitude: mineX * scaleX)
    }

    @available(*, deprecated, renamed: "CoordinateProjections.unproject")
    static func unproject(_ location: CLLocationCoordinate2D) -> CGPoint {
        let scaleZ = Double(MinecraftRenderedTileOverlay.Constants.maxBoundary) / 45
        let scaleX = Double(MinecraftRenderedTileOverlay.Constants.maxBoundary) / 45

        return CGPoint(x: location.longitude * scaleZ, y: -location.latitude * scaleX)
    }
}
