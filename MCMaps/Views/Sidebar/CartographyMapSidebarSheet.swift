//
//  CartographyMapSidebarSheet.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

extension PresentationDetent {
    static var smallSearch = Self.height(108)
}

struct CartographyMapSidebarSheet<T: ToolbarContent>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile
    @State private var stackPathing: NavigationPath = .init()

    var sheetToolbar: () -> T

    var body: some View {
        NavigationStack(path: $stackPathing) {
            CartographyMapSidebar(viewModel: $viewModel, file: $file)
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                #if os(iOS)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
                .navigationTitle(file.map.name)
                .navigationDocument(file, preview: SharePreview(file.map.name))
                .toolbar { sheetToolbar() }
                .navigationDestination(for: CartographyRoute.self) { route in
                    routingDestination(for: route)
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
                CartographyMapPinDetailView(viewModel: .init(file: $file, index: index))
                    .background(Color.clear)
                    .presentationBackground(.regularMaterial)
                    .task {
                        viewModel.go(to: pin.position, relativeTo: file)
                    }
            case let .createPin(location):
                PinCreatorForm(location: location) { newPin in
                    file.map.pins.append(newPin)
                }
            case .editWorld:
                MapCreatorForm(worldName: $file.map.name, mcVersion: $file.map.mcVersion, seed: $file.map.seed)
                    .navigationTitle("Edit World")
                    .onDisappear {
                        viewModel.submitWorldChanges(to: file, horizontalSizeClass)
                    }
                    .onChange(of: file.map.mcVersion) { _, _ in
                        viewModel.submitWorldChanges(to: file, horizontalSizeClass)
                    }
                    .onChange(of: file.map.seed) { _, _ in
                        viewModel.submitWorldChanges(to: file, horizontalSizeClass)
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
