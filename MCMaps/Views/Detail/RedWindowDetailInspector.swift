//
//  RedWindowDetailInspector.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-08-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

struct RedWindowDetailInspector: View {
    var pin: CartographyMapPin
    var worldSettings: MCMapManifestWorldSettings

    var body: some View {
        Group {
            if let world = try? MinecraftWorld(worldSettings: worldSettings) {
                MinecraftMap(
                    world: world,
                    centerCoordinate: .constant(pin.position),
                    dimension: MinecraftWorld.Dimension(fromPinDimension: pin.dimension)
                ) {
                    Marker(
                        location: pin.position,
                        title: pin.name,
                        id: pin.id,
                        color: pin.color?.swiftUIColor ?? .accent,
                        systemImage: pin.icon?.resolveSFSymbol(in: .pin) ?? "mappin"
                    )
                }
                .mapColorScheme(.natural)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
            }
        }
        .frame(minWidth: 300, idealWidth: 350, maxWidth: 400, maxHeight: .infinity)
    }
}
