//
//  MinecraftMapContent.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 09-04-2025.
//

import MapKit
import SwiftUI

/// An enumeration of the supported content types for Minecraft map content.
public enum MinecraftMapContentType {
    /// An annotation, which acts as an indicator or a point of interest.
    ///
    /// > Important: Map content with this type should conform to the `MKAnnotation` protocol.
    case annotation

    /// An overlay, which provides a shape.
    ///
    /// > Important: Map content with this type should conform to the `MKOverlay` protocol.
    case overlay
}

/// A protocol that defines map content that can be added to a ``MinecraftMapView``.
public protocol MinecraftMapContent {
    /// The type of content to be added to the map.
    var contentType: MinecraftMapContentType { get }
}

extension MinecraftMapView {
    func addMapContent(_ content: MinecraftMapContent) {
        switch content.contentType {
        case .annotation:
            if let annotation = content as? MKAnnotation {
                addAnnotation(annotation)
            }
        case .overlay:
            if let overlay = content as? MKOverlay {
                addOverlay(overlay)
            }
        }
    }

    func addMapContents(_ contents: [MinecraftMapContent]) {
        for content in contents {
            addMapContent(content)
        }
    }

    func removeMapContent(_ content: MinecraftMapContent) {
        switch content.contentType {
        case .annotation:
            if let annotation = content as? MKAnnotation {
                removeAnnotation(annotation)
            }
        case .overlay:
            if let overlay = content as? MKOverlay {
                removeOverlay(overlay)
            }
        }
    }

    func resyncMapContent(_ contents: [MinecraftMapContent]) {
        removeAnnotations(self.annotations)
        for overlay in self.overlays {
            if overlay is MinecraftRenderedTileOverlay { continue }
            removeOverlay(overlay)
        }

        for content in contents {
            self.addMapContent(content)
        }
    }
}
