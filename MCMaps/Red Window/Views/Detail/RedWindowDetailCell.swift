//
//  RedWindowDetailCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMap
import SwiftUI

/// A protocol used to register a cell for the ``RedWindowPinDetailView``.
protocol RedWindowDetailCell: View {
    /// The pin being displayed or edited.
    var pin: CartographyMapPin { get set }

    /// Whether the view is in editing mode.
    var isEditing: Bool { get set }

    /// The file that contains the pin being displayed or edited.
    var file: CartographyMapFile { get set }
}
