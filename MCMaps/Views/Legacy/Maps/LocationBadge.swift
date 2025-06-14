//
//  LocationBadge.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import SwiftUI

/// A badge used to display a location as an ornament.
///
/// The location badge will display a coordinate differently, depending on the location type provided. For a `CGPoint`,
/// the X and Y values are used, with the Y coordinate mapping to the Z coordinate. For a `Point3D`, only the X and Z
/// coordinates are used.
///
/// Placement of the location badge varies by platform. On macOS, this badge typically resides in the bottom leading
/// corner of the map view. On iOS and iPadOS, this might appear elsewhere, such as the top edge.
struct LocationBadge: View {
    @FeatureFlagged(.redWindow) private var useRedWindowDesign
    
    /// The location the badge is displaying.
    var location: CGPoint

    private var locationLabel: String {
        let xPos = String(Int(location.x))
        let yPos = String(Int(location.y))

        return "X: \(xPos), Z: \(yPos)"
    }

    /// Creates a location badge for a given point.
    /// - Parameter location: The location the badge will display.
    init(location: CGPoint) {
        self.location = location
    }

    /// Creates a location badge for a given point.
    /// - Parameter location: The location the badge will display.
    init(location: Point3D<Int32>) {
        self.location = CGPoint(x: Double(location.x), y: Double(location.z))
    }

    var body: some View {
        HStack {
            Label(locationLabel, systemImage: "location.fill")
                .padding(2)
                .padding(.vertical, 1)
                .padding(.horizontal, 4)
                .contentTransition(.numericText(value: location.x))
                .contentTransition(.numericText(value: location.y))
        }
        .if(useRedWindowDesign) { view in
            Group {
                if #available(macOS 16, iOS 19, *) {
                    view.glassEffect()
                } else {
                    view.background(Capsule().fill(.thinMaterial))
                }
            }
        } `else`: { view in
           view.background(Capsule().fill(.thinMaterial))
        }
        .padding(8)
        .animation(.default, value: location)
    }
}

#Preview {
    Group {
        LocationBadge(location: CGPoint(x: 99, y: 99))
    }
    .background(Color.blue)

}

#if DEBUG
    extension LocationBadge {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: LocationBadge

            fileprivate init(target: LocationBadge) {
                self.target = target
            }

            var locationLabel: String {
                target.locationLabel
            }
        }
    }
#endif
