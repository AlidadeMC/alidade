//
//  RedWindowDetailCell.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

/// A protocol used to register a cell for the ``RedWindowPinDetailView``.
protocol RedWindowDetailCell: View {
    var pin: MCMapManifestPin { get set }
    var isEditing: Bool { get set }
    var file: CartographyMapFile { get set }
}
