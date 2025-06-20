//
//  RedWindowPinLibraryGridView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinLibraryGridView: View {
    @Environment(\.tabBarPlacement) private var tabBarPlacement
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var navigationPath: NavigationPath
    @Binding var deletionRequest: RedWindowPinDeletionRequest

    var file: CartographyMapFile
    var pins: IndexedPinCollection
    let namespace: Namespace.ID

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 180), spacing: 8)]
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(pins, id: \.content.self) { mapPin in
                    NavigationLink(value: LibraryNavigationPath.pin(mapPin.content, index: mapPin.index)) {
                        RedWindowLibraryGridCell(pin: mapPin.content, file: file)
                            .matchedTransitionSource(id: mapPin.content, in: namespace)
                    }
                    .tint(.primary)
                    .buttonStyle(.plain)
                    .padding(2)
                    .contextMenu {
                        Button("Get Info", systemImage: "info.circle") {
                            navigationPath.append(LibraryNavigationPath.pin(mapPin.content, index: mapPin.index))
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
