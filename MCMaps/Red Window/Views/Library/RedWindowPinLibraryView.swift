//
//  RedWindowPinLibraryView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

extension MCMapManifestPin: Identifiable {
    var id: Self { self }
}

enum LibraryNavigationPath: Hashable {
    case pin(MCMapManifestPin, index: Int)
}

struct RedWindowPinLibraryView: View {
    enum LibraryViewMode: String, Hashable {
        case grid, list
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var file: CartographyMapFile
    @Binding var path: NavigationPath

    @AppStorage("library.view") private var viewMode = LibraryViewMode.grid
    @State private var displayForm = false
    @State private var presentedPins: [LibraryNavigationPath] = []

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                let collection = IndexedPinCollection(file.manifest.pins)
                switch viewMode {
                case .grid:
                    RedWindowPinLibraryGridView(pins: collection)
                case .list:
                    RedWindowPinLibraryListView(navigationPath: $path, pins: collection)
                }
            }
            .navigationDestination(for: LibraryNavigationPath.self) { path in
                switch path {
                case let .pin(_, index):
                    RedWindowPinDetailView(pin: Binding {
                        return file.manifest.pins[index]
                    } set: { newValue in
                        file.manifest.pins[index] = newValue
                    })
                }
            }
            .sheet(isPresented: $displayForm) {
                NavigationStack {
                    PinCreatorForm(location: .zero) { newPin in
                        file.manifest.pins.append(newPin)
                    }
                    #if os(macOS)
                        .formStyle(.grouped)
                    #endif
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu("View Mode", systemImage: viewMode == .grid ? "square.grid.2x2" : "list.bullet") {
                        Picker("View Mode", selection: $viewMode) {
                            Label("Grid", systemImage: "square.grid.2x2").tag(LibraryViewMode.grid)
                            Label("List", systemImage: "list.bullet").tag(LibraryViewMode.list)
                        }
                        .pickerStyle(.inline)
                    }
                }
                #if RED_WINDOW
                    if #available(macOS 16, iOS 19, *) {
                        ToolbarSpacer(.fixed)
                    }
                #endif
                ToolbarItem {
                    Button("Create Pin", systemImage: "plus") {
                        displayForm.toggle()
                    }
                }
            }
        }
        .navigationTitle("All Pins")
    }
}
