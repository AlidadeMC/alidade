//
//  RedWindowPinTagsCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

struct RedWindowPinTagsCell: RedWindowDetailCell {
    @Binding var pin: MCMapManifestPin
    @Binding var isEditing: Bool
    @Binding var file: CartographyMapFile

    var body: some View {
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
    }
}
