//
//  PinCreatorForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import AlidadeUI
import MCMap
import SwiftUI

// NOTE(alicerunsonfedora): Perhaps this can get replaced with the new pin detail view?

/// A form for creating a map pin.
///
/// The form allows for a player to assign a name and color to the pin. When the player has confirmed and taps the
/// "Create" button, the ``completion`` handler is called. Otherwise, the form will dismiss itself automatically.
struct PinCreatorForm: View {
    @Environment(\.dismiss) private var dismiss

    /// The location where the pin is being created.
    var location: CGPoint

    var initialName: String?

    @State private var name: String = "Pin"
    @State private var color: CartographyMapPin.Color = .blue
    @State private var updatedLocation = CGPoint.zero
    @State private var dimension: CartographyMapPin.Dimension = .overworld

    @State private var locationX = 0.0
    @State private var locationY = 0.0

    /// A completion handler that executes when the player has confirmed the pin they want to create.
    /// - Parameter pin: The pin the player has created.
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
                Group {
                    #if os(iOS)
                    LabeledContent("X Coordinate: ") {
                        TextField("X Coordinate", value: $locationX, format: .number)
                    }
                    #else
                    TextField("X Coordinate", value: $locationX, format: .number)
                    #endif
                }
                Group {
                    #if os(iOS)
                    LabeledContent("Z Coordinate: ") {
                        TextField("Z Coordinate", value: $locationY, format: .number)
                    }
                    #else
                    TextField("Z Coordinate", value: $locationY, format: .number)
                    #endif
                }
                WorldCodedDimensionPicker(selection: $dimension)
            } header: {
                Text("World Location")
            }
            .onChange(of: locationX) { _, newValue in
                updatedLocation.x = newValue
            }
            .onChange(of: locationY) { _, newValue in
                updatedLocation.y = newValue
            }
            Section {
                HStack {
                    Spacer()
                    NamedLocationView(
                        name: name,
                        location: updatedLocation,
                        systemImage: "mappin",
                        color: color.swiftUIColor
                    )
                    Spacer()
                }
            } header: {
                Text("Preview")
            }
        }
        .navigationTitle("Create Pin")
        .animation(.bouncy, value: color)
        .task {
            updatedLocation = location
            if let initialName {
                name = initialName
            }
            locationX = location.x
            locationY = location.y
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Create", systemImage: "checkmark") {
                    dismiss()
                    completion(
                        CartographyMapPin(
                            named: name,
                            at: updatedLocation,
                            dimension: dimension,
                            color: color
                        )
                    )
                }
            }
            #if os(macOS)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            #endif
        }
    }
}

#Preview {
    NavigationStack {
        PinCreatorForm(location: CGPoint(x: 1847, y: 1963)) { _ in

        }
        .formStyle(.grouped)
    }
}

#if DEBUG
    extension PinCreatorForm {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: PinCreatorForm

            fileprivate init(target: PinCreatorForm) {
                self.target = target
            }

            var name: String {
                target.name
            }

            var nameState: State<String> {
                target._name
            }

            var color: CartographyMapPin.Color {
                target.color
            }

            var colorState: State<CartographyMapPin.Color> {
                target._color
            }

            var location: CGPoint {
                target.location
            }

            var completion: (CartographyMapPin) -> Void {
                target.completion
            }
        }
    }
#endif
