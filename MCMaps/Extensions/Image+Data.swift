//
//  Image+Data.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

extension Image {
    #if os(macOS)
        init?(data: Data) {
            guard let nsImage = NSImage(data: data) else { return nil }
            self.init(nsImage: nsImage)
        }
    #elseif os(iOS)
        init?(data: Data) {
            guard let uiImage = UIImage(data: data) else { return nil }
            self.init(uiImage: uiImage)
        }
    #endif
}
