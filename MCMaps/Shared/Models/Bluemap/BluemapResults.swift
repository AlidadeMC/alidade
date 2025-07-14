//
//  BluemapResults.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import CoreGraphics
import CubiomesKit
import MCMapFormat

struct BluemapResults: Sendable {
    var markers: [String: BluemapMarkerAnnotationGroup]?
    var players: BluemapPlayerResponse?

    var isNone: Bool {
        return markers == nil && players == nil
    }

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
                    let deathMarkers = group.markers.values.map { annotation in
                        Marker(
                            location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                            title: annotation.label,
                            color: .gray,
                            systemImage: "xmark.circle"
                        )
                    }
                    annotations.append(contentsOf: deathMarkers)
                    continue
                }

                let mapMarkers = group.markers.values.map { annotation in
                    Marker(
                        location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                        title: annotation.label)
                }
                annotations.append(contentsOf: mapMarkers)
            }
        }

        return annotations
    }
}
