//
//  AlidadeSettingsView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-06-2025.
//

import AlidadeUI
import SwiftUI

struct AlidadeSettingsView: View {
    @AppStorage(FeatureFlag.redWindow.keyName) private var flagRedWindow = true

    private var isRedWindowActionable: Bool {
        return if #available(macOS 16, iOS 19, *) { true } else { false }
    }

    var body: some View {
        TabView {
            Tab("Feature Flags", systemImage: "flag.pattern.checkered") {
                featureFlagsView
            }
        }
    }

    private var featureFlagsView: some View {
        VStack {
            InlineBanner(
                "Here be dragons",
                message: "The following flags control experimental features. Proceed with caution.")
            .inlineBannerVariant(.warning)
            .padding(.top)
            Form {
                Toggle(isOn: $flagRedWindow) {
                    Text("Liquid Glass Design (Red Window)")
                }
                .disabled(!isRedWindowActionable)
            }
            .formStyle(.grouped)
        }
    }
}
