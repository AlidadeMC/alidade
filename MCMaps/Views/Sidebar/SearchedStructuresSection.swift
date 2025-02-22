//
//  SearchedStructuresSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import CubiomesKit
import SwiftUI

/// A section used to display structures that are being searched for.
///
/// This is normally invoked from ``CartographyMapSidebar`` and is almost never instantiated on its own.
struct SearchedStructuresSection: View {
    /// The structures from the search results.
    var structures: [CartographyMapPin]

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    ///
    /// Notably, the sidebar content will read from recent locations and the player-created pins.
    @Binding var file: CartographyMapFile

    /// A completion handler that executes when the player has jumped to a structure.
    var jumpedToStructure: ((CartographyMapPin) -> Void)?

    var body: some View {
        Section("Structures") {
            ForEach(structures, id: \.self) { pin in
                CartographyNamedLocationView(pin: pin)
                    .coordinateDisplayMode(
                        .relative(
                            CGPoint(
                                x: Double(viewModel.worldRange.position.x),
                                y: Double(viewModel.worldRange.position.z)))
                    )
                    .onTapGesture {
                        viewModel.go(to: pin.position, relativeTo: file)
                        jumpedToStructure?(pin)
                    }
                    .contextMenu {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                            jumpedToStructure?(pin)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        Button {
                            viewModel.currentRoute = .createPin(pin.position)
                        } label: {
                            Label("Pin...", systemImage: "mappin")
                        }
                    }
                    #if os(iOS)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    #endif
            }
        }
    }
}
