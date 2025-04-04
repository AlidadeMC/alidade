//
//  CartographyMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import CubiomesKit
import SwiftUI

/// An enumeration for the different map view states.
@available(*, deprecated, message: "This will be removed in a future version of Alidade.")
enum CartographyMapViewState: Equatable {
    /// The map is currently loading.
    case loading

    /// The map was successfully generated.
    /// - Parameter data: The image data to be displayed on screen.
    case success(Data)

    /// The map data is unavailable, either from no selection or an error.
    case unavailable
}

/// A view that displays a Minecraft world map.
///
/// This view is designed to handle dynamic loading of the image, displaying an unavailable message when the map could
/// not be loaded. When the map is available and displayed, players can zoom and pan around the map to inspect it more
/// closely through pinching to zoom and dragging to pan. On macOS, the pointer will change to display zooming in and
/// out, along with dragging.
@available(*, deprecated, message: "Use the MinecraftMap view from CubiomesKit.")
struct CartographyMapView: View {
    var world: MinecraftWorld?
    var dimension: MinecraftWorld.Dimension = .overworld

    var body: some View {
        Group {
            if let world {
                MinecraftMap(world: world, dimension: dimension)
                    .ornaments(.all)
                    .annotations {
                        MinecraftMapMarker(location: .zero, title: "Spawn")
                        MinecraftMapMarker(
                            location: CGPoint(x: 64, y: 64),
                            title: "Foobar",
                            color: .blue
                        )
                        MinecraftMapMarker(location: CGPoint(x: 14, y: 14), title: "Baz")
                    }
            }
        }
    }
}
