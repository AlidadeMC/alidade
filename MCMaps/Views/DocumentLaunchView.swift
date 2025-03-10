//
//  DocumentLaunchView.swift
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
#else
    /// A launch view that lets players create and open files easily.
    ///
    /// This will generally be displayed when the app is first loaded.
    struct DocumentLaunchView: Scene {
        /// Whether the creation window should be visible.
        ///
        /// Applicable to iOS and iPadOS.
        @Binding var displayCreationWindow: Bool

        /// The proxy map used to create a file temporarily.
        ///
        /// Applicable to iOS and iPadOS.
        @Binding var proxyMap: CartographyMap

        @Environment(\.dismissWindow) private var dismissWindow
        @Environment(\.newDocument) private var newDocument
        @Environment(\.openDocument) private var openDocument

        @State private var selectedFile: URL?

        @ScaledMetric private var fileHeight = 36.0
        @ScaledMetric private var filePaddingH = 4.0
        @ScaledMetric private var filePaddingV = 2.0

        private enum Constants {
            static let appIconSize = 128.0
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
                        .frame(width: 300, height: 400)
                        .overlay(alignment: .topLeading) {
                            Button {
                                dismissWindow(id: "launch")
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary.opacity(0.5))
                            }
                            .buttonStyle(.plain)
                            .offset(x: 24, y: -8)
                            .imageScale(.large)
                        }
                        .background(.windowBackground)

                    recentDocumentsList
                        .frame(width: 300, height: 400)
                }
                .frame(width: 600, height: 400)
                .toolbarVisibility(.hidden, for: .windowToolbar)
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
                    Image("AppIcon-static")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.appIconSize, height: Constants.appIconSize)
                    Text("Welcome to \(MCMapsApp.appName)")
                        .font(.title)
                        .bold()
                    Text(version)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom)
                Spacer()
                VStack(alignment: .leading) {
                    Button {
                        newDocument(contentType: .cartography)
                        dismissWindow(id: "launch")
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
                        openPanel.allowedContentTypes = [.cartography]
                        openPanel.begin { resp in
                            if resp == .OK, let url = openPanel.url {
                                openDocument(at: url)
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
            .padding(.horizontal, 10)
        }

        private var recentDocumentsList: some View {
            List(selection: $selectedFile) {
                ForEach(recentDocuments, id: \.self) { url in
                    HStack {
                        Image("File Preview")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 1)
                            .padding(.vertical, filePaddingV)
                            .padding(.horizontal, filePaddingH)
                            .frame(height: fileHeight)
                        VStack(alignment: .leading) {
                            Text(sanitize(url: url))
                                .font(.headline)
                            HStack {
                                if isInMobileDocuments(url) {
                                    Image(systemName: "icloud")
                                        .foregroundStyle(.blue)
                                }
                                Text(friendlyUrl(url))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                    .tag(url)
                }
            }
            .buttonStyle(.plain)
            .listStyle(.sidebar)
            .background(.thinMaterial)
            .ignoresSafeArea(.container)
            .contextMenu(forSelectionType: URL.self) { urls in
                if urls.count == 1, let url = urls.first {
                    Button {
                        Task {
                            await showInFinder(url: url)
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

        private func openDocument(at url: URL) {
            Task {
                do {
                    try await openDocument(at: url)
                    dismissWindow(id: "launch")
                } catch {}
            }
        }

        private func sanitize(url: URL) -> String {
            return url.lastPathComponent.replacingOccurrences(of: ".mcmap", with: "")
        }

        private func friendlyUrl(_ url: URL, for currentUser: String = NSUserName()) -> String {
            let originalDirectory = url.standardizedFileURL.deletingLastPathComponent()
            if !url.contains(components: ["Users", currentUser]) {
                return originalDirectory.standardizedFileURL.relativePath
            }
            var newPath = URL(filePath: "~/")
            var newComponents = originalDirectory.pathComponents.dropFirst(3)
            if newComponents.contains("com~apple~CloudDocs") {
                newPath = URL(filePath: "iCloud Drive/")
                newComponents = newComponents.dropFirst(3)
            }
            for component in newComponents {
                newPath = newPath.appending(component: component)
            }
            return newPath.relativePath
        }

        private func isInMobileDocuments(_ url: URL, for currentUser: String = NSUserName()) -> Bool {
            return url.standardizedFileURL.contains(components: ["Users", currentUser, "com~apple~CloudDocs"])
        }

        private func showInFinder(url: URL) async {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
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
    fileprivate func documentLaunchViewButtonStyle() -> some View {
        self.modifier(DocumentLaunchViewButtonModifier())
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
            #if os(macOS)
                @available(macOS 15.0, *)
                func friendlyUrl(_ url: URL, for currentUser: String) -> String {
                    target.friendlyUrl(url, for: currentUser)
                }

                @available(macOS 15.0, *)
                func isInMobileDocuments(_ url: URL, for currentUser: String) -> Bool {
                    target.isInMobileDocuments(url, for: currentUser)
                }

                @available(macOS 15.0, *)
                func sanitize(url: URL) -> String {
                    target.sanitize(url: url)
                }
            #else
                @available(iOS 18.0, *)
                var creationContinuation: CheckedContinuation<CartographyMapFile?, any Error>? {
                    target.creationContinuation
                }
            #endif
        }
    }
#endif
