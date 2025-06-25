//
//  DocumentLaunchView+Mobile.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-03-2025.
//

import MCMapFormat
import SwiftUI

#if os(iOS)
    /// A launch view that lets players create and open files easily.
    ///
    /// This will generally be displayed when the app is first loaded.
    @available(iOS 18.0, *)
    struct DocumentLaunchView: Scene {
        typealias DocumentContinuation = CheckedContinuation<CartographyMapFile, any Error>
        @State private var creationContinuation: DocumentContinuation?

        var viewModel: DocumentLaunchViewModel

        var body: some Scene {
            DocumentGroupLaunchScene {
                NewDocumentButton("Create Map", for: CartographyMapFile.self) {
                    try await withCheckedThrowingContinuation { (continuation: DocumentContinuation) in
                        self.creationContinuation = continuation
                        self.viewModel.displayCreationWindow.wrappedValue = true
                    }
                }
                .sheet(isPresented: viewModel.displayCreationWindow) {
                    NavigationStack {
                        MapCreatorForm(
                            worldName: viewModel.proxyMap.name,
                            worldSettings: viewModel.proxyMap.worldSettings
                        )
                            .navigationTitle("Create Map")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Create") {
                                        let file = CartographyMapFile(withManifest: viewModel.proxyMap.wrappedValue)
                                        creationContinuation?
                                            .resume(returning: file)
                                        creationContinuation = nil
                                        viewModel.displayCreationWindow.wrappedValue = false
                                    }
                                }

                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        creationContinuation?.resume(throwing: CocoaError(CocoaError.userCancelled))
                                        creationContinuation = nil
                                        viewModel.displayCreationWindow.wrappedValue = false
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

            @MainActor
            struct TestHooks {
                private let target: DocumentLaunchView

                fileprivate init(target: DocumentLaunchView) {
                    self.target = target
                }
                @available(iOS 18.0, *)
                var creationContinuation: DocumentContinuation? {
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
