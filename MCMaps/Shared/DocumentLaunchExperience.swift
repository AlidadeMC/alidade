//
//  DocumentLaunchExperience.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-01-2026.
//

import DocumentKitSwiftUI
import MCMap
import SwiftUI

struct DocumentLaunchScene: Scene {
    @Binding var proxyMap: CartographyMapFile.Manifest

    var body: some Scene {
        #if os(macOS)
            DocumentLaunchView(Self.appName, creating: CartographyMapFile(withManifest: .sampleFile)) {
                EmptyView()
            } background: {
                Image(.packMcmeta)
                    .resizable()
                    .scaledToFill()
            }
            .appIcon("App Pin Static")
            .displayCreationForm {
                MapCreatorForm(
                    worldName: $proxyMap.name,
                    worldSettings: $proxyMap.worldSettings,
                    integrations: .constant(CartographyMapFile(withManifest: .sampleFile).integrations)
                )
            }
        #else
            DocumentLaunchView(proxyMap: $proxyMap)
        #endif
    }
}

#if os(iOS)
    /// A launch view that lets players create and open files easily.
    ///
    /// This will generally be displayed when the app is first loaded.
    struct DocumentLaunchView: Scene {
        typealias DocumentContinuation = CheckedContinuation<CartographyMapFile, any Error>
        @State private var creationContinuation: DocumentContinuation?

        @State private var displayCreationWindow = false

        @Binding var proxyMap: CartographyMapFile.Manifest

        var body: some Scene {
            DocumentGroupLaunchScene {
                NewDocumentButton("Create Map", for: CartographyMapFile.self) {
                    try await withCheckedThrowingContinuation { (continuation: DocumentContinuation) in
                        self.creationContinuation = continuation
                        displayCreationWindow.toggle()
                    }
                }
                .sheet(isPresented: $displayCreationWindow) {
                    NavigationStack {
                        MapCreatorForm(
                            worldName: $proxyMap.name,
                            worldSettings: $proxyMap.worldSettings,

                            // We pass a constant here because this won't be displayed anyway.
                            integrations: .constant(CartographyMapFile(withManifest: .sampleFile).integrations)
                        )
                        .navigationTitle("Create Map")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Create") {
                                    let file = CartographyMapFile(withManifest: proxyMap)
                                    creationContinuation?
                                        .resume(returning: file)
                                    creationContinuation = nil
                                    displayCreationWindow = false
                                }
                            }

                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    creationContinuation?.resume(throwing: CocoaError(CocoaError.userCancelled))
                                    creationContinuation = nil
                                    displayCreationWindow = false
                                }
                            }
                        }
                    }
                }
            } background: {
                Image(.packMcmeta)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
#endif
