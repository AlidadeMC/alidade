//
//  RedWindowSearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import SwiftUI

struct RedWindowSearchView: View {
    @Binding var file: CartographyMapFile

    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                if let recentLocations = file.manifest.recentLocations {
                    Section {
                        ForEach(recentLocations, id: \.self) { recentLocation in
                            Label(recentLocation.accessibilityReadout, systemImage: "location")
                        }
                    } header: {
                        Text("Recent Locations")
                    }
                }
                Section {
                    Label("Letztes", systemImage: "magnifyingglass")
                    Label("Desert", systemImage: "mountain.2")
                    Label("Village", systemImage: "building.2")
                } header: {
                    Text("Recent Queries")
                }
            }
        }
        .searchable(text: $query)
    }
}
