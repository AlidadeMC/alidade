//
//  RedWindowPinTagsCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import Bedrock
import MCMap
import SwiftUI

/// The cell used to display the tags associated with a given pin.
///
/// This cell is read-only, and the ``isEditing`` property has no effect on this cell.
struct RedWindowPinTagsCell: RedWindowDetailCell {
    /// The pin to display the tags for.
    @Binding var pin: CartographyMapPin

    /// Whether the view is in editing mode.
    /// - Note: This property has no effect on this view.
    @Binding var isEditing: Bool

    /// The file containing the pin being displayed.
    @Binding var file: CartographyMapFile

    var body: some View {
        Group {
            Text("Tags")
                .font(.system(.title3, design: .serif))
                .bold()
                .padding(.top)
            if let tags = pin.tags, tags.isNotEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(tags), id: \.self) { tag in
                            Label(tag, systemImage: "tag")
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                                .padding(2)
                                .background(Capsule().fill(.secondary.opacity(0.25)))
                                .fontDesign(.serif)
                        }
                    }
                }
            } else {
                Text("No tags for this place.")
                    .fontDesign(.serif)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
