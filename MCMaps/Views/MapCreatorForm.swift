//
//  MapCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesInternal
import CubiomesKit
import SwiftUI

struct MapCreatorForm: View {
    @Binding var worldName: String
    @Binding var mcVersion: String
    @Binding var seed: Int64

    @State private var versionString = ""
    @State private var seedString = ""
    @State private var invalidVersion = false
    @State private var autoconvert = false

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
