//
//  CartographyUnifiedView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var file: CartographyMapFile

    @State private var currentPosition = CGPoint.zero
    @State private var query = ""
    @State private var enableInspector = false
    @State private var preferredCompactColumn = NavigationSplitViewColumn.detail
    @State private var renderNaturalColors = true
    @State private var mapDimension = MinecraftWorld.Dimension.overworld

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredCompactColumn) {
            List {
                Section {
                    Label("(10, 10)", systemImage: "location.fill")
                    Label("(1847, 1847)", systemImage: "location.fill")
                } header: {
                    Label("Recents", systemImage: "clock")
                }

                Section {
                    Label {
                        Text("Letztes Jahr")
                    } icon: {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.blue)
                    }
                    Label {
                        Text("KLB Electronics")
                    } icon: {
                        Image(systemName: "building.2.fill")
                            .foregroundStyle(.pink)
                    }
                    Label {
                        Text("Café Trommeln")
                    } icon: {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundStyle(.brown)
                    }
                } header: {
                    Label("Library", systemImage: "mappin")
                }
            }
            .listStyle(.sidebar)
            .overlay(alignment: .bottomLeading) {
                if horizontalSizeClass == .compact {
                    if #available(macOS 16, iOS 19, *) {
                        Button {
                            preferredCompactColumn = .detail
                        } label: {
                            Label("Return to Map", systemImage: "chevron.forward")
                        }
                        .padding()
                        .labelStyle(.iconOnly)
                        .glassEffect()
                        .scenePadding()
                    }
                }
            }
        } detail: {
            if let world = try? MinecraftWorld(worldSettings: file.manifest.worldSettings) {
                MinecraftMap(world: world, centerCoordinate: $currentPosition, dimension: mapDimension)
                    .mapColorScheme(.natural)
                    .edgesIgnoringSafeArea(.all)
                    .toolbar {
                        ToolbarItem {
                            Menu {
                                Toggle(isOn: $renderNaturalColors) {
                                    Label("Natural Colors", systemImage: "paintpalette")
                                }
                                WorldDimensionPickerView(selection: $mapDimension)
                                    .pickerStyle(.inline)
                            } label: {
                                Label("Map", systemImage: "map")
                            }
                        }
                        if #available(macOS 16, iOS 19, *) {
                            ToolbarSpacer(.flexible)
                        }
                        ToolbarItem {
                            Button {
                            } label: {
                                Label("Create Pin", systemImage: "mappin")
                            }
                        }
                        ToolbarItem {
                            Button {
                                enableInspector.toggle()
                            } label: {
                                Label("Inspector", systemImage: "info.circle")
                            }
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .searchable(text: $query)
        .overlay(alignment: .bottomTrailing) {
            LocationBadge(location: currentPosition)
                .environment(\.contentTransitionAddsDrawingGroup, true)
                .labelStyle(.titleAndIcon)
        }
        .inspector(isPresented: $enableInspector) {
            ContentUnavailableView("Select a Pin", systemImage: "mappin")
        }
    }
}
