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
                .navigationDestination(for: CartographyMapPin.self) { _ in
                    CartographyMapPinDetailView(viewModel: .init(file: $file, index: viewModel.selectedPinIndex))
                        .background(Color.clear)
                        .presentationBackground(.regularMaterial)
                }
        }
        .onChange(of: viewModel.displayPinInformation) { _, newValue in
            if newValue, file.map.pins.indices.contains(viewModel.selectedPinIndex) {
                let pin = file.map.pins[viewModel.selectedPinIndex]
                stackPathing.append(pin)
            }
        }
        .onChange(of: stackPathing) { _, newValue in
            if newValue.isEmpty {
//                viewModel.selectedPinIndex = -1
                viewModel.displayPinInformation = false
            }
        }
        .presentationDetents([.smallSearch, .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled()

    }
}
