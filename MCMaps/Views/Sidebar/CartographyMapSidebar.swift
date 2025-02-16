//
//  CartographyMapSidebar.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import SwiftUI

struct CartographyMapSidebar: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile

    private var searchBarPlacement: SearchFieldPlacement {
        #if os(macOS)
            return .sidebar
        #else
            return .navigationBarDrawer(displayMode: .always)
        #endif
    }

    var body: some View {
        List {
            if let results = searchResults, !viewModel.searchQuery.isEmpty {
                Group {
                    if let jumpToCoordinate = results.coordinates.first {
                        CartographyNamedLocationView(
                            name: "Jump Here",
                            location: jumpToCoordinate,
                            systemImage: "figure.run",
                            color: .accent
                        )
                        .onTapGesture {
                            withAnimation {
                                viewModel.go(to: jumpToCoordinate, relativeTo: file)
                                pushToRecentLocations(jumpToCoordinate)
                                viewModel.searchQuery = ""
                            }
                        }
                    }

                    if !results.pins.isEmpty {
                        PinnedLibrarySection(pins: results.pins, viewModel: $viewModel, file: $file)
                    }

                    if !results.structures.isEmpty {
                        SearchedStructuresSection(
                            structures: results.structures,
                            viewModel: $viewModel,
                            file: $file
                        ) { jumpedToPin in
                            withAnimation {
                                pushToRecentLocations(jumpedToPin.position)
                                viewModel.searchQuery = ""
                            }
                        }
                    }
                }
            } else {
                defaultView
            }
        }
        .frame(minWidth: 175, idealWidth: 200)
        .searchable(text: $viewModel.searchQuery, placement: searchBarPlacement, prompt: "Go To...")
        .animation(.default, value: searchResults)
    }

    private var defaultView: some View {
        Group {
            if !file.map.pins.isEmpty {
                PinnedLibrarySection(pins: file.map.pins, viewModel: $viewModel, file: $file)
            }
            if file.map.recentLocations?.isEmpty == false {
                RecentLocationsListSection(viewModel: $viewModel, file: $file) { (position: CGPoint) in
                    viewModel.go(to: position, relativeTo: file)
                }
            }
        }
    }

    private var world: MinecraftWorld? {
        try? MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed)
    }

    private var searchResults: CartographySearchService.SearchResult? {
        guard let world else { return nil }
        return CartographySearchService()
            .search(
                viewModel.searchQuery,
                world: world,
                file: file,
                currentPosition: viewModel.worldRange.position,
                dimension: viewModel.worldDimension
            )
    }

    func pushToRecentLocations(_ position: CGPoint) {
        if file.map.recentLocations == nil {
            file.map.recentLocations = [position]
            return
        }
        file.map.recentLocations?.append(position)
        if (file.map.recentLocations?.count ?? 0) > 15 {
            file.map.recentLocations?.remove(at: 0)
        }
    }
}
