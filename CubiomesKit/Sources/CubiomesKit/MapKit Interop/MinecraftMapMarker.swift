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
        let mineZ = minecraftLocation.y
        let mineX = minecraftLocation.x

        // NOTE(alicerunsonfedora): WTF is this magic voodoo shit? Shouldn't scaleX be 90 instead? I don't understand
        // projections... (but dear reader, let me project my woes onto you)
        let scaleZ = 45 / Double(MinecraftRenderedTileOverlay.Constants.maxBoundary)
        let scaleX = 45 / Double(MinecraftRenderedTileOverlay.Constants.maxBoundary)
        
        return CLLocationCoordinate2D(latitude: -mineZ * scaleZ, longitude: mineX * scaleX)
    }

    static func unproject(_ location: CLLocationCoordinate2D) -> CGPoint {
        let scaleZ = Double(MinecraftRenderedTileOverlay.Constants.maxBoundary) / 45
        let scaleX = Double(MinecraftRenderedTileOverlay.Constants.maxBoundary) / 45
        
        return CGPoint(x: -location.latitude * scaleZ, y: location.longitude * scaleX)
    }
}
