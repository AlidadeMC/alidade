//
//  WorldDimensionPickerView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import CubiomesKit
import SwiftUI

struct WorldDimensionPickerView: View {
    @Binding var selection: MinecraftWorld.Dimension

    var body: some View {
        Picker("Dimension", selection: $selection) {
            Label("Overworld", systemImage: "tree")
                .tag(MinecraftWorld.Dimension.overworld)
            Label("Nether", systemImage: "flame")
                .tag(MinecraftWorld.Dimension.nether)
            Label("End", systemImage: "sparkles")
                .tag(MinecraftWorld.Dimension.end)
        }
    }
}
