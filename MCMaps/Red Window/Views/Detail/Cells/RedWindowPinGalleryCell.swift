//
//  RedWindowPinGallerySection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

struct RedWindowPinGalleryCell: RedWindowDetailCell {
    @Binding var pin: MCMapManifestPin
    @Binding var isEditing: Bool
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
