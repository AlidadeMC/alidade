//
//  RedWindowDescriptionCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMapFormat
import SwiftUI

/// The cell used to display and edit a pin's description.
struct RedWindowDescriptionCell: RedWindowDetailCell {
    /// The pin whose description is being modified.
    @Binding var pin: MCMapManifestPin

    /// Whether the edit mode has been activated.
    @Binding var isEditing: Bool

    /// The file that contains the pin being edited.
    @Binding var file: CartographyMapFile

    @State private var description = ""

    var body: some View {
        Group {
            Text("About this Place")
                .font(.title2)
                .bold()
                .padding(.top)
            if isEditing {
                TextEditor(text: $description)
                    .frame(minHeight: 200)
                    .overlay(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Write a description about this place.")
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)
                                .padding(.top, 8)
                        }
                    }
            } else {
                Group {
                    if description.isEmpty {
                        ContentUnavailableView(
                            "No Description Written",
                            systemImage: "pencil",
                            description: Text("Write a description for what makes this place special."))
                    } else {
                        Text(description)
                            .padding(.top)
                    }
                }
                .fontDesign(.serif)
            }
        }
        .task {
            if let aboutDescription = pin.aboutDescription {
                description = aboutDescription
            }
        }
        .onChange(of: description, initial: false) { _, newValue in
            pin.aboutDescription = newValue
        }
    }
}
