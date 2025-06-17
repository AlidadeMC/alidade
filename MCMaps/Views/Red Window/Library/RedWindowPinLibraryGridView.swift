//
//  RedWindowPinLibraryGridView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinLibraryGridView: View {
    @Environment(\.tabBarPlacement) private var tabBarPlacement
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var pins: [MCMapManifestPin]

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: preferredColumnCount)
    }

    private var preferredColumnCount: Int {
        if horizontalSizeClass == .compact { return 2 }
        if tabBarPlacement == .sidebar { return 4 }
        return 5
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(pins, id: \.self) { mapPin in
                    NavigationLink(value: LibraryNavigationPath.pin(mapPin)) {
                        cell(for: mapPin)
                    }
                    .tint(.primary)
                }
                .padding(.horizontal)
            }
        }
        .animation(.interactiveSpring, value: preferredColumnCount)
    }

    private func cell(for pin: MCMapManifestPin) -> some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(pin.color?.swiftUIColor ?? .accent).gradient)
                .frame(height: 125)
                .overlay {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            Text(pin.name)
                .lineLimit(1)
                .font(.headline)
                .foregroundStyle(.primary)
            Text("(\(pin.position.accessibilityReadout))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
