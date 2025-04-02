//
//  CartographyMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import CubiomesKit
import MapKit
import SwiftUI

/// An enumeration for the different map view states.
enum CartographyMapViewState: Equatable {
    /// The map is currently loading.
    case loading

    /// The map was successfully generated.
    /// - Parameter data: The image data to be displayed on screen.
    case success(Data)

    /// The map data is unavailable, either from no selection or an error.
    case unavailable
}

// NOTE(alicerunsonfedora): Eventually we should be able to display pins here.

/// A view that displays a Minecraft world map.
///
/// This view is designed to handle dynamic loading of the image, displaying an unavailable message when the map could
/// not be loaded. When the map is available and displayed, players can zoom and pan around the map to inspect it more
/// closely through pinching to zoom and dragging to pan. On macOS, the pointer will change to display zooming in and
/// out, along with dragging.
struct CartographyMapView: View {
    /// The view's loading state.
    var state: CartographyMapViewState

    var body: some View {
        Group {
            if let world {
                MapKitView(world: world)
            }
        }
    }

    var world: MinecraftWorld? {
        try? MinecraftWorld(version: "1.21", seed: 123)
    }
}

private struct MapKitView: NSViewRepresentable {
    typealias NSViewType = MKMapView

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            return switch overlay {
            case let overlay as MKCircle:
                MKCircleRenderer(circle: overlay)
            case let overlay as MKTileOverlay:
                MKTileOverlayRenderer(tileOverlay: overlay)
            default:
                MKOverlayRenderer(overlay: overlay)
            }
        }
    }

    var world: MinecraftWorld

    func makeNSView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.showsCompass = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = context.coordinator
        view.isPitchEnabled = false
        view.showsScale = true
        view.showsZoomControls = true
        view.isRotateEnabled = true
        view.cameraZoomRange = .init(maxCenterCoordinateDistance: 1000)
        view.canDrawConcurrently = true

        let overlay = MinecraftRenderedTileOverlay(world: world)
        view.addOverlay(overlay, level: .aboveLabels)

        return view
    }

    func updateNSView(_ nsView: MKMapView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}
