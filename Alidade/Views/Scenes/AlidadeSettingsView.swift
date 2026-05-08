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

    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                generalSettingsView
            }

            Tab("Feature Flags", systemImage: "flag.pattern.checkered") {
                featureFlagsView
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewSidebarBottomBar {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(Alidade.information.name)")
                        .font(.headline)
                    Text("v\(Alidade.information.version) (\(Alidade.information.buildNumber))")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .frame(minWidth: 200, maxWidth: 250)
        }
        .formStyle(.grouped)
    }

    private var generalSettingsView: some View {
        Form {
            Section {
                Toggle(isOn: $searchAutoFocus) {
                    Text("Automatically focus the search bar when going to the Search tab")
                }
            } header: {
                Text("Search")
            }
        }
        .navigationTitle("General")
    }

    private var featureFlagsView: some View {
        VStack {
            InlineBanner(
                "Here be dragons",
                message: "The following flags control experimental features. Proceed with caution."
            )
            .inlineBannerVariant(.warning)
            FeatureFlagView()
        }
        .navigationTitle("Feature Flags")
    }
}
