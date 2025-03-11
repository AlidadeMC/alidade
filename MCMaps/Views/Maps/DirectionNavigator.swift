//
//  DirectionNavigator.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//

import SwiftUI

/// A view that lets players jump between map segments in any given cardinal direction.
///
/// This is typically used as an ornament on the ``CartographyOrnamentMap`` to let players move between "map chunks"
/// in any given one direction so that they can move about the world. The control is automatically resized based on the
/// target platform.
struct DirectionNavigator: View {
    private enum Constants {
        #if os(macOS)
            static let verticalStackSpacing = 4.0
            static let horizontalStackSpacing = 24.0
            static let innerPadding = 8.0
        #else
            static let verticalStackSpacing = 24.0
            static let horizontalStackSpacing = 64.0
            static let innerPadding = 24.0
        #endif
    }

    private let tip = DirectionNavigatorTip()

    /// The view model the navigator will read from.
    var viewModel: CartographyMapViewModel

    /// The file the navigator will read from.
    var file: CartographyMapFile

    var body: some View {
        Group {
            VStack(spacing: Constants.verticalStackSpacing) {
                Button {
                    viewModel.go(inDirection: .north, relativeToFile: file)
                    tip.invalidate(reason: .actionPerformed)
                } label: {
                    Label("Go North", systemImage: "chevron.up")
                }
                .keyboardShortcut(.upArrow, modifiers: [.command])
                HStack(spacing: Constants.horizontalStackSpacing) {
                    Button {
                        viewModel.go(inDirection: .west, relativeToFile: file)
                        tip.invalidate(reason: .actionPerformed)
                    } label: {
                        Label("Go West", systemImage: "chevron.left")
                    }
                    .keyboardShortcut(.leftArrow, modifiers: [.command])
                    Button {
                        viewModel.go(inDirection: .east, relativeToFile: file)
                        tip.invalidate(reason: .actionPerformed)
                    } label: {
                        Label("Go East", systemImage: "chevron.right")
                    }
                    .keyboardShortcut(.rightArrow, modifiers: [.command])
                }
                Button {
                    viewModel.go(inDirection: .south, relativeToFile: file)
                    tip.invalidate(reason: .actionPerformed)
                } label: {
                    Label("Go South", systemImage: "chevron.down")
                }
                .keyboardShortcut(.downArrow, modifiers: [.command])
            }
            .labelStyle(.iconOnly)
            #if os(macOS)
                .buttonStyle(.accessoryBar)
            #endif
        }
        .tint(.primary)
        .padding(Constants.innerPadding)
        .background(.thinMaterial)
        .clipped()
        .clipShape(Circle())
        .padding(8)
        .popoverTip(tip, arrowEdge: .top)
        .onAppear {
            Task {
                await DirectionNavigatorTip.viewDisplayed.donate()
            }
        }
    }
}
