//
//  DrawingPage.swift
//  Alidade
//
//  Created by Marquis Kurt on 22-03-2026.
//

import Bedrock
import BedrockUI
import ImageProcessing
import MCMap
import SwiftUI

struct DrawingPage: View {
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment: RedWindowEnvironment
    @Binding var file: CartographyMapFile

    @State private var cache = DrawingCacheService()
    @State private var deletables = Set<CartographyDrawing>()
    @State private var isEditing = false
    @State private var requestedDeletion = false

    private let columns = [GridItem(.adaptive(minimum: 250), spacing: 2)]

    var body: some View {
        @Bindable var env = redWindowEnvironment

        NavigationStack {
            if file.drawings.isNotEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(file.drawings) { drawing in
                            cell(for: drawing, in: env)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding([.leading, .trailing, .bottom], 4)
                }
                .navigationTitle("Drawings")
                .animation(.interactiveSpring, value: isEditing)
                .animation(.interactiveSpring, value: requestedDeletion)
                .animation(.interactiveSpring, value: deletables)
                .toolbar {
                    if isEditing {
                        ToolbarItem {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                requestedDeletion.toggle()
                            }
                            .disabled(deletables.isEmpty)
                        }
                    }

                    ToolbarItem {
                        if isEditing {
                            Button("Done", systemImage: "checkmark", role: .confirm) {
                                deletables.removeAll()
                                isEditing.toggle()
                            }
                            .labelStyle(.iconOnly)
                            .buttonBorderShape(.circle)
                            .buttonStyle(.glassProminent)
                        } else {
                            Button("Select") {
                                isEditing.toggle()
                            }
                            .bold()
                        }
                    }
                }
                .confirmationDialog(
                    "Are you sure you want to delete \(deletables.count > 1 ? "these drawings" : "this drawing")?",
                    isPresented: $requestedDeletion,
                    presenting: deletables
                ) { set in
                    Button("Delete ^[\(set.count) Drawing](inflect: true)", role: .destructive) {
                        requestedDeletion.toggle()
                        for drawing in set {
                            delete(drawing: drawing)
                        }
                        if isEditing {
                            isEditing = false
                        }
                    }
                    Button("Don't Delete", role: .cancel) {
                        requestedDeletion.toggle()
                    }
                } message: { set in
                    Text(
                        // swiftlint:disable:next line_length
                        "^[\(set.count) drawing](inflect: true) will no longer be displayed on the map, and you will no longer be able to access them in this document."
                    )
                }
            } else {
                ContentUnavailableView(
                    "No Drawings Available",
                    systemImage: "pencil.and.outline",
                    description: Text("Any drawings you add to your map will be available here."))
            }
        }
    }

    @ViewBuilder
    private func cell(for drawing: CartographyDrawing, in env: RedWindowEnvironment) -> some View {
        Button {
            if isEditing {
                deletables.toggle(drawing)
            } else {
                showDrawingOnMap(drawing, environment: env)
            }
        } label: {
            AsyncDrawingPreview(drawing: drawing)
                .overlay(alignment: .bottomTrailing) {
                    if isEditing {
                        CheckmarkImage(isSelected: deletables.contains(drawing))
                            .background(
                                Circle()
                                    .fill(.white)
                                    .opacity(deletables.contains(drawing) ? 1 : 0)
                            )
                            .padding(8)
                    }
                }
        }
        .contextMenu {
            Button("Show on Map", semanticIcon: .goHere) {
                showDrawingOnMap(drawing, environment: env)
            }
            Button("Delete", systemImage: "trash", role: .destructive) {
                deletables = [drawing]
                requestedDeletion.toggle()
            }
        }
    }

    private func showDrawingOnMap(_ drawing: CartographyDrawing, environment env: RedWindowEnvironment) {
        withAnimation {
            env.mapCenterCoordinate = drawing.data.coordinate
            env.currentRoute = .map
        }
    }

    private func delete(drawing: CartographyDrawing) {
        guard let index = file.drawings.firstIndex(of: drawing) else {
            return
        }
        file.drawings.remove(at: index)
    }
}
