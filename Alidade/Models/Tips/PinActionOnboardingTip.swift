//
//  PinActionOnboardingTip.swift
//  MCMaps
//
//  Created by Marquis Kurt on 29-03-2025.
//

import SwiftUI
import TipKit

/// A tip that encourages players to pin commonly visited locations.
struct PinActionOnboardingTip: Tip {
    static let libraryEmpty = Event(id: "library.emptyPins")

    var rules: [Rule] {
        #Rule(Self.libraryEmpty) {
            $0.donations.count >= 3
        }
    }

    var options: [Option] {
        MaxDisplayCount(3)
    }

    var title: Text {
        Text("Pin a location.")
    }

    var message: Text? {
        #if os(macOS)
            Text("Swipe or right click on a recent location to add it to your library.")
        #else
            Text("Swipe or tap and hold on a recent location to add it to your library.")
        #endif
    }
}
