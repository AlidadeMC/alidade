//
//  MapEditorFormSheet.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import CubiomesKit
import SwiftUI

struct MapEditorFormSheet: View {
    @Binding var file: CartographyMapFile

    var onSubmitChanges: (() -> Void)?
    var onCancelChanges: (() -> Void)?

    var body: some View {
        NavigationStack {
            MapCreatorForm(worldName: $file.map.name, mcVersion: $file.map.mcVersion, seed: $file.map.seed)
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
