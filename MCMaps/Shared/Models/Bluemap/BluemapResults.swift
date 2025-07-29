//
//  BluemapResults.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import CoreGraphics
import CubiomesKit
import MCMap

/// A structure that represents the results received from a Bluemap integration sync.
///
/// This type is generally used to collect groups of data responses together neatly, so that they can be easily
/// displayed on a map.
struct BluemapResults: Sendable {
    /// The markers that are live for the current world dimension.
    var markers: [String: BluemapMarkerAnnotationGroup]?

    /// The players that are currently active in this world dimension.
    var players: BluemapPlayerResponse?

    /// Whether the response is empty.
    var isEmpty: Bool {
        return markers == nil && players == nil
    }

    /// Merges the contents of the current result with another, taking self precedence.
    ///
    /// This type is used to merge responses together piecemeal, such as through the results of a task group.
    func merged(with other: BluemapResults) -> BluemapResults {
        var applesauce = BluemapResults(markers: self.markers, players: self.players)
        if applesauce.markers == nil {
            applesauce.markers = other.markers
        }
        if applesauce.players == nil {
            applesauce.players = other.players
        }
        return applesauce
    }
}

extension BluemapResults: CartographyIntegrationServiceData {
    typealias Configuration = MCMapBluemapIntegration

    func annotations(from configuration: MCMapBluemapIntegration) -> [AnnotationContent] {
        var annotations = [AnnotationContent]()

        if let players = self.players?.players {
            for player in players {
                annotations.append(
                    PlayerMarker(
                        location: CGPoint(x: player.position.x, y: player.position.z),
                        name: player.name,
                        playerUUID: player.uuid
                    )
                )
            }
        }

        if let markers {
            for (markerGroup, group) in markers {
                if markerGroup == "death-markers", configuration.displayOptions.contains(.deathMarkers) {
                    let deathMarkers = group.markers.map { (id, annotation) in
                        Marker(
                            location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                            title: annotation.label,
                            color: .gray,
                            systemImage: "xmark.circle",
                            clusterIdentifier: "bmap-death-marker"
                        )
                    }
                    annotations.append(contentsOf: deathMarkers)
                    continue
                }

                let mapMarkers = group.markers.map { (id, annotation) in
                    Marker(
                        location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                        title: annotation.label,
                        clusterIdentifier: "bmap-server-marker")
                }
                annotations.append(contentsOf: mapMarkers)
            }
        }

        return annotations
    }
}
