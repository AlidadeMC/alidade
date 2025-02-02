//
//  CartographyMapSplitView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import CubiomesKit
import SwiftUI

struct CartographyMapSplitView: View {
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile

    private var subtitle: String {
        let seed = String(file.map.seed)
        return "\(file.map.name) - Minecraft \(file.map.mcVersion) | Seed: " + seed
    }

    var body: some View {
        NavigationSplitView {
            CartographyMapSidebar(viewModel: $viewModel, file: $file)
        } detail: {
            Group {
                LocationBadge(location: viewModel.worldRange.position)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .background(
                CartographyMapView(state: viewModel.state)
            )
        }
        #if os(macOS)
        .navigationSubtitle(subtitle)
        #endif
    }
}
