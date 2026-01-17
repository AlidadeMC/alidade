//
//  RedWindowDescriptionCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMap
import SwiftUI

/// The cell used to display and edit a pin's description.
struct RedWindowDescriptionCell: RedWindowDetailCell {
    /// The pin whose description is being modified.
    @Binding var pin: CartographyMapPin

    /// Whether the edit mode has been activated.
    @Binding var isEditing: Bool

    /// The file that contains the pin being edited.
    @Binding var file: CartographyMapFile

    var body: some View {
        Group {
            Text("About this Place")
                .font(.system(.title2, design: .serif))
                .bold()
                .padding(.top)
            if isEditing {
                TextEditor(text: $pin.description)
                    .textFieldStyle(.roundedBorder)
                    .frame(minHeight: 200)
                    .overlay(alignment: .topLeading) {
                        if pin.description.isEmpty {
                            Text("Write a description about this place.")
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)
                                .padding(.top, 8)
                        }
                    }
            } else {
                Group {
                    if pin.description.isEmpty {
                        ContentUnavailableView(
                            "No Description Written",
                            systemImage: "pencil",
                            description: Text("Write a description for what makes this place special."))
                    } else {
                        Text(pin.description)
                            .padding(.top)
                    }
                }
                .fontDesign(.serif)
            }
        }
    }
}
