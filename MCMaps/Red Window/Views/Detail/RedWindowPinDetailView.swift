//
//  RedWindowPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import Bedrock
import CubiomesKit
import MCMap
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
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The pin that the detail view will display and edit.
    @Binding var pin: CartographyMapPin

    /// The file containing the pin and its corresponding images.
    @Binding var file: CartographyMapFile

    @State private var tags = Set<String>()
    @State private var displayAlert = false
    @State private var displayInspector = true
    @State private var center = CGPoint.zero
    @State private var color = CartographyMapPin.Color.blue
    @State private var editMode = false
    @State private var icon = CartographyIcon.default

    @State private var presentIconPicker = false
    @State private var presentTagEditor = false

    @State private var photosPickerItem: PhotosPickerItem?
    @State private var uploadFromFiles = false

    private var canDisplayMapView: Bool {
        return tabBarPlacement != .sidebar && horizontalSizeClass == .regular
    }

    private var shouldDisplayMapView: Bool {
        return canDisplayMapView && displayInspector
    }

    var body: some View {
        @Bindable var env = redWindowEnvironment

        HStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    RedWindowPinHeader(pin: $pin, isEditing: $editMode, file: file)
                    Group {
                        RedWindowDescriptionCell(pin: $pin, isEditing: $editMode, file: $file)
                        if !editMode {
                            if tags.isNotEmpty {
                                RedWindowPinTagsCell(pin: $pin, isEditing: $editMode, file: $file)
                            }
                            RedWindowPositionCell(pin: $pin, isEditing: $editMode, file: $file)
                            RedWindowPinGalleryCell(pin: $pin, isEditing: $editMode, file: $file)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .layoutPriority(1.5)
            if shouldDisplayMapView { mapView }
        }
        .ignoresSafeArea(edges: .vertical)
        .animation(.interactiveSpring, value: tabBarPlacement)
        .animation(.interactiveSpring, value: editMode)
        .animation(.interactiveSpring, value: displayInspector)
        .task {
            center = pin.position
            if let currentColor = pin.color {
                color = currentColor
            }
            if let pinTags = pin.tags {
                tags = pinTags
            }
            if let pinIcon = pin.icon {
                icon = pinIcon
            }
        }
        .onChange(of: color) { _, newValue in
            pin.color = newValue
        }
        .onChange(of: tags) { _, newValue in
            guard file.supportedFeatures.contains(.pinTagging) else { return }
            pin.tags = newValue
        }
        .onChange(of: icon) { _, newValue in
            guard file.supportedFeatures.contains(.pinIcons) else { return }
            pin.icon = newValue
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
        .sheet(isPresented: $presentIconPicker) {
            NavigationStack {
                CartographyIconPicker(icon: $icon, context: .pin)
                    .navigationTitle("Select an Icon")
            }
        }
        .toolbar {
            if editMode {
                ToolbarItem {
                    pinCustomizationMenu
                }

                ToolbarItem {
                    Menu("Pin Dimension", systemImage: SemanticIcon.dimensionSelect.rawValue) {
                        #if os(iOS)
                            Label("Pin Dimension", semanticIcon: .dimensionSelect)
                                .foregroundStyle(.secondary)
                        #endif
                        WorldCodedDimensionPicker(selection: $pin.dimension)
                    }
                }
                ToolbarSpacer(.fixed)
                ToolbarItem {
                    Button("Manage Tags…", systemImage: "tag") {
                        presentTagEditor.toggle()
                    }
                }
                ToolbarSpacer(.fixed)
            }

            if !editMode {
                ToolbarSpacer(.fixed)
                photoUploadToolbar
            }

            ToolbarSpacer(.fixed)

            if !editMode {
                ToolbarItem {
                    Button("Show on Map", semanticIcon: .goHere) {
                        env.mapCenterCoordinate = pin.position
                        env.currentRoute = .map
                    }
                }
            }

            ToolbarSpacer(.fixed)

            ToolbarItem {
                editButton
            }

            ToolbarSpacer(.fixed)

            ToolbarItem {
                if canDisplayMapView {
                    Button(displayInspector ? "Hide Inspector" : "Show Inspector", semanticIcon: .inspectorToggle) {
                        withAnimation {
                            displayInspector.toggle()
                        }
                    }
                    .keyboardShortcut("/", modifiers: .command)
                }
            }
        }
    }

    private var photoUploadToolbar: some ToolbarContent {
        Group {
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
        }
    }

    private var pinCustomizationMenu: some View {
        Menu("Customize Pin", systemImage: "paintbrush.pointed") {
            #if os(iOS)
                Label("Customize Pin", semanticIcon: .customize)
                    .foregroundStyle(.secondary)
                Divider()
            #endif
            Section {
                Picker("Pin Color", selection: $color) {
                    ForEach(CartographyMapPin.Color.allCases, id: \.self) { color in
                        Group {
                            #if os(iOS)
                                Label(
                                    String(describing: color).localizedCapitalized,
                                    systemImage: "circle.fill"
                                )
                                .tint(color.swiftUIColor)
                            #else
                                Text(String(describing: color).localizedCapitalized)
                            #endif
                        }
                        .tag(color)
                    }
                }
                .pickerStyle(.inline)
            } header: {
                Label("Pin Color", semanticIcon: .colorSelect)
            }
            .labelsVisibility(.visible)

            Button("Select Pin Icon…", semanticIcon: .iconSelect) {
                presentIconPicker.toggle()
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
            _ = url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            await attachImage(data: data)
            url.stopAccessingSecurityScopedResource()
        } catch {
            print(error)
        }
    }

    private func attachImage(data: Data) async {
        let imageName = UUID().uuidString + ".heic"
        if pin.images == nil {
            pin.images = [imageName]
        } else {
            pin.images?.insert(imageName)
        }
        file.images[imageName] = data
    }

    private var mapView: some View {
        Group {
            Divider()
            RedWindowDetailInspector(pin: pin, worldSettings: file.manifest.worldSettings)
        }
        .layoutPriority(1)
    }

    private var editButton: some View {
        Group {
            if editMode {
                Button("Done", systemImage: "checkmark") {
                    withAnimation {
                        editMode.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Edit") {
                    withAnimation {
                        editMode.toggle()
                    }
                }
            }
        }
    }
}
