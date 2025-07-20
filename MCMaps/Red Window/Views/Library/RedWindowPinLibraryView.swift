//
//  RedWindowPinLibraryView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import MCMapFormat
import SwiftUI

/// An enumeration of the different navigation paths that can be traveled to in the ``RedWindowPinLibraryView``.
enum RedWindowLibraryNavigationPath: Hashable {
    /// A pin being displayed in a detail view.
    /// - Parameter pin: The pin to display.
    /// - Parameter index: The index of the pin relative to the pins list in the file.
    case pin(MCMapManifestPin, index: Int)
}

/// A view that displays the player's library of pinned places.
///
/// Players can switch between displaying the pins as a list of entries, or as a grid. Selecting a pin will open it in
/// a detail view as a child page. Additionally, a create button is available to let players create a pin directly from
/// this view.
struct RedWindowPinLibraryView: View {
    /// An enumeration of the different library view modes.
    enum LibraryViewMode: String, Hashable {
        /// Display the library as a grid of pins.
        case grid

        /// Display the library as a list of pins.
        case list
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.tabBarPlacement) private var tabBarPlacement

    @Namespace private var namespace

    /// The file containing the pins to display.
    @Binding var file: CartographyMapFile

    /// The parent navigation view's path.
    @Binding var path: NavigationPath

    @AppStorage("library.view") private var viewMode = LibraryViewMode.grid
    @State private var displayForm = false
    @State private var presentedPins: [RedWindowLibraryNavigationPath] = []
    @State private var deletionRequest = RedWindowPinDeletionRequest()

    /// The collection of pins to display in the grid and list layouts.
    ///
    /// This collection is typically preferred over `file.manifest.pins` because it guarantees that it will work
    /// correctly with SwiftUI view structures such as `ForEach`. However, as this property is computed, this should
    /// **not** be used to mutate the data.
    var pinCollection: IndexedPinCollection {
        IndexedPinCollection(file.manifest.pins)
    }

    private var deletionTitle: LocalizedStringKey {
        let pinsToDelete = deletionRequest.elementIDs.compactMap { index in
            if file.manifest.pins.indices.contains(index) {
                return file.manifest.pins[index]
            }
            return nil
        }
        return switch pinsToDelete.count {
        case 1:
            "Are you sure you want to remove '\(pinsToDelete.first?.name ?? "Pin")'?"
        case 2...:
            "Are you sure you want to remove \(pinsToDelete.count) pins?"
        default:
            "There are no pins to be removed."
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewMode {
                case .grid:
                    RedWindowPinLibraryGridView(
                        navigationPath: $path,
                        deletionRequest: $deletionRequest,
                        file: file,
                        pins: pinCollection,
                        namespace: namespace
                    )
                case .list:
                    RedWindowPinLibraryListView(
                        navigationPath: $path,
                        deletionRequest: $deletionRequest,
                        pins: pinCollection
                    )
                }
            }
            .animation(.interactiveSpring, value: viewMode)
            .animation(.interactiveSpring, value: tabBarPlacement)
            .alert(deletionTitle, isPresented: $deletionRequest.presentAlert) {
                Button("Remove", role: .destructive) {
                    let pinsToRemove = IndexSet(deletionRequest.elementIDs)
                    file.removePins(at: pinsToRemove)
                    deletionRequest.presentAlert = false
                    deletionRequest.elementIDs.removeAll()
                }
                Button("Don't Remove", role: .cancel) {
                    deletionRequest.presentAlert = false
                    deletionRequest.elementIDs.removeAll()
                }
            } message: {
                Text(
                    "Any associated images will be removed, and they will no longer be visible in the Gallery."
                )
            }
            .navigationDestination(for: RedWindowLibraryNavigationPath.self) { path in
                switch path {
                case .pin(let pin, let index):
                    RedWindowPinDetailView(
                        pin: Binding {
                            return file.manifest.pins[index]
                        } set: { newValue in
                            file.manifest.pins[index] = newValue
                        }, file: $file
                    )
                    #if os(iOS)
                        .navigationTransition(.zoom(sourceID: pin, in: namespace))
                    #endif
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

                #if os(iOS)
                    ToolbarItem {
                        if viewMode == .list {
                            EditButton()
                        }
                    }
                #endif
            }
        }
        .navigationTitle("All Pins")
    }
}
