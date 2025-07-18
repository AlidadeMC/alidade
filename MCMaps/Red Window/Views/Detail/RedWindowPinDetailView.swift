//
//  RedWindowPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import CubiomesKit
import MCMapFormat
import PhotosUI
import SwiftUI

/// A detail view that displays a player-created pin and its properties.
///
/// The detail view uses a collection view-like layout with multiple cells, allowing editing of key properties when
/// toggling the edit mode. This view also allows editing the tags, uploading photos from both the player's Photos
/// library and local files (supported universally), and changing the pin's color.
///
/// On regular horizontal size classes, such as iPad and Mac, the detail view will also display a small map of the
/// pin's region. On iPad, this is contingent on whether the tab bar is collapsed.
struct RedWindowPinDetailView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.tabBarPlacement) private var tabBarPlacement

    /// The pin that the detail view will display and edit.
    @Binding var pin: MCMapManifestPin

    /// The file containing the pin and its corresponding images.
    @Binding var file: CartographyMapFile

    @State private var tags = Set<String>()
    @State private var displayAlert = false
    @State private var center = CGPoint.zero
    @State private var color = MCMapManifestPin.Color.blue
    @State private var editMode = false
    @State private var presentTagEditor = false

    @State private var photosPickerItem: PhotosPickerItem?
    @State private var uploadFromFiles = false

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
        .onChange(of: photosPickerItem) { _, newValue in
            guard let item = newValue else { return }
            Task { await loadPickerSelection(item) }
        }
        .fileImporter(isPresented: $uploadFromFiles, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let url):
                Task {
                    await attachImage(from: url)
                }
            case .failure(let error):
                print(error)
            }
        }
        .sheet(isPresented: $presentTagEditor) {
            NavigationStack {
                RedWindowTagForm(tags: $tags)
                    #if os(macOS)
                        .formStyle(.grouped)
                    #endif
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
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Label("Add From Photos", systemImage: "photo.badge.plus")
                }
            }
            ToolbarItem {
                Button("Add From Files", systemImage: "folder") {
                    uploadFromFiles.toggle()
                }
            }

            #if RED_WINDOW
                if #available(macOS 16, iOS 19, *) {
                    ToolbarSpacer(.fixed)
                }
            #endif

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

    private func loadPickerSelection(_ item: PhotosPickerItem) async {
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await attachImage(data: data)
            }
        } catch {
            print(error)
        }
    }

    private func attachImage(from url: URL) async {
        do {
            #if os(iOS)
            _ = url.startAccessingSecurityScopedResource()
            #endif
            let data = try Data(contentsOf: url)
            await attachImage(data: data)
            #if os(iOS)
            url.stopAccessingSecurityScopedResource()
            #endif
        } catch {
            print(error)
        }
    }

    private func attachImage(data: Data) async {
        let imageName = UUID().uuidString + ".heic"
        if pin.images == nil {
            pin.images = [imageName]
        } else {
            pin.images?.append(imageName)
        }
        file.images[imageName] = data
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
                #if RED_WINDOW
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
                #else
                Button("Done", systemImage: "checkmark") {
                    editMode.toggle()
                }
                .buttonStyle(.borderedProminent)
                #endif
            } else {
                Button("Edit") {
                    editMode.toggle()
                }
            }
        }
    }
}
