//
//  RedWindowMapWarpForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 21-06-2025.
//

import SwiftUI

/// A form used to let players jump to a specific location on the map.
///
/// In previous versions of the app, this action was achieved through search. However, because search has been
/// separated into a different tab, this form is displayed instead. Upon submission of the form, the environment is
/// updated to reflect the new changes.
struct RedWindowMapWarpForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    @State private var xCoordinate = 0
    @State private var zCoordinate = 0

    var body: some View {
        Form {
            #if os(iOS)
            LabeledContent("X Coordinate") {
                TextField("X", value: $xCoordinate, format: .number)
            }
            LabeledContent("Z Coordinate") {
                TextField("Z", value: $zCoordinate, format: .number)
            }
            #else
            TextField("X", value: $xCoordinate, format: .number)
            TextField("Z", value: $zCoordinate, format: .number)
            #endif
        }
        #if os(macOS)
            .formStyle(.grouped)
        #endif
        .navigationTitle("Go To Coordinate")
        .toolbar {
            ToolbarItem {
                if #available(iOS 19, macOS 16, *) {
                    Button("Go", systemImage: "checkmark", role: .confirm) {
                        redWindowEnvironment.mapCenterCoordinate = CGPoint(x: xCoordinate, y: zCoordinate)
                        dismiss()
                    }
                } else {
                    Button("Go") {
                        redWindowEnvironment.mapCenterCoordinate = CGPoint(x: xCoordinate, y: zCoordinate)
                        dismiss()
                    }
                }
            }
        }
    }
}
