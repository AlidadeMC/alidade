//
//  MinecraftMapViewTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import MapKit
import SwiftUI
import Testing

@testable import CubiomesKit

@MainActor
struct MinecraftMapViewTests {
    @Test func mapViewInit() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let mcMapView = MinecraftMapView(world: mcWorld, frame: .zero)

        #expect(mcMapView.ornaments == [.compass])
        #expect(mcMapView.showsScale == false)
        #if os(macOS)
        #expect(mcMapView.showsPitchControl == false)
        #endif
        #expect(mcMapView.isPitchEnabled == false)
        #expect(mcMapView.isRotateEnabled == false)
    }

    @Test func mapViewDimensionChange() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let mcMapView = MinecraftMapView(world: mcWorld, frame: .zero)
        mcMapView.dimension = .end

        #expect(mcMapView.minecraftOverlay?.dimension == .end)
    }

    @Test func mapViewAnnotation() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let mcMapView = MinecraftMapView(world: mcWorld, frame: .zero)
        let annotationView = mcMapView.mapView(
            mcMapView,
            viewFor: MinecraftMapMarkerAnnotation(location: .zero, title: "Spawn")
        )
        
        #expect(annotationView != nil)
        #expect(annotationView is MKMarkerAnnotationView)
    }

    @Test func mapViewOverlayRenderer() throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 123)
        let mcMapView = MinecraftMapView(world: mcWorld, frame: .zero)

        let overlay = MinecraftRenderedTileOverlay(world: mcWorld)
        let renderer = mcMapView.mapView(mcMapView, rendererFor: overlay)
        #expect(renderer is MKTileOverlayRenderer)
    }

    @Test func mapViewCompareAnnotations() throws {
        let markerOne = MinecraftMapMarkerAnnotation(location: .zero, title: "Spawn")
        let markerTwo = MinecraftMapMarkerAnnotation(location: .zero, title: "Spawn")
        let markerThree = MKPointAnnotation()
        markerThree.title = "Spawn"
        markerThree.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        #expect(MinecraftMapView.compareAnnotations(markerOne, markerTwo) == true)
        #expect(MinecraftMapView.compareAnnotations(markerOne, markerThree) == true)
        #expect(MinecraftMapView.compareAnnotations(markerTwo, markerThree) == true)
    }
}
