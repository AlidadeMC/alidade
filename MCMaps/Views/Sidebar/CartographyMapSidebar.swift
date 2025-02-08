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
            if !file.map.pins.isEmpty {
                PinnedLibrarySection(viewModel: $viewModel, file: $file)
            }
            if file.map.recentLocations?.isEmpty == false, viewModel.searchQuery.isEmpty {
                RecentLocationsListSection(viewModel: $viewModel, file: $file) { (position: CGPoint) in
                    viewModel.goTo(position: position, seed: file.map.seed, mcVersion: file.map.mcVersion)
                }
            }
        }
        .frame(minWidth: 175, idealWidth: 200)
        .searchable(
            text: $viewModel.searchQuery,
            placement: searchBarPlacement,
            prompt: "Go To..."
        ) {
            let positionMatch = viewModel.searchQuery.matches(of: /(-?\d+), (-?\d+)/)
            if let position = positionMatch.first?.output {
                Button {
                    viewModel.goToRegexPosition(
                        position,
                        seed: file.map.seed,
                        mcVersion: file.map.mcVersion
                    ) { truePosition in
                        pushToRecentLocations(truePosition)
                        dismissSearch()
                    }
                } label: {
                    Label("Go to: " + viewModel.searchQuery, systemImage: "location.fill")
                }
            }
        }
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
