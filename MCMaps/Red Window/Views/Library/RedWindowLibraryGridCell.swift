//
//  RedWindowLibraryGridCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMap
import SwiftUI

/// A cell for the ``RedWindowPinLibraryView`` using the grid layout.
///
/// This cell type shows a card of the pin and its corresponding images, along with information at the bottom for the
/// pin's name and coordinates.
///
/// > Note: This cell view type does not trigger any actions on its own. Rather, behaviors are handled in the parent
/// > grid view.
struct RedWindowLibraryGridCell: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The pin being displayed in the current cell.
    var pin: MCMapManifestPin

    /// The file from which the pin and images originated from.
    var file: CartographyMapFile

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if let coverImage {
                    ZStack {
                        Rectangle()
                            .fill(Color(pin.color?.swiftUIColor ?? .accent).gradient)
                        Image(data: coverImage)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                            .blendMode(.multiply)
                    }
                } else {
                    Rectangle()
                        .fill(Color(pin.color?.swiftUIColor ?? .accent).gradient)
                }
            }
            .frame(width: horizontalSizeClass == .compact ? 150 : 180, height: 125)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
        .animation(.default, value: horizontalSizeClass)
    }

    private var coverImage: Data? {
        guard let cover = pin.images?.first else { return nil }
        return file.images[cover]
    }
}
