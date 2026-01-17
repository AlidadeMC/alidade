//
//  LibraryOnboardingTip.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import TipKit

/// A tip that encourages players to search for content through the library.
struct LibraryOnboardingTip: Tip {
    var options: [Option] {
        MaxDisplayCount(3)
    }

    var title: Text {
        Text("Browse and search your library.")
    }

    var message: Text? {
        Text("Use the search bar to look through your pins, or to locate nearby structures and biomes.")
    }
}
