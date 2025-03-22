//
//  ContentView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import AdaptableSidebarSheetView
import CubiomesKit
import Observation
import SwiftUI
import TipKit

/// The primary content view used to display the app's interface.
struct ContentView: View {
    private enum LocalTips {
        static let dimensionPicker = WorldDimensionPickerTip()
    }

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
                AdaptableSidebarSheet(isPresented: $displaySidebarSheet) {
                    CartographyOrnamentMap(viewModel: $viewModel, file: $file)
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
            await WorldDimensionPickerTip.viewDisplayed.donate()
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
                    NavigationLink(value: CartographyRoute.editWorld) {
                        Label("Update World", image: "globe.desk.badge.gearshape.fill")
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
                    .popoverTip(LocalTips.dimensionPicker)
                    .onChange(of: viewModel.worldDimension) { _, _ in
                        LocalTips.dimensionPicker.invalidate(reason: .actionPerformed)
                    }
                }
            #endif

            #if DEBUG
                ToolbarItem {
                    Button {
                        Task {
                            await viewModel.refreshMap(for: file)
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            #endif

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

#if DEBUG
    extension ContentView {
        var testHooks: TestHooks { TestHooks(target: self) }

        struct TestHooks {
            private let target: ContentView

            fileprivate init(target: ContentView) {
                self.target = target
            }

            var displaySidebarSheet: Bool {
                target.displaySidebarSheet
            }

            var viewModel: CartographyMapViewModel {
                target.viewModel
            }
        }
    }
#endif
