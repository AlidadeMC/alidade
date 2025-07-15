//
//  MockNetworkServicable.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import Foundation

@testable import Alidade

actor MockNetworkServicable: NetworkServiceable {
    public private(set) var urlsVisited = [URL]()

    func get<T: Codable & Sendable>(url: URL) async throws(Alidade.NetworkServicableError) -> T {
        urlsVisited.append(url)
        switch url.absoluteString {
        case "https://bluemap.augenwaldburg.tld/maps/world/live/players.json":
            let val = BluemapPlayerResponse(
                players: [
                    BluemapPlayer(
                        uuid: UUID(uuidString: "4ef16eeb-d5b2-4a6c-afed-e4ddb2ad625f")!,
                        name: "paulstraw",
                        foreign: false,
                        position: BluemapPosition(x: 0, y: 64, z: 0),
                        rotation: BluemapPlayer.Rotation(pitch: 0, yaw: 0, roll: 0)
                    )
                ]
            )
            guard let resp = val as? T else {
                throw .session(
                    DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: [], debugDescription: ""))
                )
            }
            return resp
        case "https://bluemap.augenwaldburg.tld/maps/world/live/markers.json":
            let val = [
                "sample": BluemapMarkerAnnotationGroup(
                    label: "Sample Set",
                    toggleable: true,
                    defaultHidden: false,
                    sorting: 0,
                    markers: [
                        "home": BluemapMarkerAnnotation(
                            classes: [],
                            label: "Home",
                            position: BluemapPosition(x: 0, y: 64, z: 0),
                            minDistance: 0,
                            maxDistance: .greatestFiniteMagnitude,
                            type: "poi",
                            sorting: 0,
                            listed: true
                        )
                    ]
                )
            ]
            guard let resp = val as? T else {
                throw .session(
                    DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: [], debugDescription: ""))
                )
            }
            return resp
        default:
            throw .invalidResponseStatus(404)
        }
    }
}
