//
//  BluemapResultsTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 05-08-2025.
//

import CubiomesKit
import MCMap
import SwiftUI
import Testing

@testable import Alidade

struct BluemapResultsTests {
    @Test func isEmpty() async throws {
        let bluemapResults = BluemapResults()
        #expect(bluemapResults.isEmpty)
    }

    @Test func merged() async throws {
        let id = UUID()
        let original = BluemapResults()
        let newContent = BluemapResults(
            players: BluemapPlayerResponse(players: [
                BluemapPlayer(
                    uuid: id,
                    name: "lweiss",
                    foreign: false,
                    position: BluemapPosition(x: 10, y: 10, z: 10),
                    rotation: BluemapPlayer.Rotation(pitch: 0, yaw: 0, roll: 0)
                )
            ]))

        let merged = original.merged(with: newContent)
        #expect(merged.players != nil)
        #expect(merged.markers == nil)
    }

    @Test func annotations() async throws {
        let uuid = UUID()
        let results = BluemapResults(
            markers: [
                "foo": BluemapMarkerAnnotationGroup(
                    label: "Foo",
                    toggleable: true,
                    defaultHidden: false,
                    sorting: 0,
                    markers: [
                        "mymarker": BluemapMarkerAnnotation(
                            classes: [""],
                            label: "My Marker",
                            position: BluemapPosition(x: 0, y: 0, z: 0),
                            minDistance: 0,
                            maxDistance: .greatestFiniteMagnitude,
                            type: "poi",
                            sorting: 0,
                            listed: true
                        )
                    ]
                )
            ],
            players: BluemapPlayerResponse(
                players: [
                    BluemapPlayer(
                        uuid: uuid,
                        name: "lweiss",
                        foreign: false,
                        position: BluemapPosition(x: 10, y: 10, z: 10),
                        rotation: BluemapPlayer.Rotation(pitch: 0, yaw: 0, roll: 0)
                    )
                ]
            )
        )

        let annotations = results.annotations(
            from: MCMapBluemapIntegration(
                baseURL: "https://example.com",
                enabled: true
            )
        )
        #expect(annotations.count == 2)

        let first = try #require(annotations.last as? Marker)
        #expect(
            first
                == Marker(
                    location: .zero,
                    title: "My Marker",
                    id: "mymarker",
                    clusterIdentifier: "bmap-server-marker"
                )
        )

        let last = try #require(annotations.first as? PlayerMarker)
        #expect(last == PlayerMarker(location: CGPoint(x: 10, y: 10), name: "lweiss", playerUUID: uuid))
    }
}
