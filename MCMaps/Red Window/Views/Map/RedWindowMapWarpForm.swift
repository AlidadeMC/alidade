//
//  RedWindowMapWarpForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 21-06-2025.
//

import SwiftUI

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
                #if RED_WINDOW
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
                #else
                Button("Go") {
                    redWindowEnvironment.mapCenterCoordinate = CGPoint(x: xCoordinate, y: zCoordinate)
                    dismiss()
                }
                #endif
            }
        }
    }
}
