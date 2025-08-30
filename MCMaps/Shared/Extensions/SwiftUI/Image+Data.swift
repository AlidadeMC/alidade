//
//  Image+Data.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

extension Image {
    #if os(macOS)
        /// Creates an image view from a given piece of data.
        /// - Parameter data: The data to decode and present an image of.
        init(data: Data) {
            guard let nsImage = NSImage(data: data) else {
                self.init(systemName: "questionmark.circle")
                return
            }
            self.init(nsImage: nsImage)
        }
    #elseif os(iOS)
        /// Creates an image view from a given piece of data.
        /// - Parameter data: The data to decode and present an image of.
        init(data: Data) {
            guard let uiImage = UIImage(data: data) else {
                self.init(systemName: "questionmark.circle")
                return
            }
            self.init(uiImage: uiImage)
        }
    #endif
}
