//
//  MinecraftMapContentBuilder.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

@resultBuilder
public struct MinecraftMapContentBuilder {
    public static func buildArray(_ components: [[MinecraftMapMarker]]) -> [any MKAnnotation] {
        components.flatMap { $0.map(MinecraftMapMarkerAnnotation.init) }
    }

    public static func buildBlock(_ components: MinecraftMapMarker...) -> [any MKAnnotation] {
        components.map(MinecraftMapMarkerAnnotation.init)
    }

    public static func buildBlock(_ components: [MinecraftMapMarker]...) -> [any MKAnnotation] {
        components.flatMap { $0.map(MinecraftMapMarkerAnnotation.init) }
    }
}
