//
//  CartographyOrnamentMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//

import CubiomesKit
import SwiftUI
import TipKit

/// A map view with various ornaments placed on top.
///
/// The ornament map displays the regular map while having various ornaments on top, such as the location badge,
/// direction navigator wheel, and dimension picker. On iOS and iPadOS, tapping the map will show or hide these
/// ornaments.
struct CartographyOrnamentMap: View {
    private enum LocalTips {
        static let dimensionPicker = WorldDimensionPickerTip()
    }

    private enum Constants {
        #if os(macOS)
            static let locationBadgePlacement = Alignment.bottomLeading
        #else
            static let locationBadgePlacement = Alignment.topTrailing
        #endif

        static let navigatorWheelPlacement = Alignment.bottomTrailing
    }
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The view model the map will read from/write to.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the map will read from/write to.
    @Binding var file: CartographyMapFile

    @State private var centerCoordinate = CGPoint.zero

    var markers: [MinecraftMapMarker] {
        file.map.pins.map { pin in
            MinecraftMapMarker(
                location: pin.position,
                title: pin.name,
                color: pin.color?.swiftUIColor ?? Color.accentColor
            )
        }
    }

    var body: some View {
        OrnamentedView {
            Group {
                if let world = try? MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed) {
                    MinecraftMap(world: world, centerCoordinate: $centerCoordinate, dimension: viewModel.worldDimension)
                        .ornaments(.all)
                        .annotations {
                            markers
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.gray)
            .onChange(of: viewModel.worldRange.position) { _, newValue in
                centerCoordinate = CGPoint(x: Double(newValue.x), y: Double(newValue.z))
            }
        } ornaments: {
            Ornament(alignment: Constants.locationBadgePlacement) {
                VStack(alignment: .trailing) {
                    LocationBadge(location: viewModel.worldRange.position)
                    #if os(iOS)
                        HStack {
                            Menu {
                                Toggle(isOn: $viewModel.renderNaturalColors) {
                                    Label("Natural Colors", systemImage: "paintpalette")
                                }
                                WorldDimensionPickerView(selection: $viewModel.worldDimension)
                                    .pickerStyle(.inline)
                            } label: {
                                Label("Dimension", systemImage: "map")
                            }
                            .popoverTip(LocalTips.dimensionPicker)
                            .ornamentButton()
                        }
                        .labelStyle(.iconOnly)
                        .padding(.trailing, 6)
                        .onChange(of: viewModel.worldDimension) { _, _ in
                            LocalTips.dimensionPicker.invalidate(reason: .actionPerformed)
                        }
                    #endif
                }
            }
            .padding(.trailing, 8)
        }
    }
}

private struct OrnamentButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.primary)
            .background(.thinMaterial)
            .clipped()
            .clipShape(.rect(cornerRadius: 8))
    }
}

extension View {
    fileprivate func ornamentButton() -> some View {
        self.modifier(OrnamentButtonModifier())
    }
}
