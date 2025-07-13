//
//  BluemapModels.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import Foundation

struct BluemapMarkerAnnotation: Codable {
    struct Anchor: Codable {
        var x: Double
        var y: Double
    }

    var classes: [String]
    var label: String
    var position: BluemapPosition
    var detail: String?
    var icon: URL?

    var minDistance: Double
    var maxDistance: Double
    var type: String
    var sorting: Int
    var listed: Bool
}

struct BluemapMarkerAnnotationGroup: Codable {
    var label: String
    var toggleable: Bool
    var defaultHidden: Bool
    var sorting: Int
    var markers: [String: BluemapMarkerAnnotation]
}
