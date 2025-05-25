//
//  NamedLocationView.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI

/// A view that displays a location with a specified name.
///
/// Named location views are commonly used to display locations that have an associated name, such as a player-created
/// pin or a search result for a structure. Named locations can also specify a color and display mode that changes how
/// the coordinate is displayed on screen.
public struct NamedLocationView: View {
    /// An enumeration representing the different display modes for the coordinate portion of a named location view.
    public enum CoordinateDisplayMode {
        /// Display the coordinate in absolute terms (e.g., `(10, 10)`).
        case absolute
        /// Display the coordinate relative to another coordinate (e.g., `32 blocks away`).
        /// - Parameter other: The coordinate to get the relative distance of.
        case relative(CGPoint)
    }

    var coordinateDisplayMode = CoordinateDisplayMode.absolute
    var name: String
    var location: CGPoint
    var systemImage: String
    var color: Color

    init(
        name: String,
        location: CGPoint,
        systemImage: String,
        color: Color,
        displayMode: CoordinateDisplayMode
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
    public init(name: String, location: CGPoint, systemImage: String = "mappin", color: Color = .accentColor) {
        self.name = name
        self.location = location
        self.systemImage = systemImage
        self.color = color
    }

    public var body: some View {
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

extension NamedLocationView {
    /// Sets the coordinate's display mode.
    /// - Parameter displayMode: The display mode to use when displaying the coordinate.
    public func coordinateDisplayMode(_ displayMode: Self.CoordinateDisplayMode) -> Self {
        NamedLocationView(
            name: self.name,
            location: self.location,
            systemImage: self.systemImage,
            color: self.color,
            displayMode: displayMode
        )
    }
}

#Preview {
    Form {
        Section {
            NamedLocationView(name: "Spawn Point", location: .zero)
        } header: {
            Text("Named Location")
        }
        Section {
            NamedLocationView(name: "Spawn Point", location: .zero, systemImage: "tent", color: .green)
        } header: {
            Text("Named Location, Custom Icon and Color")
        }
        Section {
            NamedLocationView(name: "Spawn Point", location: .zero)
                .coordinateDisplayMode(.relative(CGPoint(x: 1847, y: 1847)))
        } header: {
            Text("Named Location, Relative Coordinates")
        }
    }
    #if os(macOS)
        .formStyle(.grouped)
    #endif
}

#if DEBUG
    extension NamedLocationView {
        var testHooks: TestHooks { TestHooks(target: self) }

        struct TestHooks {
            private let target: NamedLocationView

            fileprivate init(target: NamedLocationView) {
                self.target = target
            }

            var name: String { target.name }
            var location: CGPoint { target.location }
            var color: Color { target.color }
            var systemImage: String { target.systemImage }
        }
    }
#endif

