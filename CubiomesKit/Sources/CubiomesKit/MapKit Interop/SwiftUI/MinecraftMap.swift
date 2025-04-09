//
//  MinecraftMap.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

/// A map view of a Minecraft world that can be navigated and interacted with.
///
/// This map view supports typical map interactions such as panning and zooming while displaying content from a
/// Minecraft world. Tiles are dynamically loaded in with a ``MinecraftWorldRenderer``.
///
/// - SeeAlso: For use in AppKit/UIKit views, use the ``MinecraftMapView``.
public struct MinecraftMap {
    /// A type alias representing the map's ornaments displayed in the view above the map's content.
    public typealias Ornaments = MinecraftMapView.Ornaments

    /// An enumeration representing the various color schemes available to the map.
    public enum ColorScheme {
        /// The default color scheme.
        ///
        /// This color scheme is automatically provided by Cubiomes and uses the same color scheme for biomes as other
        /// tools, such as Chunkbase, Amidst, and MineAtlas.
        case `default`

        /// The natural color scheme.
        ///
        /// This color scheme is bundled in CubiomesKit. It aims to represent real Minecraft blocks, providing a more
        /// natural and consistent look with the Minecraft world.
        case natural
    }

    var world: MinecraftWorld

    var centerCoordinate: Binding<CGPoint>?
    var dimension: MinecraftWorld.Dimension = .overworld
    var ornaments: Ornaments = []
    var annotations: [any MinecraftMapContent] = []
    var preferNaturalColors: Bool = false

    /// Create a Minecraft map view.
    /// - Parameter world: The world to display in the map view.
    /// - Parameter centerCoordinate: The coordinate that should be in the center of the map view.
    /// - Parameter dimension: The dimension to view the world in.
    public init(
        world: MinecraftWorld,
        centerCoordinate: Binding<CGPoint>? = nil,
        dimension: MinecraftWorld.Dimension = .overworld
    ) {
        self.world = world
        self.dimension = dimension
        self.centerCoordinate = centerCoordinate
    }

    /// Create a Minecraft map view with additional annotations.
    /// - Parameter world: The world to display in the map view.
    /// - Parameter centerCoordinate: The coordinate that should be in the center of the map view.
    /// - Parameter dimension: The dimension to view the world in.
    /// - Parameter annotations: The annotations that should be displayed in the world.
    public init(
        world: MinecraftWorld,
        centerCoordinate: Binding<CGPoint>? = nil,
        dimension: MinecraftWorld.Dimension = .overworld,
        @MinecraftMapContentBuilder annotations: () -> [any MinecraftMapContent]
    ) {
        self.world = world
        self.dimension = dimension
        self.centerCoordinate = centerCoordinate
        self.annotations = annotations()
    }

    init(
        world: MinecraftWorld,
        centerCoordinate: Binding<CGPoint>? = nil,
        ornaments: Ornaments = [],
        annotations: [any MinecraftMapContent] = [],
        dimension: MinecraftWorld.Dimension = .overworld,
        preferNaturalColors: Bool = false
    ) {
        self.world = world
        self.ornaments = ornaments
        self.centerCoordinate = centerCoordinate
        self.dimension = dimension
        self.annotations = annotations
        self.preferNaturalColors = preferNaturalColors
    }

    @MainActor
    func createMapView() -> MinecraftMapView {
        let mapView = MinecraftMapView(world: world, frame: .zero)
        mapView.ornaments = ornaments
        mapView.dimension = dimension
        if let centerBlockCoordinate = centerCoordinate?.wrappedValue {
            mapView.centerBlockCoordinate = centerBlockCoordinate
        }
        mapView.addMapContents(annotations)
        if preferNaturalColors {
            mapView.renderOptions.insert(.naturalColors)
        } else {
            mapView.renderOptions.remove(.naturalColors)
        }
        return mapView
    }

    @MainActor
    func updateMapView(_ mapView: MinecraftMapView) {
        mapView.ornaments = ornaments
        mapView.dimension = dimension
        if let centerBlockCoordinate = centerCoordinate?.wrappedValue {
            mapView.centerBlockCoordinate = centerBlockCoordinate
        }
        mapView.resyncMapContent(annotations)

        if preferNaturalColors {
            mapView.renderOptions.insert(.naturalColors)
        } else {
            mapView.renderOptions.remove(.naturalColors)
        }
    }

    /// Determines the map control ornaments that should be displayed on the map.
    public func ornaments(_ ornaments: Ornaments) -> MinecraftMap {
        MinecraftMap(
            world: self.world,
            centerCoordinate: self.centerCoordinate,
            ornaments: ornaments,
            annotations: self.annotations,
            dimension: self.dimension,
            preferNaturalColors: self.preferNaturalColors
        )
    }

    /// Specify the color scheme to be used in the map view.
    /// - Parameter colorScheme: The color scheme to use in the map view.
    public func mapColorScheme(_ colorScheme: MinecraftMap.ColorScheme) -> MinecraftMap {
        MinecraftMap(
            world: self.world,
            centerCoordinate: self.centerCoordinate,
            ornaments: self.ornaments,
            annotations: self.annotations,
            dimension: self.dimension,
            preferNaturalColors: colorScheme == .natural
        )
    }
}

// MARK: - View Representable Conformance

#if canImport(AppKit)
    extension MinecraftMap: NSViewRepresentable {
        public typealias UIViewType = MinecraftMapView

        public func makeNSView(context: Context) -> MinecraftMapView {
            createMapView()
        }

        public func updateNSView(_ nsView: MinecraftMapView, context: Context) {
            updateMapView(nsView)
        }
    }
#endif

#if canImport(UIKit)
    extension MinecraftMap: UIViewRepresentable {
        public typealias UIViewType = MinecraftMapView

        public func makeUIView(context: Context) -> MinecraftMapView {
            createMapView()
        }

        public func updateUIView(_ uiView: MinecraftMapView, context: Context) {
            updateMapView(uiView)
        }
    }
#endif
