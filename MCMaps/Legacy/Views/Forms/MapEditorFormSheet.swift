//
//  MapEditorFormSheet.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import CubiomesKit
import MCMapFormat
import SwiftUI

/// A sheet that displays the ``MapCreatorForm`` used to automatically edit changes to a world.
///
/// This is typically used to display the editor as a modal on macOS.
///
/// - SeeAlso: Refer to the documentation for ``MapCreatorForm`` for usage of this view.
struct MapEditorFormSheet: View {
    /// The file that is being actively edited.
    @Binding var file: CartographyMapFile

    /// A callback that executes when the player is submitting changes.
    var onSubmitChanges: (() -> Void)?

    /// A callback that executes when the player is cancelling the current operation.
    var onCancelChanges: (() -> Void)?

    var body: some View {
        NavigationStack {
            MapCreatorForm(worldName: $file.manifest.name, worldSettings: $file.manifest.worldSettings)
            .formStyle(.grouped)
            .navigationTitle("Update World")
            #if os(iOS)
                .navigationBarBackButtonHidden()
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSubmitChanges?()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancelChanges?()
                    }
                }
            }
        }
    }
}
