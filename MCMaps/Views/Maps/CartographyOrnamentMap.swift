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

    var body: some View {
        OrnamentedView {
            CartographyMapView(world: try? MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed))
                .animation(.interpolatingSpring, value: viewModel.mapState)
                .edgesIgnoringSafeArea(.all)
                .background(Color.gray)
        } ornaments: {
            Ornament(alignment: Constants.locationBadgePlacement) {
                VStack(alignment: .trailing) {
//                    LocationBadge(location: viewModel.worldRange.position)
                    #if os(iOS)
                        Menu {
                            Toggle(isOn: $viewModel.renderNaturalColors) {
                                Label("Natural Colors", systemImage: "paintpalette")
                            }
                            WorldDimensionPickerView(selection: $viewModel.worldDimension)
                                .pickerStyle(.inline)
                        } label: {
                            Label("Dimension", systemImage: "map")
                        }
                        .labelStyle(.iconOnly)
                        .padding()
                        .foregroundStyle(.primary)
                        .background(.thinMaterial)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 8))
                        .padding(.trailing, 6)
                        .popoverTip(LocalTips.dimensionPicker)
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
