//
//  MapCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesInternal
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

    @State private var versionString = ""
    @State private var seedString = ""
    @State private var invalidVersion = false
    @State private var autoconvert = false

    #if DEBUG
        internal var didAppear: ((Self) -> Void)?
    #endif

    var body: some View {
        Form {
            TextField("Name", text: $worldName)
            Section {
                TextField("Minecraft Version", text: $versionString)
            } header: {
                Text("Minecraft Version")
            } footer: {
                if invalidVersion {
                    Label("Not a valid Minecraft version.", systemImage: "xmark.circle.fill")
                        .foregroundStyle(Color.red)
                }
            }
            .onSubmit {
                let mcVersion = str2mc(versionString)
                invalidVersion = mcVersion == MC_UNDEF.rawValue
                if !invalidVersion {
                    self.mcVersion = versionString
                }
            }

            Section {
                TextField("Seed", text: $seedString)
            } header: {
                Text("Seed")
            } footer: {
                if autoconvert {
                    let hashedString = String(seedString.hashValue)
                    Text("This seed will be converted to: `\(hashedString)`")
                }
            }
            .onSubmit {
                if let realNumber = Int64(seedString) {
                    seed = realNumber
                    autoconvert = false
                } else {
                    seed = Int64(seedString.hashValue)
                    autoconvert = true
                }
            }
        }
        .onAppear {
            versionString = mcVersion
            seedString = String(seed)
            self.didAppear?(self)
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

            var versionString: String { target.versionString }
            var seedString: String { target.seedString }
            var invalidVersion: Bool { target.invalidVersion }
            var autoconvert: Bool { target.autoconvert }
        }
    }
#endif
