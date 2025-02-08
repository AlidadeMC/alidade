//
//  RecentLocationsListSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

struct RecentLocationsListSection: View {
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile

    var recentLocations: [CGPoint] {
        file.map.recentLocations ?? []
    }

    var goToPosition: ((CGPoint) -> Void)?

    var body: some View {
        Section("Recents") {
            ForEach(Array(recentLocations.enumerated().reversed()), id: \.offset) { (idx, pos) in
                CartographyNamedLocationView(
                    name: "Location",
                    location: pos,
                    systemImage: "location.fill",
                    color: .gray
                )
                .onTapGesture {
                    goToPosition?(pos)
                }
                .contextMenu {
                    Button {
                        viewModel.presentNewPinForm(for: pos)
                    } label: {
                        Label("Pin...", systemImage: "mappin")
                    }
                    Button {
                        goToPosition?(pos)
                    } label: {
                        Label("Go Here", systemImage: "location")
                    }
                    Button("Remove from Recents", role: .destructive) {
                        file.map.recentLocations?.remove(at: idx)
                    }
                }
                #if os(iOS)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                #endif
            }
            .onDelete { indexSet in
                file.map.recentLocations?.remove(atOffsets: indexSet)
            }
        }
    }
}
