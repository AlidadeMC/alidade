//
//  CartographyGalleryScene.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import SwiftUI

/// A scene that provides the ``CartographyGalleryView`` as a separate window.
///
/// Whenever the ``WindowID/gallery`` ID is provided to ``SwiftUI/OpenWindowAction/callAsFunction(id:)``, this scene
/// will be displayed.
struct CartographyGalleryScene: Scene {
    var body: some Scene {
        WindowGroup(id: WindowID.gallery.rawValue, for: CartographyGalleryWindowContext.self) { galleryCtx in
            NavigationStack {
                CartographyGalleryView(context: galleryCtx.wrappedValue ?? .empty())
            }
            #if os(iOS)
                .toolbarRole(.browser)
            #endif
        }
        #if os(macOS)
            .restorationBehavior(.disabled)
        #endif
    }
}
