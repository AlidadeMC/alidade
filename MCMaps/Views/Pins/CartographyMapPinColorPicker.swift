//
//  CartographyMapPinColorPicker.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import AlidadeUI
import SwiftUI

/// A picker used to pick a color used in a player-created pin.
///
/// The picker is displayed as a row of colors. The selected color will have a small white fill, similar to a radio
/// button.
///
/// Internally, this wraps the finite color picker view from AlidadeUI, keeping track of the color selection to
/// back-propagate the color value to the pin.
struct CartographyMapPinColorPicker: View {
    /// The color the picker will select.
    @Binding var color: MCMapManifestPin.Color?
    @State private var swiftUIColor = Color.blue

    var availableColors: [Color] {
        MCMapManifestPin.Color.allCases.map(\.swiftUIColor)
    }

    var body: some View {
        FiniteColorPicker("", selection: $swiftUIColor, in: availableColors)
            .onChange(of: swiftUIColor) { _, newValue in
                for suiColor in MCMapManifest.Pin.Color.allCases where suiColor.swiftUIColor == newValue {
                    color = suiColor
                    return
                }
            }
    }
}
