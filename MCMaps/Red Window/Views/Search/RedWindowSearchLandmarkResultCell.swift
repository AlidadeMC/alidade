//
//  RedWindowSearchLandmarkResultCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 20-06-2025.
//

import CubiomesKit
import MCMapFormat
import SwiftUI

struct RedWindowSearchLandmarkResultCell: View {
    enum LandmarkType {
        case biome, structure, pin

        var symbol: String {
            switch self {
            case .biome: "mountain.2"
            case .structure: "building.2.crop.circle"
            case .pin: "mappin"
            }
        }
    }
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    @Binding var request: RedWindowSearchView.PinCreationRequest

    var landmark: MCMapManifestPin
    var landmarkType: LandmarkType

    var body: some View {
        Label {
            Text(landmark.name)
            Text(landmark.position.accessibilityReadout)
                .foregroundStyle(.secondary)
        } icon: {
            Image(systemName: landmarkType.symbol)
                .foregroundStyle(landmark.color?.swiftUIColor ?? .accent)
        }
        .onTapGesture {
            redWindowEnvironment.mapCenterCoordinate = landmark.position
            redWindowEnvironment.currentRoute = .map
        }
        .contextMenu {
            Button("Show on Map", systemImage: "location") {
                redWindowEnvironment.mapCenterCoordinate = landmark.position
                redWindowEnvironment.currentRoute = .map
            }
            if landmarkType != .pin {
                Button("Create Pin", systemImage: "mappin") {
                    request.position = landmark.position
                    request.name = landmark.name
                    request.displayForm = true
                }
            } else {
                Button("Get Info", systemImage: "info.circle") {
                    redWindowEnvironment.currentRoute = .pin(landmark)
                }
            }
        }
    }
}
