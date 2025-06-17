//
//  RedWindowPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinDetailView: View {
    @Environment(\.tabBarPlacement) var tabBarPlacement
    var pin: MCMapManifestPin

    @State private var description = ""
    @State private var tags = Set<String>()
    @State private var displayAlert = false
    @State private var center = CGPoint.zero

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    header
                    Group {
                        Group {
                            Text("About this Place")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                            TextEditor(text: $description)
                                .frame(minHeight: 200)
                                .overlay(alignment: .topLeading) {
                                    if description.isEmpty {
                                        Text("Write a description about this place.")
                                            .foregroundStyle(.secondary)
                                            .padding(.leading, 4)
                                            .padding(.top, 8)
                                    }
                                }
                        }

                        Group {
                            Text("Tags")
                                .font(.title3)
                                .bold()
                                .padding(.top)
                            if let tags = pin.tags, !tags.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(Array(tags), id: \.self) { tag in
                                            Text(tag)
                                                .padding(.horizontal)
                                                .padding(.vertical, 3)
                                                .background(Capsule().fill(.secondary.opacity(0.25)))
                                        }
                                    }
                                }
                            } else {
                                Text("No tags for this place.")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Group {
                            Text("Gallery")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                            ContentUnavailableView("No Photos Uploaded", systemImage: "photo.stack")
                        }

                    }
                    .padding(.horizontal)
                }
            }

            if tabBarPlacement == .topBar {
                Divider()
                Group {
                    if let world = try? MinecraftWorld(version: "1.21.3", seed: 184_719_632_014) {
                        MinecraftMap(world: world, centerCoordinate: $center) {
                            Marker(
                                location: pin.position,
                                title: pin.name,
                                color: pin.color?.swiftUIColor ?? .accent
                            )
                        }
                        .mapColorScheme(.natural)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(idealWidth: 300, maxWidth: 375, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(edges: .vertical)
        .animation(.interactiveSpring, value: tabBarPlacement)
        .task {
            center = pin.position
        }
        .alert("Are you sure you want to delete \(pin.name)?", isPresented: $displayAlert) {
            Button("Delete Pin", role: .destructive) {}
            Button("Don't Remove", role: .cancel) {}
        } message: {
            Text("Deleting this pin will also remove any images associated with this pin.")
        }
        .toolbar {
            ToolbarItem {
                Button("Go Here", systemImage: "location") {}
            }

            #if RED_WINDOW
                if #available(macOS 16, iOS 19, *) {
                    ToolbarSpacer(.fixed)
                }
            #endif

            ToolbarItem {
                Button {
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
            }

            ToolbarItem {
                Menu("Add Photos", systemImage: "photo.badge.plus") {
                    Button("From Photos", systemImage: "photo.on.rectangle.angled") {}
                    Button("From Files", systemImage: "folder") {}
                }
            }

            ToolbarItem {
                Menu("Pin Color", systemImage: "paintpalette") {
                    ForEach(MCMapManifestPin.Color.allCases, id: \.self) { color in
                        Text(String(describing: color).localizedCapitalized)
                    }
                }
            }

            ToolbarItem {
                Button("Manage Tags", systemImage: "tag") {}
            }

            #if RED_WINDOW
                if #available(macOS 16, iOS 19, *) {
                    ToolbarSpacer(.fixed)
                }
            #endif

            ToolbarItem {
                Button("Delete Pin", systemImage: "trash", role: .destructive) {
                    displayAlert.toggle()
                }
            }
        }
    }

    private var header: some View {
        Rectangle()
            .fill(
                Color(pin.color?.swiftUIColor ?? .accent)
                    .opacity(0.85)
                    .gradient
            )
            .frame(height: 300)
            .backgroundExtensionEffectIfAvailable()
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(pin.name)
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .bold()
                    Text("(\(Int(pin.position.x)), \(Int(pin.position.y)))")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding([.leading, .bottom])
            }
    }
}
