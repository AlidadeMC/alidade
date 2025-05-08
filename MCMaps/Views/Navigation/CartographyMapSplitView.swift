//
//  CartographyMapSplitView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import CubiomesKit
import SwiftUI

/// A split view used to display a Minecraft map and the player library as a sidebar.
///
/// This interface is used to drive the macOS experience. The main sidebar (``CartographyMapSidebar``) is displayed
/// as the app's sidebar, and the main content window displays the corresponding Minecraft map. Routes in
/// ``CartographyRoute`` that are to be displayed as an inspector via ``CartographyRoute/requiresInspectorDisplay``
/// are displayed as an inspector inside the detail view, rather than the window's edge.
@available(macOS 15.0, *)
struct CartographyMapSplitView: View {
    /// The view model the interface will be interacting with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the interface will read from and write to.
    @Binding var file: CartographyMapFile

    private var subtitle: String {
        let seed = String(file.manifest.seed)
        return "\(file.manifest.name) - Minecraft \(file.manifest.mcVersion) | Seed: " + seed
    }

    var body: some View {
        NavigationSplitView {
            CartographyMapSidebar(viewModel: $viewModel, file: $file)
        } detail: {
            CartographyOrnamentMap(viewModel: $viewModel, file: $file)
            .inspector(isPresented: viewModel.displayCurrentRouteAsInspector) {
                Group {
                    switch viewModel.currentRoute {
                    case let .pin(index, _):
                        Group {
                            if (file.manifest.pins.indices).contains(index) {
                                CartographyMapPinDetailView(
                                    viewModel: CartographyPinViewModel(
                                        file: $file, index: index))
                            } else {
                                ContentUnavailableView("No Pin Selected", systemImage: "mappin")
                            }
                        }
                    default:
                        EmptyView()
                    }

                }
                .inspectorColumnWidth(min: 300, ideal: 325)
            }
        }
        #if os(macOS)
        .navigationSubtitle(subtitle)
        #endif
    }
}
