//
//  RecentLocationsListSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

/// A section used to display recently visited locations.
///
/// This is normally invoked from ``CartographyMapSidebar`` and is almost never instantiated on its own.
struct RecentLocationsListSection: View {
    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    @Binding var file: CartographyMapFile

    private var recentLocations: [CGPoint] {
        file.manifest.recentLocations ?? []
    }

    /// A handler that executes when the player has requested to go to a specific location.
    var goToPosition: ((CGPoint) -> Void)?

    var body: some View {
        Section("Recents") {
            ForEach(Array(recentLocations.enumerated().reversed()), id: \.offset) { (idx, pos) in
                CartographyNamedLocationView(
                    name: "Location",
                    location: pos,
                    systemImage: "location.fill",
                    color: .gray
                )
                .accessibilityAddTraits(.isButton)
                .tag(CartographyRoute.recent(pos))
                .swipeActions(edge: .leading) {
                    createPinButton(for: pos)
                    .tint(.accentColor)
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        file.manifest.recentLocations?.remove(at: idx)
                    } label: {
                        Label("Remove from Recents", systemImage: "trash")
                    }
                    .tint(.red)
                }
                #if os(iOS)
                    .onTapGesture {
                        goToPosition?(pos)
                    }
                #endif
                .contextMenu {
                    createPinButton(for: pos)
                    Button {
                        goToPosition?(pos)
                    } label: {
                        Label("Go Here", systemImage: "location")
                    }
                    Button("Remove from Recents", role: .destructive) {
                        file.manifest.recentLocations?.remove(at: idx)
                    }
                }
                #if os(iOS)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                #endif
            }
            .onDelete { indexSet in
                file.manifest.recentLocations?.remove(atOffsets: indexSet)
            }
        }
    }

    private func createPinButton(for position: CGPoint) -> some View {
        Group {
            #if os(iOS)
                NavigationLink(value: CartographyRoute.createPin(position)) {
                    Label("Pin...", systemImage: "mappin")
                }
            #else
                Button {
                    viewModel.currentRoute = .createPin(position)
                } label: {
                    Label("Pin...", systemImage: "mappin")
                }
            #endif
        }
    }
}
