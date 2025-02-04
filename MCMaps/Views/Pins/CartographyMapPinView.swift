//
//  CartographyMapPinView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

struct CartographyMapPinView: View {
    var pin: CartographyMapPin

    var body: some View {
        HStack {
            Image(systemName: "mappin")
                .foregroundStyle(.white)
                .padding(6)
                .background(Circle().fill(pin.color?.swiftUIColor ?? .blue))
            VStack(alignment: .leading) {
                Text(pin.name)
                    .font(.headline)
                Text("(\(Int(pin.position.x)), \(Int(pin.position.y)))")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
        }
    }
}
