//
//  CartographyMinecraftMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-04-2025.
//

import CubiomesKit
import MapKit
import SwiftUI

#if canImport(AppKit)
    struct CartographyMinecraftMap: NSViewRepresentable {
        typealias UIViewType = CartographyMinecraftMapInternalView

        var world: MinecraftWorld

        func makeNSView(context: Context) -> CartographyMinecraftMapInternalView {
            return CartographyMinecraftMapInternalView(world: world)
        }

        func updateNSView(_ nsView: CartographyMinecraftMapInternalView, context: Context) {

        }
    }
#endif

#if canImport(UIKit)
    struct CartographyMinecraftMap: UIViewRepresentable {
        typealias UIViewType = CartographyMinecraftMapInternalView

        var world: MinecraftWorld

        func makeUIView(context: Context) -> CartographyMinecraftMapInternalView {
            return CartographyMinecraftMapInternalView(world: world)
        }

        func updateUIView(_ nsView: CartographyMinecraftMapInternalView, context: Context) {

        }
    }
#endif

final class CartographyMinecraftMapInternalView: MKMapView {
    var world: MinecraftWorld

    init(world: MinecraftWorld) {
        self.world = world

        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.configureMapView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureMapView() {
        self.showsCompass = true
        self.isPitchEnabled = false
        self.showsScale = true
        self.showsZoomControls = true
        self.isZoomEnabled = true
        self.isRotateEnabled = true
        self.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 64,
            maxCenterCoordinateDistance: 512)
        self.canDrawConcurrently = true
        self.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        let overlay = MinecraftRenderedTileOverlay(world: world)
        addOverlay(overlay, level: .aboveLabels)

        let spawnAnnotation = MKPointAnnotation()
        spawnAnnotation.title = "Spawn"
        spawnAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        addAnnotation(spawnAnnotation)
    }
}

extension CartographyMinecraftMapInternalView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        return switch overlay {
        case let overlay as MKTileOverlay:
            MKTileOverlayRenderer(overlay: overlay)
        default:
            MKOverlayRenderer(overlay: overlay)
        }
    }
}
