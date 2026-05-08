//
//  FeatureFlagView.swift
//  FeatureFlags
//
//  Created by Marquis Kurt on 07-05-2026.
//

import SwiftUI

/// A view that allows players to manage specific feature flags in the app.
@available(macOS 14, iOS 17, *)
public struct FeatureFlagView: View {
    @AppStorage(FeatureFlag.drawings.keyName)
    private var flagDrawings = false

    @AppStorage(FeatureFlag.collaborations.keyName)
    private var collaborationFeatures = false

    public init() {}

    public var body: some View {
        Form {
            Toggle(isOn: $flagDrawings) {
                Text("Map Drawings")
            }
            Toggle(isOn: $collaborationFeatures) {
                Text("Document Collaboration")
            }
        }
        .formStyle(.grouped)
        .toolbar {
            Button("Reset") {
                resetFlagsToDefaults()
            }
        }
    }

    private func resetFlagsToDefaults() {
        flagDrawings = FeatureFlag.drawings.isEnabledByDefault
        collaborationFeatures = FeatureFlag.drawings.isEnabledByDefault
    }
}
