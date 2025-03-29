//
//  MapCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import SwiftUI

/// A view used to create and edit Minecraft world maps using the `.mcmap` format.
///
/// This small form is used to collect the world name, Minecraft version, and seed to generate a new file.
///
/// The version string is automatically validated to ensure it is a proper Minecraft version before the binding is
/// updated. Likewise, the seed number can be automatically generated from a string input by using its hash value.
struct MapCreatorForm: View {
    /// A binding to the name of the world.
    @Binding var worldName: String

    /// A binding to the Minecraft version used for world generation.
    @Binding var mcVersion: String

    /// A binding to the seed used for world generation.
    @Binding var seed: Int64

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
                #if os(macOS)
                    TextField("Seed", text: $seedString)
                #else
                    LabeledContent("Seed") {
                        TextField("Seed", text: $seedString)
                            .fontDesign(.monospaced)
                            .textFieldStyle(.plain)
                    }
                #endif
            } header: {
                Text("World Generation")
            } footer: {
                if autoconvert {
                    let hashedString = String(seedString.hashValue)
                    Text("This seed will be converted to: `\(hashedString)`")
                }
            }
            .onChange(of: version) { _, newValue in
                if let verString = String(newValue) {
                    self.mcVersion = verString
                }
            }
            .onChange(of: seedString) { _, newValue in
                if let realNumber = Int64(newValue) {
                    seed = realNumber
                    autoconvert = false
                } else {
                    let isEmptyField = newValue == ""
                    seed = isEmptyField ? 0 : Int64(newValue.hashValue)
                    autoconvert = !isEmptyField
                }
            }
        }
        .onAppear {
            version = MinecraftVersion(mcVersion)
            seedString = String(seed)
            #if DEBUG
                self.didAppear?(self)
            #endif
        }
    }
}

#Preview {
    @Previewable @State var worldName = "Hello World"
    @Previewable @State var mcVersion = "1.21.3"
    @Previewable @State var seed: Int64 = 123
    NavigationStack {
        MapCreatorForm(worldName: $worldName, mcVersion: $mcVersion, seed: $seed)
            .navigationTitle("New World")
    }
}

#if DEBUG
    extension MapCreatorForm {
        var testHooks: TestHooks { TestHooks(target: self) }

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
