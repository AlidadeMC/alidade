//
//  CoordinateProjections.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 07-04-2025.
//

import Foundation
import MapKit

enum CoordinateProjections {
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

        return CGPoint(x: location.longitude * scaleZ, y: -location.latitude * scaleX)
    }
}
