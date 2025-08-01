//
//  BluemapIntegrationFormSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import AlidadeUI
import MCMap
import SwiftUI

/// A form section that allows players to edit settings for integrations with Bluemap.
///
/// This section generally isn't used on its own, but as part of a larger form, such as with the ``MapCreatorForm``.
struct BluemapIntegrationFormSection: View {
    /// The Bluemap integration settings to edit in this form.
    @Binding var integration: MCMapBluemapIntegration

    var body: some View {
        Section {
            FormHeader(name: "bluemap") {
                Text("Bluemap")
            } description: {
                // swiftlint:disable:next line_length
                Text("Show common points of interest and where players are on your Minecraft server from the Bluemap plugin.\n[Learn more…](http://example.com)")
            }
            Toggle("Enable Integration", isOn: $integration.enabled)
        } footer: {
            Text(
                "Enabling this integration will allow Alidade to make requests to the Bluemap server listed below."
            )
        }

        Section {
            NamedTextField("Host", text: $integration.baseURL)
                .disabled(!integration.enabled)
            #if os(iOS)
                .keyboardType(.URL)
            #endif
            Stepper(
                "Refresh every: ^[\(Int(integration.refreshRate)) second](inflect: true)",
                value: $integration.refreshRate,
                in: 5...120,
                step: 5
            )
            .foregroundStyle(integration.enabled ? .primary : .secondary)
            Toggle("Realtime Sync", isOn: $integration.realtime)
        } header: {
            Text("Bluemap Server")
        } footer: {
            Text("Update player locations more frequently with Realtime Sync. [Learn more…](https://example.com)")
        }
        .disabled(!integration.enabled)

        Section {
            NamedTextField("Overworld", text: $integration.mapping.overworld)
            NamedTextField("Nether", text: $integration.mapping.nether)
            NamedTextField("End", text: $integration.mapping.end)
        } header: {
            Text("Dimensions")
        }
        .disabled(!integration.enabled)

        Section {
            Toggle("Player Markers", isOn: $integration.display.displayPlayers)
            Toggle("Player Death Markers", isOn: $integration.display.displayDeathMarkers)
            Toggle("Points of Interest", isOn: $integration.display.displayMarkers)
        } header: {
            Text("Display")
        }
        .disabled(!integration.enabled)
    }
}

#if os(iOS)
#Preview {
    @Previewable @State var integration = MCMapBluemapIntegration(baseURL: "mcmap.augenwaldburg.com")
    NavigationStack {
        Form {
            BluemapIntegrationFormSection(integration: $integration)
        }
        .navigationTitle("Bluemap")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
