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
/// not be loaded.
struct CartographyMapView: View {
    /// The view's loading state.
    var state: CartographyMapViewState

    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView()
            case .success(let data):
                VStack {
                    Image(data: data)?.resizable()
                        .scaledToFill()
                }
            case .unavailable:
                ContentUnavailableView("No Map Available", systemImage: "map")
            }
        }
    }
}
