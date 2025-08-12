//
//  RedWindowSearchLandmarkResultCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 20-06-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

/// A cell that displays a landmark for a search result.
///
/// Tapping on the result will move to the map to the specified landmark. Additional context menu options are available
/// for more actions, such as creating a pin from the location.
struct RedWindowSearchLandmarkResultCell: View {
    /// An enumeration of the landmark types available to the cell.
    enum LandmarkType {
        /// The landmark represents a Minecraft biome.
        case biome

        /// The landmark represents a Minecraft structure.
        case structure

        /// The landmark represents a player-created pin.
        case pin

        /// The landmark represents a pin pulled from integrations.
        case integratedPin

        /// A symbol representation for the landmark.
        var symbol: String {
            switch self {
            case .biome: "mountain.2"
            case .structure: "building.2.crop.circle"
            case .pin, .integratedPin: "mappin"
            }
        }
    }
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The request to create a pin.
    @Binding var request: RedWindowSearchView.PinCreationRequest

    /// The landmark that will be represented in the cell.
    var landmark: CartographyMapPin

    /// The type of the landmark being represented in the cell.
    var landmarkType: LandmarkType

    var body: some View {
        Label {
            Text(landmark.name)
            Text(landmark.position.accessibilityReadout)
                .foregroundStyle(.secondary)
        } icon: {
            Image(
                systemName: landmarkType == .pin
                    ? landmark.icon?.resolveSFSymbol(in: .pin) ?? "mappin"
                    : landmarkType.symbol
            )
            .foregroundStyle(landmark.color?.swiftUIColor ?? .accent)
        }
        .onTapGesture {
            redWindowEnvironment.mapCenterCoordinate = landmark.position
            redWindowEnvironment.currentRoute = .map
        }
        .contextMenu {
            Button("Go Here", systemImage: "location") {
                redWindowEnvironment.mapCenterCoordinate = landmark.position
                redWindowEnvironment.currentRoute = .map
            }
            Button("Copy Coordinates", systemImage: "document.on.document") {
                Task {
                    let pasteboard = PasteboardActor()
                    await pasteboard.copy(landmark.position)
                }
            }
            if landmarkType != .pin {
                Button("Create Pin", systemImage: "mappin") {
                    request.position = landmark.position
                    request.name = landmark.name
                    if landmarkType == .integratedPin {
                        request.alternateIDs = landmark.alternateIDs
                    }
                    request.displayForm = true
                }
            } else {
                Button("Get Info", systemImage: "info.circle") {
                    redWindowEnvironment.currentRoute = .pin(landmark.id)
                }
            }
        }
    }
}
