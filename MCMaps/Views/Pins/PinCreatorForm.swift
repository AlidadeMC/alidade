//
//  PinCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

struct PinCreatorForm: View {
    @Environment(\.dismiss) private var dismiss
    var location: CGPoint

    @State private var name: String = "Pin"
    @State private var color: CartographyMapPin.Color = .blue

    var completion: (CartographyMapPin) -> Void

    var body: some View {
        Form {
            TextField("Name", text: $name)
            Picker("Color", selection: $color) {
                ForEach(CartographyMapPin.Color.allCases, id: \.self) { pinColor in
                    Text("\(pinColor)".localizedCapitalized)
                        .tag(pinColor)
                }
            }
            Section {
                HStack {
                    Spacer()
                    CartographyNamedLocationView(
                        name: name,
                        location: location,
                        systemImage: "mappin",
                        color: color.swiftUIColor
                    )
                    Spacer()
                }
            }
        }
        .navigationTitle("Create Pin")
        .animation(.bouncy, value: color)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    dismiss()
                    completion(CartographyMapPin(position: location, name: name, color: color))
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PinCreatorForm(location: .init(x: 1847, y: 1963)) { _ in

        }
        .formStyle(.grouped)
    }
}
