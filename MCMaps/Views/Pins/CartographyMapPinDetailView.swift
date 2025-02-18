//
//  CartographyMapPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import SwiftUI

struct CartographyMapPinDetailView: View {
    var viewModel: CartographyPinViewModel

    var body: some View {
        TextField("Name", text: viewModel.pin.name)
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    CartographyMapPinDetailView(viewModel: .init(file: $file, index: 0))
}
