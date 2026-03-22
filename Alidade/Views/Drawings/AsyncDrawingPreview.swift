//
//  AsyncDrawingPreview.swift
//  Alidade
//
//  Created by Marquis Kurt on 22-03-2026.
//

import MCMap
import PencilKit
import SwiftUI

struct AsyncDrawingPreview: View {
    private enum Constants {
        static let minimumImageSize: CGFloat = 250
    }

    @Environment(\.drawingCache) private var cache
    var drawing: CartographyDrawing

    @State private var image: Image?

    var body: some View {
        Group {
            if let image {
                image
                    .maxFillFit(aspectRatio: 1, contentMode: .fit)
                    .padding(16)
                    .frame(
                        minWidth: Constants.minimumImageSize,
                        maxWidth: .infinity,
                        minHeight: Constants.minimumImageSize,
                        maxHeight: .infinity
                    )
                    .background(Color.gray.opacity(0.5))
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(
                        minWidth: Constants.minimumImageSize,
                        maxWidth: .infinity,
                        minHeight: Constants.minimumImageSize,
                        maxHeight: .infinity
                    )
                    .overlay {
                        Image(systemName: "pencil.and.outline")
                            .font(.largeTitle)
                    }
            }
        }
        .overlay(alignment: .bottomLeading) {
            Label("(\(drawing.data.coordinate.accessibilityReadout))", systemImage: "mappin")
                .font(.headline)
                .padding(8)
        }
        .task(id: drawing, priority: .utility) {
            image = await cache.image(for: drawing)
        }
    }
}
