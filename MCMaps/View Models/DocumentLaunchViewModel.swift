//
//  DocumentLaunchViewModel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import SwiftUI

// NOTE(alicerunsonfedora): This should likely be converted into an actor of some kind, to get around the @unchecked
// portion. Either that or this is the valid approach?

/// A view model used to handle creating documents in a document launch view.
///
/// This is generally used by the document launch view to handle creating a new file, and displaying the form for
/// setting the Minecraft version and seed.
class DocumentLaunchViewModel: @unchecked Sendable {
    /// The currently selected file.
    var selectedFileURL: Binding<URL?>

    /// Whether to display the creation window form.
    var displayCreationWindow: Binding<Bool>

    /// A proxy map used to create the file with a specified Minecraft version and seed.
    var proxyMap: Binding<MCMapManifest>

    private var selectedFile: URL?

    init(displayCreationWindow: Binding<Bool>, proxyMap: Binding<MCMapManifest>) {
        self.selectedFileURL = .constant(.documentsDirectory)
        self.displayCreationWindow = displayCreationWindow
        self.proxyMap = proxyMap
        self.selectedFileURL = Binding { [self] in
            return selectedFile
        } set: { [self] newValue in
            selectedFile = newValue
        }
    }

    /// Sanitizes the specified URL, dropping the `mcmap` suffix.
    func sanitize(url: URL) -> String {
        return url.lastPathComponent.replacingOccurrences(of: ".mcmap", with: "")
    }

    /// Displays a human-friendly version of a file URL.
    func friendlyUrl(_ url: URL, for currentUser: String = NSUserName()) -> String {
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

    /// Whether the specified file URL is in the Mobile Documents directory.
    func isInMobileDocuments(_ url: URL, for currentUser: String = NSUserName()) -> Bool {
        return url.standardizedFileURL.contains(components: ["Users", currentUser, "com~apple~CloudDocs"])
    }

    #if os(macOS)
        @available(macOS 15.0, *)
        func showInFinder(url: URL) async {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    #endif
}
