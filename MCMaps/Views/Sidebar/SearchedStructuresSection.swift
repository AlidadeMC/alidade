//
//  SearchedStructuresSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import CubiomesKit
import SwiftUI

struct SearchedStructuresSection: View {
    var structures: [CartographyMapPin]
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile

    var jumpedToStructure: ((CartographyMapPin) -> Void)?

    var body: some View {
        Section("Structures") {
            ForEach(structures, id: \.self) { pin in
                CartographyNamedLocationView(pin: pin)
                    .onTapGesture {
                        viewModel.go(to: pin.position, relativeTo: file)
                        jumpedToStructure?(pin)
                    }
                    .contextMenu {
                        Button {
                            viewModel.go(to: pin.position, relativeTo: file)
                            jumpedToStructure?(pin)
                        } label: {
                            Label("Go Here", systemImage: "location")
                        }
                        Button {
                            viewModel.presentNewPinForm(for: pin.position)
                        } label: {
                            Label("Pin...", systemImage: "mappin")
                        }
                    }
                    #if os(iOS)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    #endif
            }
        }
    }
}
