//
//  MinecraftMapContentBuilder.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

/// A Minecraft map annotation that can be displayed in map views.
///
/// This protocol provides the basic building blocks for Minecraft map annotations built with the
/// ``MinecraftMapContentBuilder``.
public protocol MinecraftMapAnnotation {
    /// The underlying MapKit annotation representation.
    var mapKitAnnotation: any MKAnnotation { get }
}

/// A content builder used to generate Minecraft-based map annotations for map views.
///
/// This is typically used to generate corresponding `MKAnnotation` annotations for ``MinecraftMapView`` or other
/// MapKit views. The ``MinecraftMap`` view, for example, uses this allow creating annotations inline with its
/// initializer:
///
/// ```swift
/// var myMap: some View {
///     MinecraftMap(world: ...) {
///         MinecraftMarker(location: CGPoint(...), title: "My Base")
///
///         if isNether {
///             MinecraftMarker(location: ..., title: "Nether Farm")
///         }
///     }
/// }
/// ```
@resultBuilder
public struct MinecraftMapContentBuilder {
    public static func buildArray(_ components: [[MinecraftMapAnnotation]]) -> [any MKAnnotation] {
        components.flatMap { $0.map(\.mapKitAnnotation) }
    }

    public static func buildBlock(_ components: MinecraftMapAnnotation...) -> [any MKAnnotation] {
        components.map(\.mapKitAnnotation)
    }

    public static func buildBlock(_ components: [MinecraftMapAnnotation]...) -> [any MKAnnotation] {
        components.flatMap { $0.map(\.mapKitAnnotation) }
    }

    public static func buildEither(first component: MinecraftMapAnnotation) -> [any MKAnnotation] {
        [component.mapKitAnnotation]
    }

    public static func buildEither(second component: MinecraftMapAnnotation) -> [any MKAnnotation] {
        [component.mapKitAnnotation]
    }
}
