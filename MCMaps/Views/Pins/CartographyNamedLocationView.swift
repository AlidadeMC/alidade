//
//  CartographyNamedLocationView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import SwiftUI

struct CartographyNamedLocationView: View {
    enum DisplayMode {
        case absolute, relative(CGPoint)
    }
    private var coordinateDisplayMode = DisplayMode.absolute
    var name: String
    var location: CGPoint
    var systemImage: String
    var color: Color

    fileprivate init(
        name: String,
        location: CGPoint,
        systemImage: String,
        color: Color,
        displayMode: DisplayMode
    ) {
        self.name = name
        self.location = location
        self.systemImage = systemImage
        self.color = color
        self.coordinateDisplayMode = displayMode
    }

    init(name: String, location: CGPoint, systemImage: String, color: Color) {
        self.name = name
        self.location = location
        self.systemImage = systemImage
        self.color = color
    }

    init(pin: CartographyMapPin) {
        self.name = pin.name
        self.location = pin.position
        self.color = pin.color?.swiftUIColor ?? .accent
        self.systemImage = "mappin"
    }

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundStyle(.white)
                .padding(6)
                .background(Circle().fill(color))
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(coordinateDisplayText)
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
        }
    }

    private var coordinateDisplayText: String {
        switch coordinateDisplayMode {
        case .absolute:
            return String(localized: "(\(Int(location.x)), \(Int(location.y)))")
        case .relative(let cGPoint):
            let distance = location.manhattanDistance(to: cGPoint)
            return String(localized: "\(Int(distance)) blocks away")
        }
    }
}

extension CartographyNamedLocationView {
    func coordinateDisplayMode(_ displayMode: Self.DisplayMode) -> Self {
        CartographyNamedLocationView(
            name: self.name,
            location: self.location,
            systemImage: self.systemImage,
            color: self.color,
            displayMode: displayMode
        )
    }
}
