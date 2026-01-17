//
//  RedWindowPinLibraryGridView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

/// A collection view that displays player-created pins in a grid layout.
///
/// Selecting a pin will inform the parent navigation view to open the child page for the pin. Additionally, a request
/// to delete a set of pins might be provided through the ``deletionRequest`` property.
struct RedWindowPinLibraryGridView: View {
    @Environment(\.tabBarPlacement) private var tabBarPlacement
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The parent navigation view's path.
    @Binding var navigationPath: NavigationPath

    /// The current pin deletion request.
    @Binding var deletionRequest: RedWindowPinDeletionRequest

    /// The file from which the pins originated from.
    var file: CartographyMapFile

    /// The collection of pins to display in the grid view.
    var pins: IndexedPinCollection

    /// The shared library namespace for navigation transitions.
    let namespace: Namespace.ID

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 180), spacing: 8)]
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(pins, id: \.content.self) { mapPin in
                    NavigationLink(value: RedWindowLibraryNavigationPath.pin(mapPin.content, index: mapPin.index)) {
                        RedWindowLibraryGridCell(pin: mapPin.content, file: file)
                            .matchedTransitionSource(id: mapPin.content, in: namespace)
                    }
                    .tint(.primary)
                    .buttonStyle(.plain)
                    .padding(2)
                    .contextMenu {
                        Button("Get Info", systemImage: "info.circle") {
                            navigationPath.append(
                                RedWindowLibraryNavigationPath.pin(mapPin.content, index: mapPin.index))
                        }
                        Button("Copy Coordinates", semanticIcon: .copy) {
                            Task {
                                let pasteboard = PasteboardActor()
                                await pasteboard.copy(mapPin.content.position)
                            }
                        }
                        Button("Remove", systemImage: "trash", role: .destructive) {
                            deletionRequest.elementIDs = [mapPin.index]
                            deletionRequest.presentAlert = true
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
