//
//  WorldDimensionPickerTip.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import TipKit

/// A tip that encourages players to switch between world dimensions.
struct WorldDimensionPickerTip: Tip {
    static let viewDisplayed = Event(id: "dimensionpicker.displayed")

    var options: [Option] {
        MaxDisplayCount(5)
    }

    var rules: [Rule] {
        #Rule(Self.viewDisplayed) {
            $0.donations.count >= 7
        }
    }

    var title: Text {
        Text("Switch between dimensions.")
    }

    var message: Text? {
        Text("View maps of the Overworld, the Nether, and the End easily.")
    }

    var image: Image? {
        Image(systemName: "map")
    }
}
