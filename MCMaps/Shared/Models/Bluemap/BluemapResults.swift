//
//  BluemapResults.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

struct BluemapResults {
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
