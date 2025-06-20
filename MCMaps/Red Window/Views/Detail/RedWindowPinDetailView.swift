//
//  RedWindowPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinDetailView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.tabBarPlacement) private var tabBarPlacement

    @Binding var pin: MCMapManifestPin
    @Binding var file: CartographyMapFile

    @State private var tags = Set<String>()
    @State private var displayAlert = false
    @State private var center = CGPoint.zero
    @State private var color = MCMapManifestPin.Color.blue
    @State private var editMode = false
    @State private var presentTagEditor = false

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    RedWindowPinHeader(pin: $pin, isEditing: $editMode, file: file)
                    Group {
                        RedWindowDescriptionCell(pin: $pin, isEditing: $editMode, file: $file)
                        RedWindowPinTagsCell(pin: $pin, isEditing: $editMode, file: $file)
                        RedWindowPinGalleryCell(pin: $pin, isEditing: $editMode, file: $file)
                    }
                    .padding(.horizontal)
                }
            }
            if tabBarPlacement != .sidebar, horizontalSizeClass == .regular { mapView }
        }
        .ignoresSafeArea(edges: .vertical)
        .animation(.interactiveSpring, value: tabBarPlacement)
        // NOTE(alicerunsonfedora): The animation causes a flashing problem for some reason. Disabled to as to not
        // induce seizures from any potential players.
//        .animation(.default, value: editMode)
        .task {
            center = pin.position
            if let currentColor = pin.color {
                color = currentColor
            }
            if let pinTags = pin.tags {
                tags = pinTags
            }
        }
        .onChange(of: color) { _, newValue in
            pin.color = newValue
        }
        .onChange(of: tags) { _, newValue in
            guard file.supportedFeatures.contains(.pinTagging) else { return }
            pin.tags = newValue
        }
        .sheet(isPresented: $presentTagEditor) {
            NavigationStack {
                RedWindowTagForm(tags: $tags)
            }
        }
        .toolbar {
            ToolbarItem {
                editButton
            }

            #if RED_WINDOW
                if #available(macOS 16, iOS 19, *) {
                    ToolbarSpacer(.fixed)
                }
            #endif

            ToolbarItem {
                Menu("Add Photos", systemImage: "photo.badge.plus") {
                    Button("From Photos", systemImage: "photo.on.rectangle.angled") {}
                    Button("From Files", systemImage: "folder") {}
                }
            }

            ToolbarItem {
                Menu("Pin Color", systemImage: "paintpalette") {
                    Picker("Pin Color", selection: $color) {
                        ForEach(MCMapManifestPin.Color.allCases, id: \.self) { color in
                            Text(String(describing: color).localizedCapitalized)
                                .tag(color)
                        }
                    }
                }
            }

            #if RED_WINDOW
                if #available(macOS 16, iOS 19, *) {
                    ToolbarSpacer(.fixed)
                }
            #endif

            ToolbarItem {
                Button("Manage Tags", systemImage: "tag") {
                    presentTagEditor.toggle()
                }
            }
        }
    }

    private var mapView: some View {
        Group {
            Divider()
            Group {
                if let world = try? MinecraftWorld(version: "1.21.3", seed: 184_719_632_014) {
                    MinecraftMap(world: world, centerCoordinate: $center) {
                        Marker(location: .zero, title: "#nodraw")
                        Marker(
                            location: pin.position,
                            title: pin.name,
                            color: pin.color?.swiftUIColor ?? .accent
                        )
                    }
                    .mapColorScheme(.natural)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
                }
            }
            .frame(idealWidth: 300, maxWidth: 375, maxHeight: .infinity)
        }
    }

    private var editButton: some View {
        Group {
            if editMode {
                if #available(iOS 19, macOS 16, *) {
                    Button(role: .confirm) {
                        editMode.toggle()
                    }
                } else {
                    Button("Done", systemImage: "checkmark") {
                        editMode.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Button("Edit") {
                    editMode.toggle()
                }
            }
        }
    }
}
