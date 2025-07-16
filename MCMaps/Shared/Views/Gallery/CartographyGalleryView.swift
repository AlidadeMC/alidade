//
//  CartographyGalleryView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import AlidadeUI
import MCMapFormat
import SwiftUI

struct CartographyGalleryView: View {
    var context: CartographyGalleryWindowContext

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 180, maximum: .infinity), spacing: 2)]
    }

    @State private var scaledToFill = true

    var body: some View {
        Group {
            if context.imageCollection.isEmpty {
                ContentUnavailableView(
                    "Gallery is Empty", systemImage: "photo.stack",
                    description: Text("Photos you add to your pinned places will appear here."))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(Array(context.imageCollection.values), id: \.self) { image in
                            Image(data: image)
                                .resizable()
                                .aspectRatio(contentMode: scaledToFill ? .fill : .fit)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
        .navigationTitle("Gallery")
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
}
