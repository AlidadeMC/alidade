//
//  CartographyMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

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
            switch state {
            case .loading:
                ProgressView()
            case .success(let data):
                Image(data: data)?.resizable()
                    .interpolation(.none)
                    .scaledToFill()
                    .zoomable()
                    .accessibilityElement()
            case .unavailable:
                ContentUnavailableView("No Map Available", systemImage: "map")
            }
        }
    }
}
