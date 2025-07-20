//
//  CartographyMapSidebarSheet.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import MCMap
import SwiftUI

extension PresentationDetent {
    /// A presentation detent that matches a navigation bar with its search bar visible.
    @available(macOS, introduced: 15.0, deprecated: 26.0)
    @available(iOS, introduced: 18.0, deprecated: 26.0)
    static let smallSearch = Self.height(108)
}

/// The sidebar content for the main app on iOS and iPadOS.
///
/// This view should be used instead of ``CartographyMapSidebar`` directly. The sidebar sheet also handles appropriate
/// routing from ``CartographyRoute``.
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct CartographyMapSidebarSheet<T: ToolbarContent>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    ///
    /// Notably, the sidebar content will read from recent locations and the player-created pins.
    @Binding var file: CartographyMapFile

    /// The toolbar content for the sheet.
    var sheetToolbar: () -> T

    var body: some View {
        NavigationStack {
            CartographyMapSidebar(viewModel: $viewModel, file: $file)
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                #if os(iOS)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
                .navigationTitle(file.manifest.name)
                .navigationDocument(file, preview: SharePreview(file.manifest.name))
                .toolbar { sheetToolbar() }
                .navigationDestination(for: CartographyRoute.self) { route in
                    routingDestination(for: route)
                        .onAppear {
                            if viewModel.presentationDetent == .small {
                                viewModel.presentationDetent = .medium
                            }
                        }
                }
        }
        .presentationDetents([.smallSearch, .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled()
    }

    private func routingDestination(for route: CartographyRoute) -> some View {
        Group {
            switch route {
            case let .pin(index, pin):
                CartographyMapPinDetailView(viewModel: CartographyPinViewModel(file: $file, index: index))
                    .background(Color.clear)
                    .presentationBackground(.regularMaterial)
                    .task {
                        viewModel.go(to: pin.position, relativeTo: file)
                    }
            case let .createPin(location):
                PinCreatorForm(location: location) { newPin in
                    file.manifest.pins.append(newPin)
                }
            case .editWorld:
                MapCreatorForm(
                    worldName: $file.manifest.name,
                    worldSettings: $file.manifest.worldSettings,
                    integrations: $file.integrations,
                    displayMode: .edit
                )
                .navigationTitle("Edit World")
                .onDisappear {
                    viewModel.submitWorldChanges(to: file)
                }
                .onChange(of: file.manifest.worldSettings) { _, _ in
                    viewModel.submitWorldChanges(to: file)
                }
            default:
                Group {
                    ContentUnavailableView(
                        "No Route Available", systemImage: "questionmark.circle",
                        description: Text("No view was defined for route \(String(describing: route))"))
                }
            }
        }
    }
}
