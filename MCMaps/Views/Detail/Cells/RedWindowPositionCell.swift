//
//  RedWindowPositionCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-08-2025.
//

import AlidadeUI
import DesignLibrary
import MCMap
import SwiftUI

struct RedWindowPositionCell: RedWindowDetailCell {
    @Environment(\.colorScheme) private var colorScheme

    private enum Constants {
        static let labeledContentPadding = 6.0
    }

    /// The pin to display the tags for.
    @Binding var pin: CartographyMapPin

    /// Whether the view is in editing mode.
    /// - Note: This property has no effect on this view.
    @Binding var isEditing: Bool

    /// The file containing the pin being displayed.
    @Binding var file: CartographyMapFile

    var body: some View {
        Group {
            Text("Coordinates")
                .font(.system(.title3, design: .serif))
                .bold()
                .padding(.top)
            VStack {
                if pin.dimension == .end {
                    LabeledContent("End", value: primaryPosition.accessibilityReadout)
                        .padding(Constants.labeledContentPadding)
                    InlineBanner(
                        "This location can only be accessed in the End.",
                        message: "The End dimension doesn't support fast travel between dimensions unlike the Nether."
                    )
                    .inlineBannerVariant(.information)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignLibrary.SemanticColors.Alert.infoBackground.resolve(with: colorScheme))
                    }
                } else {
                    LabeledContent(
                        "Overworld",
                        value: (pin.dimension == .overworld ? primaryPosition : alternatePosition).accessibilityReadout
                    )
                    .padding(Constants.labeledContentPadding)
                    LabeledContent(
                        "Nether",
                        value: (pin.dimension == .nether ? primaryPosition : alternatePosition).accessibilityReadout
                    )
                    .padding(Constants.labeledContentPadding)
                }
            }

        }
    }

    private var primaryPosition: CGPoint {
        pin.position
    }

    private var alternatePosition: CGPoint {
        switch pin.dimension {
        case .overworld:
            return CGPoint(x: pin.position.x / 8, y: pin.position.y / 8)
        case .nether:
            return CGPoint(x: pin.position.x * 8, y: pin.position.y * 8)
        case .end:
            return pin.position
        }
    }

}
