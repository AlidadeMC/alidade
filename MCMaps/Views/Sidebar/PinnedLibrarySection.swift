//
//  PinnedLibrarySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

/// A section used to display player-created pins in a sidebar.
///
/// This is normally invoked from ``CartographyMapSidebar`` and is almost never instantiated on its own.
struct PinnedLibrarySection: View {
    /// The player-created pins to display.
    var pins: [CartographyMapPin]

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    @Binding var file: CartographyMapFile

    var body: some View {
        Section("Library") {
            ForEach(Array(pins.enumerated()), id: \.element) { (idx: Int, pin: CartographyMapPin) in
                NavigationLink(value: CartographyRoute.pin(idx, pin: pin)) {
                    CartographyNamedLocationView(pin: pin)
                        .tag(CartographyRoute.pin(idx, pin: pin))
                }.buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        #if os(macOS)
                            Button {
                                viewModel.currentRoute = .pin(idx, pin: pin)
                            } label: {
                                Label("Get Info", systemImage: "info.circle")
                            }
                        #endif
                        Menu("Color", systemImage: "paintpalette") {
                            ForEach(CartographyMapPin.Color.allCases, id: \.self) { pinColor in
                                Button {
                                    recolorPins(to: pinColor) { realPin in
                                        realPin.name == pin.name && realPin.position == pin.position
                                    }
                                } label: {
                                    Text("\(pinColor)".localizedCapitalized)
                                        .foregroundStyle(pinColor.swiftUIColor)
                                        .tint(pinColor.swiftUIColor)
                                }
                            }
                        }
                    }
                    #if os(iOS)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    #endif
            }
        }
    }

    private func recolorPins(
        to color: CartographyMapPin.Color,
        where predicate: @escaping (CartographyMapPin) -> Bool
    ) {
        for (index, pin) in file.map.pins.enumerated() where predicate(pin) {
            file.map.pins[index].color = color
        }
    }
}
