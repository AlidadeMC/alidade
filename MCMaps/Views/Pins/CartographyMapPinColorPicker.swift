//
//  CartographyMapPinColorPicker.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import SwiftUI

/// A picker used to pick a color used in a player-created pin.
///
/// The picker is displayed as a row of colors. The selected color will have a small white fill, similar to a radio
/// button.
struct CartographyMapPinColorPicker: View {
    private enum Constants {
        static let pinHeightMultiplier = 2.5
        #if os(macOS)
            static let pinColorSize = 20.0
        #else
            static let pinColorSize = 28.0
        #endif
    }

    /// The color the picker will select.
    @Binding var color: CartographyMapPin.Color?

    var body: some View {
        ForEach(CartographyMapPin.Color.allCases, id: \.self) { pinColor in
            Button {
                color = pinColor
            } label: {
                Circle().fill(pinColor.swiftUIColor.gradient)
                    .frame(width: Constants.pinColorSize, height: Constants.pinColorSize)
                    .overlay {
                        if color == pinColor {
                            Circle()
                                .fill(Color.white)
                                .frame(
                                    width: Constants.pinColorSize / Constants.pinHeightMultiplier,
                                    height: Constants.pinColorSize / Constants.pinHeightMultiplier
                                )
                        }
                    }
                    .accessibilityValue("Selected", isEnabled: color == pinColor)
            }
            .tag(pinColor)
            .help(String(describing: pinColor).localizedCapitalized)
            .accessibilityLabel(String(describing: pinColor).localizedCapitalized)
        }
        .buttonStyle(.plain)
    }
}
