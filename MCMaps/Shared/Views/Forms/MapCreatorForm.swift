//
//  MapCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import AlidadeUI
import CubiomesKit
import MCMap
import SwiftUI

/// A view used to create and edit Minecraft world maps using the `.mcmap` format.
///
/// This small form is used to collect the world name, Minecraft version, and seed to generate a new file.
///
/// The version string is automatically validated to ensure it is a proper Minecraft version before the binding is
/// updated. Likewise, the seed number can be automatically generated from a string input by using its hash value.
struct MapCreatorForm: View {
    enum DisplayMode {
        case create, edit
    }

    /// A binding to the name of the world.
    @Binding var worldName: String

    /// A binding to the world settings for a Minecraft world.
    @Binding var worldSettings: MCMapManifestWorldSettings

    @Binding var integrations: CartographyMapFile.Integrations

    var displayMode: DisplayMode = .create

    @Environment(\.colorScheme) private var colorScheme

    @State private var seedString = ""
    @State private var invalidVersion = false
    @State private var autoconvert = false
    @State private var version = MC_1_21_WD

    #if DEBUG
        internal var didAppear: ((Self) -> Void)?
    #endif

    var body: some View {
        Form {
            TextField("Name", text: $worldName)
            Section {
                Picker("Minecraft Version", selection: $version) {
                    ForEach(MinecraftVersion.allCases, id: \.rawValue) { ver in
                        Text(String(ver) ?? "?").tag(ver)
                    }
                }
                NamedTextField("Seed", text: $seedString)
                Toggle(isOn: $worldSettings.largeBiomes) {
                    Text("Large Biomes")
                }
            } header: {
                Text("World Generation")
            } footer: {
                if autoconvert {
                    let hashedString = String(seedString.hashValue)
                    Text("This seed will be converted to: `\(hashedString)`")
                }
            }
            .onChange(of: version, initial: false) { _, newValue in
                if let verString = String(newValue), worldSettings.version != verString {
                    worldSettings.version = verString
                }
            }
            .onChange(of: seedString, initial: false) { _, newValue in
                var seed: Int64
                if let realNumber = Int64(newValue) {
                    seed = realNumber
                    autoconvert = false
                } else {
                    let isEmptyField = newValue == ""
                    seed = isEmptyField ? 0 : Int64(newValue.hashValue)
                    autoconvert = !isEmptyField
                }
                if seed != worldSettings.seed {
                    worldSettings.seed = seed
                }
            }

            #if os(iOS)
                // swiftlint:disable line_length
                InlineBanner(
                    "Alidade works with Minecraft: Java Edition.",
                    message: "Maps that use version numbers and seeds from _Minecraft: Java Edition_ will work with Alidade. Minecraft (Bedrock) is currently not supported.")
                // swiftlint:enable line_length
                .inlineBannerVariant(.information)
            #endif

            if displayMode == .edit {
                Group {
                    Section {
                        NavigationLink {
                            Form {
                                BluemapIntegrationFormSection(
                                    integration: $integrations.bluemap
                                )
                            }
                            .navigationTitle("Bluemap")
                            #if os(macOS)
                            .formStyle(.grouped)
                            #endif
                        } label: {
                            Label {
                                Text("Bluemap")
                            } icon: {
                                Image("bluemap")
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .clipShape(.buttonBorder)
                            }

                        }

                    } header: {
                        Text("Integrations")
                    }
                }
            }
        }
        .onAppear {
            version = MinecraftVersion(worldSettings.version)
            seedString = String(worldSettings.seed)
            #if DEBUG
                self.didAppear?(self)
            #endif
        }
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(withManifest: .sampleFile)
    NavigationStack {
        MapCreatorForm(
            worldName: $file.manifest.name,
            worldSettings: $file.manifest.worldSettings,
            integrations: $file.integrations,
            displayMode: .edit
        )
            .navigationTitle("New World")
    }
}

#if DEBUG
    extension MapCreatorForm {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: MapCreatorForm

            fileprivate init(target: MapCreatorForm) {
                self.target = target
            }

            var seedString: String { target.seedString }
            var invalidVersion: Bool { target.invalidVersion }
            var autoconvert: Bool { target.autoconvert }
        }
    }
#endif
