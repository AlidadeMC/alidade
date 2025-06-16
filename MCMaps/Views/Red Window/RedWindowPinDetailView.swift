//
//  RedWindowPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import SwiftUI

struct RedWindowPinDetailView: View {
    var pin: MCMapManifestPin

    @State private var description = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                    .backgroundExtensionEffectIfAvailable()
                Group {
                    TextEditor(text: $description)
                        .frame(minHeight: 200)
                        .overlay(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Write a description about this pin.")
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 4)
                                    .padding(.top, 8)
                            }
                        }
                    Text("Gallery")
                        .font(.title2)
                        .bold()
                    ContentUnavailableView("No Photos Uploaded", systemImage: "photo.stack")
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(pin.name)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem {
                Button {
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
            }

            ToolbarItem {
                Menu("Add Photos", systemImage: "photo.badge.plus") {
                    Button("From Photos") {}
                    Button("From Files") {}
                }
            }

            ToolbarItem {
                Menu("Pin Color", systemImage: "paintpalette") {
                    ForEach(MCMapManifestPin.Color.allCases, id: \.self) { color in
                        Text(String(describing: color).localizedCapitalized)
                    }
                }
            }
        }
    }

    private var header: some View {
        Rectangle()
            .fill(
                Color(pin.color?.swiftUIColor ?? .accent)
                    .gradient
            )
            .frame(height: 300)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(pin.name)
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .bold()
                    Text("(\(pin.position.x), \(pin.position.y))")
                        .font(.headline)
                }
                .padding([.leading, .bottom])
            }
    }
}
