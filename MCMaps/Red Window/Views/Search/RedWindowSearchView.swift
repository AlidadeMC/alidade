//
//  RedWindowSearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

/// A view that allows players to search their Minecraft world and pins.
///
/// This view wraps around the shared ``CartographySearchView``, pushing it into a dedicated search tab accessible from
/// anywhere.
struct RedWindowSearchView: View {
    /// A structure used to construct a request to create a pin.
    struct PinCreationRequest {
        /// The suggested name for the pin being created.
        var name = ""

        /// The pin's suggested location.
        var position = CGPoint.zero

        /// The proposed alternate IDs for this pin.
        var alternateIDs: Set<String>?

        /// Whether the form should be displayed.
        var displayForm = false
    }

    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The file that will be searched through.
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
                        var transformedPin = newPin
                        transformedPin.alternateIDs = pinCreationRequest.alternateIDs
                        file.pins.append(transformedPin)
                    }
                    #if os(macOS)
                        .formStyle(.grouped)
                    #endif
                }
            }
        }
    }

    private var initialView: some View {
        Group {
            if let recentLocations = file.manifest.recentLocations {
                List {
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
            } else {
                // swiftlint:disable line_length
                ContentUnavailableView(
                    "Search Everything",
                    image: "map.badge.magnifyingglass",
                    description: Text(
                        "Search for nearby biomes and structures, pinned places, and any marked locations from integrations like Bluemap."
                    )
                )
                // swiftlint:enable line_length
            }
        }
    }

    private func resultList(for result: CartographySearchService.SearchResult) -> some View {
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
            if file.integrations.enabled {
                integratedSection(data: result.integratedData)
            }
            biomesAndStructures(result: result)
        }
    }

    private func integratedSection(data: [CartographyMapPin]) -> some View {
        Section {
            ForEach(data) { pin in
                RedWindowSearchLandmarkResultCell(
                    request: $pinCreationRequest,
                    landmark: pin,
                    landmarkType: .integratedPin
                )
            }
            if data.isEmpty {
                ContentUnavailableView.search(text: query)
            }
        } header: {
            Text("From Integrations")
        }
    }

    private func biomesAndStructures(result: CartographySearchService.SearchResult) -> some View {
        let currentLoc = redWindowEnvironment.mapCenterCoordinate

        return Section {
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
