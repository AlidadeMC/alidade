//
//  CartographyNamedLocationView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import SwiftUI

struct CartographyNamedLocationView: View {
    var name: String
    var location: CGPoint
    var systemImage: String
    var color: Color

    init(name: String, location: CGPoint, systemImage: String, color: Color) {
        self.name = name
        self.location = location
        self.systemImage = systemImage
        self.color = color
    }

    init(pin: CartographyMapPin) {
        self.name = pin.name
        self.location = pin.position
        self.color = pin.color?.swiftUIColor ?? .accent
        self.systemImage = "mappin"
    }

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundStyle(.white)
                .padding(6)
                .background(Circle().fill(color))
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text("(\(Int(location.x)), \(Int(location.y)))")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
        }
    }
}
