//
//  MapCommands.swift
//  Alidade
//
//  Created by Marquis Kurt on 18-01-2026.
//

import Foundation
import SwiftUI

/// A group of commands used to control the map in Alidade.
struct MapCommands: Commands {
    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue) private var naturalColors = true
    @AppStorage(UserDefaults.Keys.mapCoordinateIndicator.rawValue) private var showMapCoordinateIndicator = true
    @Bindable var redWindowEnvironment: RedWindowEnvironment

    init(environment: RedWindowEnvironment) {
        self.redWindowEnvironment = environment
    }

    var body: some Commands {
        CommandMenu("Map") {
            Button("Go To...", systemImage: "figure.walk") {
                redWindowEnvironment.currentModalRoute = .warpToLocation
            }
            .disabled(redWindowEnvironment.currentRoute != .map)
            .keyboardShortcut("G", modifiers: [.command])
            Button("Pin Here...", systemImage: "mappin.circle") {
                redWindowEnvironment.currentModalRoute = .createPin
            }
            .disabled(redWindowEnvironment.currentRoute != .map)
            .keyboardShortcut("P", modifiers: [.command])
            Divider()
            Toggle(isOn: $naturalColors) {
                Label("Natural Colors", systemImage: "paintpalette")
            }
            Section {
                Toggle(isOn: $showMapCoordinateIndicator) {
                    Label("Coordinate Indicator", systemImage: "location")
                }
            } header: {
                Text("Ornaments")
            }
            WorldDimensionPickerView(selection: $redWindowEnvironment.currentDimension)
                .labelsVisibility(.visible)
        }
    }
}
