//
//  CartographyMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import Foundation
import SwiftUI

struct Pin: Codable, Hashable {
    enum Color: Codable, Hashable, CaseIterable {
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

struct CartographyMap: Codable, Hashable {
    var seed: Int64
    var mcVersion: String
    var name: String
    var pins: [Pin]
    var recentLocations: [CGPoint]? = []
}
