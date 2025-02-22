//
//  ContentView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import CubiomesKit
import Observation
import SwiftUI

/// The primary content view used to display the app's interface.
struct ContentView: View {
    @Environment(\.dismiss) private var dismissWindow

    /// The current file the content view is viewing and/or editing.
    @Binding var file: CartographyMapFile

    @State private var viewModel = CartographyMapViewModel()
    @State private var displaySidebarSheet = false

    var body: some View {
        Group {
            #if os(macOS)
                CartographyMapSplitView(viewModel: $viewModel, file: $file)
                    .toolbar {
                        toolbarContent
                    }
            #else
                AdaptableSidebarSheetView(isPresented: $displaySidebarSheet) {
                    CartographyMapView(state: viewModel.mapState)
                        .edgesIgnoringSafeArea(.all)
                } sheet: {
                    CartographyMapSidebarSheet(viewModel: $viewModel, file: $file) {
                        toolbarContent
                    }
                }
            #endif
        }
        .navigationTitle(file.map.name)
        .animation(.default, value: file.map.recentLocations)
        .animation(.default, value: viewModel.mapState)
        .task {
            await viewModel.refreshMap(for: file)
        }
        .onChange(of: viewModel.worldDimension) { _, _ in
            Task { await viewModel.refreshMap(for: file) }
        }
        #if os(iOS)
            .onAppear {
                hideNavigationBar()
            }
        #endif
        .sheet(isPresented: viewModel.displayCurrentRouteModally) {
            Group {
                switch viewModel.currentRoute {
                case .createPin(let cgPoint):
                    NavigationStack {
                        PinCreatorForm(location: cgPoint) { pin in
                            file.map.pins.append(pin)
                        }
                        .formStyle(.grouped)
                    }
                case .editWorld:
                    MapEditorFormSheet(file: $file) {
                        viewModel.submitWorldChanges(to: file)
                    } onCancelChanges: {
                        viewModel.currentRoute = nil
                    }
                default:
                    EmptyView()
                }
            }
        }
    }

    private var toolbarContent: some ToolbarContent {
        Group {
            #if os(iOS)
                ToolbarTitleMenu {
                    WorldDimensionPickerView(selection: $viewModel.worldDimension)
                        .labelStyle(.titleAndIcon)
                        .pickerStyle(.palette)
                    NavigationLink(value: CartographyRoute.editWorld) {
                        Label("Update World", systemImage: "tree")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        displaySidebarSheet = false
                        dismissWindow()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .fontWeight(.bold)
                }
            #else
                ToolbarItem {
                    Menu {
                        WorldDimensionPickerView(selection: $viewModel.worldDimension)
                            .pickerStyle(.inline)
                    } label: {
                        Label("Dimension", systemImage: "map")
                    }
                }
            #endif

            ToolbarItem {
                Button {
                    Task {
                        await viewModel.refreshMap(for: file)
                    }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }

            #if os(macOS)
                ToolbarItem {
                    Button {
                        viewModel.displayCurrentRouteAsInspector.wrappedValue.toggle()
                    } label: {
                        Label("Pin Inspector", image: "mappin.circle.badge.gearshape.fill")
                    }
                    .disabled(viewModel.currentRoute?.requiresInspectorDisplay != true)
                }
                ToolbarItem {
                    Button {
                        viewModel.currentRoute = .editWorld
                    } label: {
                        Label("Update World", image: "globe.desk.badge.gearshape.fill")
                    }
                }
            #endif
        }
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    ContentView(file: $file)
}
