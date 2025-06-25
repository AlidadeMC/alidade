//
//  DocumentLaunchView+Desktop.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import DesignLibrary
import MCMapFormat
import Observation
import SwiftUI

#if os(macOS)
    /// A launch view that lets players create and open files easily.
    ///
    /// This will generally be displayed when the app is first loaded.
    struct DocumentLaunchView: Scene {
        var viewModel: DocumentLaunchViewModel

        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.dismissWindow) private var dismissWindow
        @Environment(\.newDocument) private var newDocument
        @Environment(\.openDocument) private var openDocument

        private enum Constants {
            static let appIconSize = 100.0
            static let documentCornerRadius = 10.0
            static let paneWidth = 300.0
            static let paneHeight = 400.0
        }

        private var version: String {
            return String(localized: "v\(MCMapsApp.version) (Build \(MCMapsApp.buildNumber))")
        }

        private var recentDocuments: [URL] {
            NSDocumentController.shared.recentDocumentURLs
        }

        var body: some Scene {
            WindowGroup(id: "launch") {
                HStack(spacing: 0) {
                    mainWindow
                        .background(
                            Color(.documentLaunchSheet)
                                .clipped()
                                .clipShape(
                                    .rect(
                                        cornerRadii: RectangleCornerRadii(
                                            topLeading: Constants.documentCornerRadius,
                                            topTrailing: Constants.documentCornerRadius
                                        )
                                    )
                                )
                                .shadow(radius: 8, y: 4)
                                .padding([.top, .leading, .trailing], 16)
                        )
                        .background(
                            Color(.documentLaunchSheet).opacity(0.8)
                                .clipped()
                                .clipShape(.rect(cornerRadius: Constants.documentCornerRadius))
                                .shadow(radius: 8, y: 4)
                                .padding(4)
                                .offset(y: 32)
                        )
                        .frame(width: Constants.paneWidth, height: Constants.paneHeight)
                        .background(
                            Image("pack-mcmeta")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                        )
                    recentDocumentsList
                        .frame(width: Constants.paneWidth, height: Constants.paneHeight)
                }
                .frame(width: 600, height: 400)
                .windowMinimizeBehavior(.disabled)
                .containerBackground(.thinMaterial, for: .window)
                .sheet(isPresented: viewModel.displayCreationWindow) {
                    NavigationStack {
                        MapCreatorForm(
                            worldName: viewModel.proxyMap.name,
                            worldSettings: viewModel.proxyMap.worldSettings
                        )
                        .navigationTitle("Create Map")
                        .formStyle(.grouped)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Create") {
                                    createDocument()
                                }
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", role: .cancel) {
                                    viewModel.displayCreationWindow.wrappedValue = false
                                }
                            }
                        }
                    }
                }
            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
            .defaultLaunchBehavior(.presented)
            .windowBackgroundDragBehavior(.enabled)
            .defaultWindowPlacement { content, context in
                let displayBounds = context.defaultDisplay.visibleRect
                let size = content.sizeThatFits(.unspecified)
                let position = CGPoint(
                    x: displayBounds.midX - (size.width / 2),
                    y: displayBounds.minY + 256
                )
                return WindowPlacement(position, size: size)
            }
        }

        private var mainWindow: some View {
            VStack {
                Spacer()
                VStack {
                    Image("App Pin Static")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.appIconSize, height: Constants.appIconSize)
                    Text("Welcome to \(MCMapsApp.appName)")
                        .font(.title)
                        .bold()
                    Text(version)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                Spacer()
                VStack(alignment: .leading) {
                    Button {
                        viewModel.displayCreationWindow.wrappedValue.toggle()
                    } label: {
                        HStack {
                            Label("Create a Map", systemImage: "document.badge.plus")
                            Spacer()
                        }
                    }
                    .documentLaunchViewButtonStyle()

                    Button {
                        let openPanel = NSOpenPanel()
                        openPanel.canDownloadUbiquitousContents = true
                        openPanel.allowsMultipleSelection = false
                        openPanel.allowedContentTypes = [.mcmap]
                        Task {
                            let response = await openPanel.begin()
                            if response == .OK, let url = openPanel.url {
                                try? await openDocument(at: url)
                            }
                        }
                    } label: {
                        HStack {
                            Label("Open a Map...", systemImage: "folder")
                            Spacer()
                        }
                    }
                    .documentLaunchViewButtonStyle()

                    // NOTE(alicerunsonfedora): Button to be enabled when import functionality exists.

                    // Button {
                    // } label: {
                    //     HStack {
                    //         Label("Import a Java World...", systemImage: "display.and.arrow.down")
                    //         Spacer()
                    //     }
                    // }
                    // .documentLaunchViewButtonStyle()
                }
                Spacer()
            }
            .padding()
            .padding(.horizontal, 26)
        }

        private var recentDocumentsList: some View {
            RecentDocumentsList(viewModel: viewModel, recentDocuments: recentDocuments)
            .buttonStyle(.plain)
            .listStyle(.sidebar)
            .background(.thinMaterial)
            .ignoresSafeArea(.container)
            .contextMenu(forSelectionType: URL.self) { urls in
                if urls.count == 1, let url = urls.first {
                    Button {
                        Task {
                            await viewModel.showInFinder(url: url)
                        }
                    } label: {
                        Label("Show in Finder", systemImage: "folder")
                    }
                }
            } primaryAction: { urls in
                if urls.count == 1, let url = urls.first {
                    openDocument(at: url)
                }
            }
        }

        private func createDocument() {
//            viewModel.proxyMap.wrappedValue.pins.append(CartographyMapPin(position: .zero, name: "Spawn Point"))
            viewModel.proxyMap.wrappedValue.recentLocations?.append(.zero)
            let newFile = CartographyMapFile(withManifest: viewModel.proxyMap.wrappedValue)
            newDocument(newFile)
            viewModel.displayCreationWindow.wrappedValue = false
            Task {
                // NOTE(alicerunsonfedora): WTF is this bullshit? Can't you just dismiss normally you dirty fuck?
                try await Task.sleep(nanoseconds: 1000)
                dismissWindow(id: "launch")
            }
        }

        private func openDocument(at url: URL) {
            Task {
                do {
                    try await openDocument(at: url)
                    dismissWindow(id: "launch")
                } catch {}
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

                @available(macOS 15.0, *)
                func friendlyUrl(_ url: URL, for currentUser: String) -> String {
                    target.viewModel.friendlyUrl(url, for: currentUser)
                }

                @available(macOS 15.0, *)
                func isInMobileDocuments(_ url: URL, for currentUser: String) -> Bool {
                    target.viewModel.isInMobileDocuments(url, for: currentUser)
                }

                @available(macOS 15.0, *)
                func sanitize(url: URL) -> String {
                    target.viewModel.sanitize(url: url)
                }
            }
        }
    #endif
#endif
