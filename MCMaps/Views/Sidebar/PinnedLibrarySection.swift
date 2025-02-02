//
//  PinnedLibrarySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

struct PinnedLibrarySection: View {
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile

    var body: some View {
        Section("Library") {
            ForEach(viewModel.filterPinsByQuery(pins: file.map.pins), id: \.self) { (pin: Pin) in
                CartographyMapPinView(pin: pin)
                    .onTapGesture {
                        viewModel
                            .goTo(position: pin.position, seed: file.map.seed, mcVersion: file.map.mcVersion)
                    }
                    .contextMenu {
                        Button {
                            viewModel
                                .goTo(position: pin.position, seed: file.map.seed, mcVersion: file.map.mcVersion)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        Menu("Color", systemImage: "paintpalette") {
                            ForEach(Pin.Color.allCases, id: \.self) { pinColor in
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
    
    func recolorPins(to color: Pin.Color, where predicate: @escaping (Pin) -> Bool) {
        for (index, pin) in file.map.pins.enumerated() where predicate(pin) {
            file.map.pins[index].color = color
        }
    }
}
