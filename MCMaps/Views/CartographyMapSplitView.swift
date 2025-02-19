//
//  CartographyMapSplitView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import CubiomesKit
import SwiftUI

#if os(macOS)
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
                    CartographyMapView(state: viewModel.mapState)
                )
                .inspector(isPresented: viewModel.displayCurrentRouteAsInspector) {
                    Group {
                        switch viewModel.currentRoute {
                        case let .pin(index, _):
                            Group {
                                if (file.map.pins.indices).contains(index) {
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
            .navigationSubtitle(subtitle)
        }
    }
#endif
