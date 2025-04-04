//
//  DirectionNavigatorTip.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import TipKit

/// A tip that describes to players how to use the direction navigator wheel.
///
/// This tip is generally displayed if the player hasn't touched the direction navigator wheel since launching the app,
/// and the view has appeared a few times. This tip shouldn't be displayed more than three times, naturally dismissing
/// itself afterwards.
///
/// Ideally, this tip should be displayed as a popover to the direction navigator wheel.
@available(*, deprecated, message: "Use the native controls in MinecraftMap.")
struct DirectionNavigatorTip: Tip {
    static let viewDisplayed = Event(id: "navigator.displayed")

    var options: [Option] {
        MaxDisplayCount(3)
    }

    var rules: [Rule] {
        #Rule(Self.viewDisplayed) {
            $0.donations.count >= 5
        }
    }

    var title: Text {
        Text("Move around the map.")
    }

    var message: Text? {
        #if os(macOS)
        Text("Tap any of the arrows or press Command with any arrow key to move around the map.")
        #else
        Text("Tap any of the arrows to move around the map.")
        #endif
    }

    var image: Image? {
        Image(systemName: "figure.walk")
    }
}
