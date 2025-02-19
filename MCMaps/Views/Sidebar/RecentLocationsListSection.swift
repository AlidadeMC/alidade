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
                .tag(CartographyRoute.recent(pos))
                #if os(iOS)
                    .onTapGesture {
                        goToPosition?(pos)
                    }
                    .swipeActions(edge: .leading) {
                        NavigationLink(value: CartographyRoute.createPin(pos)) {
                            Label("Pin...", systemImage: "mappin")
                        }
                        .tint(.accentColor)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            file.map.recentLocations?.remove(at: idx)
                        } label: {
                            Label("Remove from Recents", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                #endif
                .contextMenu {
                    #if os(iOS)
                        NavigationLink(value: CartographyRoute.createPin(pos)) {
                            Label("Pin...", systemImage: "mappin")
                        }
                    #else
                        Button {
                            viewModel.currentRoute = .createPin(pos)
                        } label: {
                            Label("Pin...", systemImage: "mappin")
                        }
                    #endif
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
