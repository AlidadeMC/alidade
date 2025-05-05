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

    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Environment(\.dismiss) private var dismissWindow

    /// The current file the content view is viewing and/or editing.
    @Binding var file: CartographyMapFile

    @State private var viewModel = CartographyMapViewModel()
    @State private var columnVisibility = NavigationSplitViewColumn.detail

    var body: some View {
        Group {
            #if os(macOS)
                CartographyMapSplitView(viewModel: $viewModel, file: $file)
                    .toolbar {
                        toolbarContent
                    }
            #else
                AdaptableSidebarSheet(
                    isPresented: $viewModel.displaySidebarSheet,
                    currentPresentationDetent: $viewModel.presentationDetent
                ) {
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
        .task {
            await WorldDimensionPickerTip.viewDisplayed.donate()
        }
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
        ContentViewToolbar(viewModel: $viewModel)
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    ContentView(file: $file)
}

#if DEBUG
    extension ContentView {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: ContentView

            fileprivate init(target: ContentView) {
                self.target = target
            }

            var displaySidebarSheet: Bool {
                false
                //                target.displaySidebarSheet
            }

            var viewModel: CartographyMapViewModel {
                target.viewModel
            }
        }
    }
#endif
