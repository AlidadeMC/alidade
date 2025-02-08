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
            ForEach(pins, id: \.self) { (pin: CartographyMapPin) in
                CartographyNamedLocationView(pin: pin)
                    .onTapGesture {
                        viewModel.go(to: pin.position, relativeTo: file)
                    }
                    .contextMenu {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
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
