//
//  CartographySearchLabel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import SwiftUI

struct CartographySearchLabel: View {
    var body: some View {
        HStack {
            Spacer()
            Label {
                Text("Searching...")
                    .font(.subheadline)
                    .bold()
            } icon: {
                Image(systemName: "magnifyingglass.circle")
                    .symbolEffect(.breathe)
                    .imageScale(.large)
            }
            Spacer()
        }
        .padding(.vertical)
        #if os(iOS)
            .listRowBackground(Color.clear)
            .listRowInsets(.zero)
            .listRowSeparator(.hidden)
        #endif
    }
}
