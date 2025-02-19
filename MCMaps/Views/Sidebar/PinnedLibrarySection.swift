//
//  PinnedLibrarySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

struct PinnedLibrarySection: View {
    var pins: [CartographyMapPin]
    @Binding var viewModel: CartographyMapViewModel
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

    func recolorPins(to color: CartographyMapPin.Color, where predicate: @escaping (CartographyMapPin) -> Bool) {
        for (index, pin) in file.map.pins.enumerated() where predicate(pin) {
            file.map.pins[index].color = color
        }
    }
}
