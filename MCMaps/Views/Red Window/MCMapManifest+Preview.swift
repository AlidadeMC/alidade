//
//  MCMapManifest+Preview.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-06-2025.
//

import CoreGraphics
import CubiomesKit

extension MCMapManifest {
    static let preview = MCMapManifest(
        name: "Augenwaldburg",
        worldSettings: MCMapManifestWorldSettings(version: "1.21.3", seed: 184_719_632_014),
        pins: [
            MCMapManifestPin(position: CGPoint(x: 1847, y: 1847), name: "Letztes Jahr", color: .gray),
            MCMapManifestPin(position: CGPoint(x: 1963, y: 1963), name: "KLB Electronics", color: .pink),
            MCMapManifestPin(position: CGPoint(x: 2014, y: 2014), name: "Café Trommeln", color: .brown),
        ])
}
