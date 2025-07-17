//
//  ContentViewToolbar.swift
//  MCMaps
//
//  Created by Marquis Kurt on 05-05-2025.
//

import MCMapFormat
import SwiftUI

/// A toolbar that is used inside of ``LegacyContentView``.
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct ContentViewToolbar: ToolbarContent {
    @Environment(\.documentURL) private var documentURL
    @Environment(\.openWindow) private var openWindow

    private enum LocalTips {
        static let dimensionPicker = WorldDimensionPickerTip()
    }

    var file: CartographyMapFile
    @Binding var viewModel: CartographyMapViewModel

    var body: some ToolbarContent {
        Group {
            #if os(iOS)
                ToolbarTitleMenu {
                    NavigationLink(value: CartographyRoute.editWorld) {
                        Label("Update World", image: "globe.desk.badge.gearshape.fill")
                    }
                }
                ToolbarItem {
                    NavigationLink(value: CartographyRoute.createPin(.zero)) {
                        Label("Create Pin", image: "mappin.circle.badge.plus")
                    }
                }
            #else
                ToolbarItem {
                    Menu {
                        Toggle(isOn: $viewModel.renderNaturalColors) {
                            Label("Natural Colors", systemImage: "paintpalette")
                        }
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
                ToolbarItem {
                    Button {
                        viewModel.currentRoute = .createPin(.zero)
                    } label: {
                        Label("Create Pin", image: "mappin.circle.badge.plus")
                    }
                    .keyboardShortcut("p", modifiers: [.command])
                }
            #endif

            ToolbarItem {
                Button("Gallery", systemImage: "photo.stack") {
                    openWindow(
                        id: .gallery,
                        context: CartographyGalleryWindowContext(file: file, documentBaseURL: documentURL)
                    )
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
