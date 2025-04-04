//
//  MinecraftMap.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

/// A map view of a Minecraft world that can be navigated and interacted with.
public struct MinecraftMap {
    public typealias Ornaments = MinecraftMapView.Ornaments

    var world: MinecraftWorld

    var centerCoordinate: Binding<CGPoint>?
    var dimension: MinecraftWorld.Dimension = .overworld
    var ornaments: Ornaments = []
    var annotations: [any MKAnnotation] = []

    public init(
        world: MinecraftWorld,
        centerCoordinate: Binding<CGPoint>? = nil,
        dimension: MinecraftWorld.Dimension = .overworld
    ) {
        self.world = world
        self.dimension = dimension
        self.centerCoordinate = centerCoordinate
    }

    init(
        world: MinecraftWorld,
        centerCoordinate: Binding<CGPoint>? = nil,
        ornaments: Ornaments = [],
        annotations: [any MKAnnotation] = [],
        dimension: MinecraftWorld.Dimension = .overworld
    ) {
        self.world = world
        self.ornaments = ornaments
        self.centerCoordinate = centerCoordinate
        self.dimension = dimension
        self.annotations = annotations
    }

    @MainActor
    func createMapView() -> MinecraftMapView {
        let mapView = MinecraftMapView(world: world, frame: .zero)
        mapView.ornaments = ornaments
        mapView.dimension = dimension
        if let centerBlockCoordinate = centerCoordinate?.wrappedValue {
            mapView.centerBlockCoordinate = centerBlockCoordinate
        }
        mapView.addAnnotations(annotations)
        return mapView
    }

    @MainActor
    func updateMapView(_ mapView: MinecraftMapView) {
        mapView.ornaments = ornaments
        mapView.dimension = dimension
        if let centerBlockCoordinate = centerCoordinate?.wrappedValue {
            mapView.centerBlockCoordinate = centerBlockCoordinate
        }
        for marker in annotations {
            if !mapView.annotations.contains(where: { MinecraftMapView.compareAnnotations($0, marker) }) {
                mapView.addAnnotation(marker)
            }
        }

        for annotation in mapView.annotations where annotation is MinecraftMapMarkerAnnotation {
            guard let annotation = annotation as? MinecraftMapMarkerAnnotation else { continue }
            if !annotations.contains(where: { MinecraftMapView.compareAnnotations($0, annotation) }) {
                mapView.removeAnnotation(annotation)
            }
        }
    }

    /// Determines the map control ornaments that should be displayed on the map.
    public func ornaments(_ ornaments: Ornaments) -> MinecraftMap {
        MinecraftMap(
            world: self.world,
            centerCoordinate: self.centerCoordinate,
            ornaments: ornaments,
            annotations: self.annotations,
            dimension: self.dimension
        )
    }

    /// Displays annotations on top of the map.
    public func annotations(@MinecraftMapContentBuilder _ builder: () -> [any MKAnnotation]) -> MinecraftMap {
        MinecraftMap(
            world: self.world, centerCoordinate: self.centerCoordinate, ornaments: self.ornaments,
            annotations: builder(), dimension: self.dimension)
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
