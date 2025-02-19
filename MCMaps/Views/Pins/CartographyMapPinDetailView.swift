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
        List {
            VStack(alignment: .leading) {
                TextField("Name", text: viewModel.pin.name)
                    .allowsTightening(true)
                    .font(.title)
                    .bold()
                    .textFieldStyle(.plain)
                Text(viewModel.pinLocationLabel)
                    .font(.subheadline)
                    .monospaced()
                    .foregroundStyle(.secondary)
            }

            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            if !viewModel.images().isEmpty {
                Section("Photos") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.images(), id: \.self) { imageData in
                                Image(data: imageData)?
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        .frame(height: 150)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.zero)
            }

            Section("Color") {
                HStack {
                    Spacer()
                    CartographyMapPinColorPicker(color: viewModel.pin.color)
                    Spacer()
                }
                .listRowInsets(.init(top: 2, leading: 0, bottom: 2, trailing: 0))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .animation(.default, value: viewModel.pin.wrappedValue)
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    CartographyMapPinDetailView(viewModel: .init(file: $file, index: 0))
}
