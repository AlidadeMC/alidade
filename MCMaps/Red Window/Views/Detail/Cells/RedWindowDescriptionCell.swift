//
//  RedWindowDescriptionCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

struct RedWindowDescriptionCell: RedWindowDetailCell {
    @Binding var pin: MCMapManifestPin
    @Binding var isEditing: Bool
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
