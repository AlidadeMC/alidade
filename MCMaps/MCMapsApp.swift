//
//  MCMapsApp.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

#if os(iOS)
func hideNavigationBar() {
    let activeScene = UIApplication.shared.connectedScenes
                 .filter({$0.activationState == .foregroundActive})
                 .first
                
    if let windowScene = activeScene as? UIWindowScene {
        guard let currentWindow = windowScene.keyWindow else { return }
        if let navController = currentWindow.rootViewController as? UINavigationController {
            navController.isNavigationBarHidden = true
        }
    }
}
#endif

@main
struct MCMapsApp: App {
    @State private var creationContinuation: CheckedContinuation<CartographyMapFile?, any Error>?
    @State private var displayCreationWindow = false
    @State private var proxyMap = CartographyMap(seed: 0, mcVersion: "1.21", name: "My World", pins: [])
    
    var body: some Scene {
        DocumentGroup(newDocument: CartographyMapFile(map: .sampleFile)) { configuration in
            ContentView(file: configuration.$document)
                .toolbarRole(.editor)
            #if os(iOS)
                .toolbarVisibility(.hidden, for: .navigationBar)
            #endif
        }
        
        #if os(iOS)
        DocumentGroupLaunchScene {
            NewDocumentButton("Create Map", for: CartographyMapFile.self) {
                try await withCheckedThrowingContinuation { continuation in
                    self.creationContinuation = continuation
                    self.displayCreationWindow = true
                }
            }
            .sheet(isPresented: $displayCreationWindow) {
                NavigationStack {
                    MapCreatorForm(worldName: $proxyMap.name, mcVersion: $proxyMap.mcVersion, seed: $proxyMap.seed)
                        .navigationTitle("Create Map")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Create") {
                                    creationContinuation?.resume(returning: .init(map: proxyMap))
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
        #endif
    }
}
