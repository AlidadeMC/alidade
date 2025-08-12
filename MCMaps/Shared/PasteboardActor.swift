//
//  PasteboardActo.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-08-2025.
//

#if canImport(AppKit)
    import AppKit
#endif

#if canImport(UIKit)
    import UIKit
#endif

/// An actor used to copy contents to the player's clipboard.
actor PasteboardActor {
    /// An enumeration of the pasteboard sources available.
    enum Source {
        /// The general player pasteboard.
        case general

        /// A customized pasteboard created at initialization.
        ///
        /// - Important: This should _only_ be used in tests, as creating pasteboards this way may cause leaks.
        case custom
    }
    #if canImport(AppKit)
        private let pasteboard: NSPasteboard
    #endif

    #if canImport(UIKit)
        private let pasteboard: UIPasteboard
    #endif

    /// Create a pasteboard actor.
    init(source: Source = .general) {
        switch source {
        case .general:
            #if canImport(AppKit)
                pasteboard = .general
            #endif
            #if canImport(UIKit)
                pasteboard = .general
            #endif
        case .custom:
            #if canImport(AppKit)
                pasteboard = NSPasteboard.withUniqueName()
            #endif
            #if canImport(UIKit)
                pasteboard = UIPasteboard.withUniqueName()
            #endif
        }

    }

    /// Copies the contents of a string to the player's clipboard.
    /// - Parameter content: The content to copy to the clipboard.
    func copy(_ content: String) {
        #if canImport(AppKit)
            pasteboard.clearContents()
            pasteboard.setString(content, forType: .string)
        #endif
        #if canImport(UIKit)
            pasteboard.string = content
        #endif
    }

    /// Copies the specified coordinate to the player's clipboard.
    /// - Parameter coordinate: The coordinate to copy.
    func copy(_ coordinate: CGPoint) {
        let readout = coordinate.accessibilityReadout
        copy(readout)
    }

    /// Gets the current contents of the clipboard as a string.
    func getStringContents() -> String? {
        #if canImport(AppKit)
            return pasteboard.string(forType: .string)
        #endif
        #if canImport(UIKit)
            return pasteboard.string
        #endif
    }
}
