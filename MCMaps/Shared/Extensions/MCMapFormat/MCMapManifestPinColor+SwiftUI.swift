//
//  MCMapManifestPinColor+SwiftUI.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-06-2025.
//

import MCMapFormat
import SwiftUI

extension MCMapManifestPin.Color {
    /// A SwiftUI color that matches the given color.
    var swiftUIColor: SwiftUI.Color {
        switch self {
        case .red:
            .red
        case .orange:
            .orange
        case .yellow:
            .yellow
        case .green:
            .green
        case .blue:
            .blue
        case .indigo:
            .indigo
        case .brown:
            .brown
        case .gray:
            .gray
        case .pink:
            .pink
        }
    }
}
