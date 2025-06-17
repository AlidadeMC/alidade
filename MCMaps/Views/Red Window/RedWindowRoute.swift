//
//  RedWindowRoute.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

enum RedWindowRoute: Hashable {
    case map
    case gallery
    case worldEdit
    case allPins
    case allPinsCompact
    case pin(MCMapManifestPin)
    case search
}
