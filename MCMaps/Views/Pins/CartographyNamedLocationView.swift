//
//  CartographyNamedLocationView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import SwiftUI

/// A view that displays a location with a specified name.
///
/// Named location views are commonly used to display locations that have an associated name, such as a player-created
/// pin or a search result for a structure. Named locations can also specify a color and display mode that changes how
/// the coordinate is displayed on screen.
struct CartographyNamedLocationView: View {
    /// An enumeration representing the different display modes for the coordinate portion of a named location view.
    enum DisplayMode {
        /// Display the coordinate in absolute terms (e.g., `(10, 10)`).
        case absolute
        /// Display the coordinate relative to another coordinate (e.g., `32 blocks away`).
        /// - Parameter other: The coordinate to get the relative distance of.
        case relative(CGPoint)
    }
    private var coordinateDisplayMode = DisplayMode.absolute
    private var name: String
    private var location: CGPoint
    private var systemImage: String
    private var color: Color

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

    /// Create a named location view.
    /// - Parameter name: The name to give to the location.
    /// - Parameter location: The location to be displayed.
    /// - Parameter systemImage: The SF Symbol to display in the label.
    /// - Parameter color: The named location view's color.
    init(name: String, location: CGPoint, systemImage: String, color: Color) {
        self.name = name
        self.location = location
        self.systemImage = systemImage
        self.color = color
    }

    /// Create a named location view using a player-created pin.
    /// - Parameter pin: The pin to create a named location view from.
    init(pin: MCMapManifestPin) {
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(name), \(location.accessibilityReadout)")
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
    /// Sets the coordinate's display mode.
    /// - Parameter displayMode: The display mode to use when displaying the coordinate.
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

#if DEBUG
    extension CartographyNamedLocationView {
        var testHooks: TestHooks { TestHooks(target: self) }

        struct TestHooks {
            private let target: CartographyNamedLocationView

            fileprivate init(target: CartographyNamedLocationView) {
                self.target = target
            }

            var name: String { target.name }
            var location: CGPoint { target.location }
            var color: Color { target.color }
            var systemImage: String { target.systemImage }
        }
    }
#endif
