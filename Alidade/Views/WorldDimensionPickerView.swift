//
//  WorldDimensionPickerView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

/// A picker view used to select a Minecraft world dimension.
///
/// The picker exposes a SwiftUI `Picker` type, so any additional picker modifiers will apply. On macOS, this is
/// displayed as an inline menu.
struct WorldDimensionPickerView: View {
    /// The selection representing the world dimension.
    @Binding var selection: MinecraftWorld.Dimension

    var body: some View {
        Picker("Dimension", selection: $selection) {
            Label("Overworld", semanticIcon: .overworld)
                .tag(MinecraftWorld.Dimension.overworld)
            Label("Nether", semanticIcon: .nether)
                .tag(MinecraftWorld.Dimension.nether)
            Label("End", semanticIcon: .end)
                .tag(MinecraftWorld.Dimension.end)
        }
    }
}

/// A picker view used to select a Minecraft world dimension in relation to a pin's location.
///
/// The picker exposes a SwiftUI `Picker` type, so any additional picker modifiers will apply. On macOS, this is
/// displayed as an inline menu.
struct WorldCodedDimensionPicker: View {
    /// The selection representing the world dimension.
    @Binding var selection: CartographyMapPin.Dimension

    var body: some View {
        Picker("Dimension", selection: $selection) {
            Label("Overworld", semanticIcon: .overworld)
                .tag(CartographyMapPin.Dimension.overworld)
            Label("Nether", semanticIcon: .nether)
                .tag(CartographyMapPin.Dimension.nether)
            Label("End", semanticIcon: .end)
                .tag(CartographyMapPin.Dimension.end)
        }
    }
}
