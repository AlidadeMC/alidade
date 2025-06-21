//
//  RedWindowSearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowSearchView: View {
    struct PinCreationRequest {
        var name = ""
        var position = CGPoint.zero
        var displayForm = false
    }

    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment
    @Binding var file: CartographyMapFile

    @State private var query = ""
    @State private var pinCreationRequest = PinCreationRequest()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack {
            CartographySearchView(
                file: file,
                position: MinecraftPoint(cgPoint: redWindowEnvironment.mapCenterCoordinate),
                dimension: redWindowEnvironment.currentDimension
            ) {
                initialView
            } results: { result in
                Group {
                    if result.isEmpty {
                        ContentUnavailableView.search(text: query)
                    } else {
                        resultList(for: result)
                    }
                }
            }
            .sheet(isPresented: $pinCreationRequest.displayForm) {
                NavigationStack {
                    PinCreatorForm(
                        location: pinCreationRequest.position,
                        initialName: pinCreationRequest.name
                    ) { newPin in
                        file.manifest.pins.append(newPin)
                    }
                }
            }
        }
    }

    private var initialView: some View {
        List {
            if let recentLocations = file.manifest.recentLocations {
                Section {
                    ForEach(recentLocations, id: \.self) { recent in
                        Label(recent.accessibilityReadout, systemImage: "location")
                            .onTapGesture {
                                redWindowEnvironment.mapCenterCoordinate = recent
                                redWindowEnvironment.currentRoute = .map
                            }
                            .contextMenu {
                                Button("Show on Map", systemImage: "location") {
                                    redWindowEnvironment.mapCenterCoordinate = recent
                                    redWindowEnvironment.currentRoute = .map
                                }
                            }
                    }
                } header: {
                    Text("Locations You've Visited")
                }
            }
        }
    }

    private func resultList(for result: CartographySearchService.SearchResult) -> some View {
        let currentLoc = redWindowEnvironment.mapCenterCoordinate
        return List {
            Section {
                ForEach(result.pins) { pin in
                    RedWindowSearchLandmarkResultCell(request: $pinCreationRequest, landmark: pin, landmarkType: .pin)
                }
                if result.pins.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            } header: {
                Text("Your Pinned Places")
            }
            Section {
                ForEach(result.biomes) { biome in
                    RedWindowSearchLandmarkResultCell(
                        request: $pinCreationRequest,
                        landmark: biome,
                        landmarkType: .biome
                    )
                }
                ForEach(result.structures) { structure in
                    RedWindowSearchLandmarkResultCell(
                        request: $pinCreationRequest,
                        landmark: structure,
                        landmarkType: .structure
                    )
                }
                if result.structures.isEmpty, result.biomes.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            } header: {
                Text("Biomes and Structures")
            } footer: {
                Text(
                    "Relative where you are on the map (\(currentLoc.accessibilityReadout))."
                )
            }
        }
    }
}
