//
//  PinnedLibrarySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

/// A section used to display player-created pins in a sidebar.
///
/// This is normally invoked from ``CartographyMapSidebar`` and is almost never instantiated on its own.
struct PinnedLibrarySection: View {
    /// The player-created pins to display.
    var pins: [CartographyMapPin]

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    @Binding var file: CartographyMapFile

    @State private var displayDeletionPrompt = false
    @State private var deletionIndex: [CartographyMapPin].Index?

    var body: some View {
        Section("Library") {
            ForEach(Array(pins.enumerated()), id: \.element) { (idx: Int, pin: CartographyMapPin) in
                NavigationLink(value: CartographyRoute.pin(idx, pin: pin)) {
                    CartographyNamedLocationView(pin: pin)
                        .tag(CartographyRoute.pin(idx, pin: pin))
                }.buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        #if os(macOS)
                            Button {
                                viewModel.currentRoute = .pin(idx, pin: pin)
                            } label: {
                                Label("Get Info", systemImage: "info.circle")
                            }
                        #endif
                        Button(role: .destructive) {
                            deletionIndex = idx
                            displayDeletionPrompt.toggle()
                        } label: {
                            Label("Delete Pin...", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        .tint(.accentColor)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deletionIndex = idx
                            displayDeletionPrompt.toggle()
                        } label: {
                            Label("Delete Pin...", systemImage: "trash")
                        }
                        #if os(macOS)
                            Button {
                                viewModel.currentRoute = .pin(idx, pin: pin)
                            } label: {
                                Label("Get Info", systemImage: "info.circle")
                            }
                            .tint(.blue)
                        #endif
                    }
                    #if os(iOS)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    #endif
            }

        }
        .alert(
            "Are you sure you want to remove \(deletionPinName)?",
            isPresented: $displayDeletionPrompt
        ) {
            Button(role: .cancel) {
                displayDeletionPrompt = false
                deletionIndex = nil
            } label: {
                Text("Don't Remove")
            }
            Button(role: .destructive) {
                displayDeletionPrompt = false
                if let deletionIndex {
                    file.removePin(at: deletionIndex)
                }
                self.deletionIndex = nil
            } label: {
                Text("Remove")
            }
        } message: {
            Text("Deleting this pin will also remove its photos from the map.")
        }
    }

    private var deletionPinName: String {
        if let deletionIndex {
            return file.map.pins[deletionIndex].name
        }
        return String(localized: "this pin")
    }

    private func recolorPins(
        to color: CartographyMapPin.Color,
        where predicate: @escaping (CartographyMapPin) -> Bool
    ) {
        for (index, pin) in file.map.pins.enumerated() where predicate(pin) {
            file.map.pins[index].color = color
        }
    }
}
