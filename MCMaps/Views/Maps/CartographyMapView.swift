//
//  CartographyMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

struct CartographyMapView: View {
    var state: CartographyMapViewState

    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView()
            case .success(let data):
                VStack {
                    Image(data: data)?.resizable()
                        .scaledToFill()
                }
            case .unavailable:
                ContentUnavailableView("No Map Available", systemImage: "map")
            }
        }
    }
}
