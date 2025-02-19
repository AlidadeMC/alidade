//
//  CartographyMapPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import SwiftUI

struct CartographyMapPinDetailView: View {
    struct Constants {
        static let pinHeightMultiplier = 2.5
        #if os(macOS)
            static let basePinHeight = 175.0
        #else
            static let basePinHeight = 280.0
        #endif
    }
    var viewModel: CartographyPinViewModel

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TextField("Name", text: viewModel.pin.name)
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
                    ForEach(CartographyMapPin.Color.allCases, id: \.self) { pinColor in
                        Button {
                            viewModel.pin.wrappedValue.color = pinColor
                        } label: {
                            Circle().fill(pinColor.swiftUIColor.gradient)
                                .frame(width: pinColorHeight, height: pinColorHeight)
                                .overlay {
                                    if viewModel.pin.wrappedValue.color == pinColor {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(
                                                width: pinColorHeight / Constants.pinHeightMultiplier,
                                                height: pinColorHeight / Constants.pinHeightMultiplier
                                            )
                                    }
                                }
                        }
                        .tag(pinColor)
                        .help(String(describing: pinColor).localizedCapitalized)
                        .accessibilityLabel(String(describing: pinColor).localizedCapitalized)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .animation(.default, value: viewModel.pin.wrappedValue)
    }

    private var pinColorHeight: Double {
        return Constants.basePinHeight / Double(CartographyMapPin.Color.allCases.count)
    }
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    CartographyMapPinDetailView(viewModel: .init(file: $file, index: 0))
}
