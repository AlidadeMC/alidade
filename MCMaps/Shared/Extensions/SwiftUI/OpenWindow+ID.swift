//
//  OpenWindow+ID.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import SwiftUI

/// An enumeration of the various window IDs that can be opened via ``SwiftUI/OpenWindowAction/callAsFunction(id:)``.
enum WindowID: String {
    /// The ID for opening the gallery view as a separate window.
    case gallery

    /// The ID for opening the "About Alidade" window on macOS.
    @available(macOS 15.0, *)
    case about

    /// The ID for opening the "Welcome to Alidade" window on macOS.
    @available(macOS 15.0, *)
    case launch
}

extension OpenWindowAction {
    /// Opens a window with the specified ID and context.
    /// - Parameter id: The ID of the window to open.
    /// - Parameter context: The context to pass to the window.
    func callAsFunction<T: Codable & Hashable>(id: WindowID, context: T) {
        self.callAsFunction(id: id.rawValue, value: context)
    }

    /// Opens a window with the specified ID.
    /// - Parameter id: The ID of the window to open.
    func callAsFunction(id: WindowID) {
        self.callAsFunction(id: id.rawValue)
    }
}
