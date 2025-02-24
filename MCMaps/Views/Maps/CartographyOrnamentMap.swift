//
//  CartographyOrnamentMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//

import SwiftUI

/// An ornament used to display content on top of a map.
///
/// - Important: This view has been renamed to the general ``Ornament`` view.
@available(*, deprecated, renamed: "Ornament")
typealias MapOrnament = Ornament

/// A map view with various ornaments placed on top.
///
/// The ornament map displays the regular map while having various ornaments on top, such as the location badge,
/// direction navigator wheel, and dimension picker. On iOS and iPadOS, tapping the map will show or hide these
/// ornaments.
struct CartographyOrnamentMap: View {
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
            CartographyMapView(state: viewModel.mapState)
                .animation(.interpolatingSpring, value: viewModel.mapState)
                .edgesIgnoringSafeArea(.all)
        } ornaments: {
            MapOrnament(alignment: Constants.navigatorWheelPlacement) {
                DirectionNavigator(viewModel: viewModel, file: file)
            }
            .padding(.trailing, 8)
            .padding(.bottom, horizontalSizeClass == .compact ? 116 : 8)
            MapOrnament(alignment: Constants.locationBadgePlacement) {
                VStack(alignment: .trailing) {
                    LocationBadge(location: viewModel.worldRange.position)
                    #if os(iOS)
                        Menu {
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
                    #endif
                }
            }
            .padding(.trailing, 8)
        }
    }
}
