//
//  Pin.swift
//  MCMaps
//
//  Created by Marquis Kurt on 03-02-2025.
//

import SwiftUI

struct CartographyMapPin: Codable, Hashable {
    enum Color: String, Codable, Hashable, CaseIterable {
        case red, orange, yellow, green, blue, indigo, brown, gray, pink

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
    var position: CGPoint
    var name: String
    var color: Color? = .blue
}
