//
//  DocumentLaunchView+Mobile.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-03-2025.
//

import SwiftUI

#if os(iOS)
    /// A launch view that lets players create and open files easily.
    ///
    /// This will generally be displayed when the app is first loaded.
    @available(iOS 18.0, *)
    struct DocumentLaunchView: Scene {
        @State private var creationContinuation: CheckedContinuation<CartographyMapFile?, any Error>?
        /// Whether the creation window should be visible.
        ///
        /// Applicable to iOS and iPadOS.
        @Binding var displayCreationWindow: Bool

        /// The proxy map used to create a file temporarily.
        ///
        /// Applicable to iOS and iPadOS.
        @Binding var proxyMap: CartographyMap

        var body: some Scene {
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
        }
    }

    #if DEBUG
        extension DocumentLaunchView {
            var testHooks: TestHooks { TestHooks(target: self) }

            struct TestHooks {
                private let target: DocumentLaunchView

                fileprivate init(target: DocumentLaunchView) {
                    self.target = target
                }
                @available(iOS 18.0, *)
                var creationContinuation: CheckedContinuation<CartographyMapFile?, any Error>? {
                    target.creationContinuation
                }
            }
        }
    #endif
#endif

private struct DocumentLaunchViewButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
            .controlSize(.extraLarge)
            .buttonStyle(.borderless)
            .bold()
            .clipped()
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func documentLaunchViewButtonStyle() -> some View {
        self.modifier(DocumentLaunchViewButtonModifier())
    }
}
