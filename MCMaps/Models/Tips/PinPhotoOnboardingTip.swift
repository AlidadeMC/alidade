//
//  PinPhotoOnboardingTip.swift
//  MCMaps
//
//  Created by Marquis Kurt on 22-03-2025.
//

import SwiftUI
import TipKit

struct PinPhotoOnboardingTip: Tip {
    var options: [Option] {
        [MaxDisplayCount(3)]
    }

    var title: Text {
        Text("Make it memorable.")
    }

    var message: Text? {
        Text("Add photos of your world to make this pin memorable.")
    }

    var image: Image? {
        Image(systemName: "photo.badge.plus")
    }
}
