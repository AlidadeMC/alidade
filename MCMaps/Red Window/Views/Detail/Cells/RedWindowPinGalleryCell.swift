//
//  RedWindowPinGallerySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMap
import SwiftUI
import QuickLook

/// The cell used to display the images associated with this pin.
///
/// This is a read-only cell, and the ``isEditing`` property has no effect on this view.
struct RedWindowPinGalleryCell: RedWindowDetailCell {
    @Environment(\.documentURL) private var documentURL

    /// The pin from whose images are being displayed.
    @Binding var pin: CartographyMapPin

    /// Whether the view is in editing mode.
    /// - Note: This property has no effect on this view.
    @Binding var isEditing: Bool

    /// The file that contains the pin and images being displayed.
    @Binding var file: CartographyMapFile

    @State private var imageToPreview: URL?

    var body: some View {
        Group {
            Text("Gallery")
                .font(.title2)
                .bold()
                .padding(.top)
            if let images = pin.images, !images.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(images), id: \.self) { image in
                            if let imageData = getImage(named: image) {
                                Button {
                                    imageToPreview = getUrl(forImageNamed: image)
                                } label: {
                                    Image(data: imageData)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minHeight: 150, maxHeight: 200)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                ContentUnavailableView("No Photos Uploaded", systemImage: "photo.stack")
            }
        }
        .quickLookPreview($imageToPreview)
    }

    private func getImage(named name: String) -> Data? {
        return file.images[name]
    }

    private func getUrl(forImageNamed name: String) -> URL? {
        documentURL?.appending(components: CartographyMapFile.Keys.images, name)
    }
}
