//
//  AlidadeSettingsView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-06-2025.
//

import AlidadeUI
import SwiftUI
import FeatureFlags

/// A view that displays the app's settings.
///
/// This view is only applicable to macOS, as going to **Alidade &rsaquo; Settings...** will display this view. On iOS
/// and iPadOS, the settings are stored in the Settings app via **Settings &rsaquo; Apps &rsaquo; Alidade**, and the
/// user interface is driven by the Settings bundle for this app.
@available(macOS 15.0, *)
struct AlidadeSettingsView: View {
    @AppStorage(UserDefaults.Keys.generalMacSearchAutofocus.rawValue)
    private var searchAutoFocus = true

    @AppStorage(FeatureFlag.drawings.keyName)
    private var flagDrawings = false

    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                generalSettingsView
            }

            Tab("Feature Flags", systemImage: "flag.pattern.checkered") {
                featureFlagsView
            }
        }
        .frame(maxWidth: 450, minHeight: 300)
    }

    private var generalSettingsView: some View {
        Form {
            Toggle(isOn: $searchAutoFocus) {
                Text("Automatically focus the search bar when going to the Search tab")
            }
        }
        .formStyle(.grouped)
    }

    private var featureFlagsView: some View {
        VStack {
            InlineBanner(
                "Here be dragons",
                message: "The following flags control experimental features. Proceed with caution."
            )
            .inlineBannerVariant(.warning)
            .padding(.top)
            Form {
                Toggle(isOn: $flagDrawings) {
                    Text("Map Drawings")
                }
            }
            .formStyle(.grouped)
        }
    }
}
