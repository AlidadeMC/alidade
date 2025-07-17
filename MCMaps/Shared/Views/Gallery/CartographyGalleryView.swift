//
//  CartographyGalleryView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import AlidadeUI
import MCMapFormat
import QuickLook
import SwiftUI

/// A view that displays a collection of images from a file.
///
/// This view is used to display the app's gallery feature. Players can tap on images to open them in detail to mark
/// them up and/or share with friends.
struct CartographyGalleryView: View {
    /// A type alias pointing to the context that configures this view.
    typealias Context = CartographyGalleryWindowContext

    /// The context that configures this view.
    var context: Context

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 180, maximum: .infinity), spacing: 2)]
    }

    @Namespace private var namespace
    @State private var scaledToFill = true
    @State private var currentPhotoURL: URL?

    var body: some View {
        Group {
            if context.imageCollection.isEmpty {
                ContentUnavailableView(
                    "Gallery is Empty", systemImage: "photo.stack",
                    description: Text("Photos you add to your pinned places will appear here."))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(RandomAccessDictionary(context.imageCollection)) { element in
                            Button {
                                prepareQuickLook(forImageNamed: element.key)
                            } label: {
                                cell(for: element.value)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Preview Image") {
                                    prepareQuickLook(forImageNamed: element.key)
                                }
                                ShareLink(
                                    item: element.value,
                                    preview: SharePreview(
                                        element.key,
                                        image: Image(
                                            data: element.value
                                        )
                                    )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
        .quickLookPreview($currentPhotoURL)
        .navigationTitle("Gallery")
        #if os(macOS)
        .navigationSubtitle(context.documentBaseURL?.lastPathComponent ?? "Untitled Map")
        #endif
        .animation(.interactiveSpring, value: scaledToFill)
        .toolbar {
            ToolbarItem {
                Button(
                    "Scale",
                    systemImage: scaledToFill ? "rectangle.arrowtriangle.2.inward" : "rectangle.arrowtriangle.2.outward"
                ) {
                    withAnimation {
                        scaledToFill.toggle()
                    }
                }
                .contentTransition(.symbolEffect(.replace))
            }
        }
    }

    private func cell(for image: Data) -> some View {
        Image(data: image)
            .resizable()
            .aspectRatio(contentMode: scaledToFill ? .fill : .fit)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .aspectRatio(1, contentMode: .fit)
    }

    private func prepareQuickLook(forImageNamed imageName: String) {
        guard let baseURL = context.documentBaseURL else { return }
        currentPhotoURL = baseURL.appending(components: CartographyMapFile.Keys.images, imageName)
    }
}
