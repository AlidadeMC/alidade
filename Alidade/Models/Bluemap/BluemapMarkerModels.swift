//
//  BluemapModels.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import Foundation

/// A model representing a marker annotation on a map in Bluemap.
struct BluemapMarkerAnnotation: Codable {
    /// A representation of an anchor point.
    struct Anchor: Codable {
        /// The anchor offset on the X axis.
        var x: Double
        /// The anchor offset on the Y axis.
        /// - Note: This does not correspond to the Minecraft Y axis, but rather the Y axis of the map.
        var y: Double
    }

    /// The classes associated with this marker.
    var classes: [String]

    /// A label that describes this marker.
    var label: String

    /// The marker's position in the world.
    var position: BluemapPosition

    /// A detail message for the marker.
    var detail: String?
    var icon: URL?

    /// The minimum distance required for the marker to be visible.
    var minDistance: Double

    /// The maximum distance required for the marker to be visible.
    var maxDistance: Double

    /// The type of marker annotation.
    var type: String

    /// The marker's sorting order.
    var sorting: Int

    /// Whether the marker should be listed.
    var listed: Bool
}

/// A group of related Bluemap marker annotations.
struct BluemapMarkerAnnotationGroup: Codable {
    /// A label describing the annotation group.
    var label: String

    /// Whether players can toggle this group in Bluemap's settings.
    var toggleable: Bool

    /// Whether the markers in this group are hidden by default.
    var defaultHidden: Bool

    /// The group's sorting order.
    var sorting: Int

    /// The markers associated with this annotation group.
    var markers: [String: BluemapMarkerAnnotation]
}
