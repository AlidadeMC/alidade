//
//  CartographyRecentLocationView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

struct CartographyRecentLocationView: View {
    var location: CGPoint

    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundStyle(.white)
                .padding(6)
                .background(Circle().fill(Color.gray))
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.headline)
                Text("(\(Int(location.x)), \(Int(location.y)))")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
        }
    }
}
