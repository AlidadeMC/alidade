//
//  MinecraftMarkerTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 05-04-2025.
//

import MapKit
import SwiftUI
import Testing

@testable import CubiomesKit

struct MinecraftMarkerTests {
    @Test func markerInit() async throws {
        let marker = Marker(location: .zero, title: "Spawn", color: .blue)
        let annotation = MinecraftMapMarkerAnnotation(marker: marker)

        #expect(annotation.title == "Spawn")
        #expect(annotation.coordinate == CLLocationCoordinate2D(latitude: 0, longitude: 0))
        #expect(annotation.subtitle == "(0, 0)")

        #if canImport(AppKit)
            #expect(annotation.color == NSColor(Color.blue))
        #else
            #expect(annotation.color == UIColor(Color.blue))
        #endif

        let manualAnnotation = MinecraftMapMarkerAnnotation(location: .zero, title: "Spawn", color: .blue)
        #expect(manualAnnotation.title == "Spawn")
        #expect(manualAnnotation.coordinate == CLLocationCoordinate2D(latitude: 0, longitude: 0))
        #expect(manualAnnotation.subtitle == "(0, 0)")

        #if canImport(AppKit)
            #expect(manualAnnotation.color == NSColor(Color.blue))
        #else
            #expect(manualAnnotation.color == UIColor(Color.blue))
        #endif
    }

    // NOTE(alicerunsonfedora): Still don't understand this voodoo shit, but it checks out visually, so the tests are
    // here to make sure it's in place...
    @Test func markerProjection() async throws {
        let blockCoordinate = CGPoint(x: -1670, y: 1493)
        let clCoordinate = CoordinateProjections.project(blockCoordinate)

        #expect(clCoordinate.latitude == -0.0020022690296173096)
        #expect(clCoordinate.longitude == -0.0022396445274353027)
    }

    @Test func markerUnprojection() async throws {
        let coord = CLLocationCoordinate2D(latitude: -0.0020022690296173096, longitude: -0.0022396445274353027)
        let blockCoordinate = CoordinateProjections.unproject(coord)

        #expect(blockCoordinate == CGPoint(x: -1670.0, y: 1493.0))
    }
}
