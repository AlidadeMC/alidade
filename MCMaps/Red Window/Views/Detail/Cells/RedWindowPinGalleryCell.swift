//
//  RedWindowPinGallerySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMapFormat
import SwiftUI

/// The cell used to display the images associated with this pin.
///
/// This is a read-only cell, and the ``isEditing`` property has no effect on this view.
struct RedWindowPinGalleryCell: RedWindowDetailCell {
    /// The pin from whose images are being displayed.
    @Binding var pin: MCMapManifestPin

    /// Whether the view is in editing mode.
    /// - Note: This property has no effect on this view.
    @Binding var isEditing: Bool

    /// The file that contains the pin and images being displayed.
    @Binding var file: CartographyMapFile

    var body: some View {
        Group {
            Text("Gallery")
                .font(.title2)
                .bold()
                .padding(.top)
            if let images = pin.images, !images.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            if let imageData = getImage(named: image) {
                                Image(data: imageData)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minHeight: 150, maxHeight: 200)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView("No Photos Uploaded", systemImage: "photo.stack")
            }
        }
    }

    private func getImage(named name: String) -> Data? {
        return file.images[name]
    }
}
