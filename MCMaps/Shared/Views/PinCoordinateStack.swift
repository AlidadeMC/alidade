//
//  PinCoordinateStack.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-08-2025.
//

import MCMap
import SwiftUI

struct PinCoordinateStack: View {
    var pin: CartographyMapPin

    var body: some View {
        ViewThatFits {
            HStack { labels }
            VStack(alignment: .leading) {
                labels
            }
        }
        .fontDesign(.monospaced)
    }

    private var labels: some View {
        Group {
            Label("(\(pin.position.accessibilityReadout))", semanticIcon: symbol(for: pin.dimension))
                .help(
                    "Location in \(pin.dimension.rawValue.localizedCapitalized): \(pin.position.accessibilityReadout)"
                )
                .accessibilityLabel("Location in " + pin.dimension.rawValue.localizedCapitalized)
                .accessibilityValue(pin.position.accessibilityReadout)
            Label("(\(pairing.accessibilityReadout))", semanticIcon: symbol(for: pairedDimension))
                .help(
                    "Location in \(pairedDimension.rawValue.localizedCapitalized): \(pairing.accessibilityReadout)"
                )
                .accessibilityLabel("Location in " + pairedDimension.rawValue.localizedCapitalized)
                .accessibilityValue(pairing.accessibilityReadout)
        }
    }

    func symbol(for dimension: CartographyMapPin.Dimension) -> SemanticIcon {
        return switch dimension {
        case .overworld: .overworld
        case .nether: .nether
        case .end: .end
        }
    }

    var pairing: CGPoint {
        var paired = pin.position
        switch pin.dimension {
        case .overworld:
            paired = CGPoint(x: paired.x / 8, y: paired.y / 8)
        case .nether:
            paired = CGPoint(x: paired.x * 8, y: paired.y * 8)
        case .end:
            break
        }
        return paired
    }

    var pairedDimension: CartographyMapPin.Dimension {
        switch pin.dimension {
        case .overworld:
            return .nether
        case .nether:
            return .overworld
        case .end:
            return .end
        }
    }
}
