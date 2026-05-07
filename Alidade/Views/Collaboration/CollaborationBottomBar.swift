//
//  CollaborationBottomBar.swift
//  Alidade
//
//  Created by Marquis Kurt on 07-05-2026.
//

import SwiftUI

struct CollaborationBottomBar: View {
    private enum Constants {
        #if os(macOS)
            static let barHorizontalPadding = 4.0
        #else
            static let barHorizontalPadding = 8.0
        #endif
    }

    @ScaledMetric private var toolbarButtonSize = 36

    var url: URL

    var body: some View {
        VStack {
            #if os(iOS)
                Divider()
            #endif
            HStack {
                ShareLink(item: url)
                    .labelStyle(.titleAndIcon)
                    .font(.headline)
                Spacer()
                CollaborationToolbarItem(contentsOf: url)
                    .frame(width: toolbarButtonSize, height: toolbarButtonSize)
            }
            .padding(.horizontal, Constants.barHorizontalPadding)
            .padding(.bottom, 2)
            .frame(minWidth: 175)
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
        }
    }
}
