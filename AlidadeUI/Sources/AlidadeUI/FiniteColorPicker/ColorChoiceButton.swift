//
//  ColorChoiceButton.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import SwiftUI

struct ColorChoiceButton: View {
    private enum Constants {
        static let pinHeightMultiplier = 2.5
        #if os(macOS)
            static let pinColorSize = 20.0
            static let automaticallyApplyGradient = true
        #else
            static let pinColorSize = 28.0
            static let automaticallyApplyGradient = false
        #endif
    }

    @Binding var selection: Color
    var color: Color
    var colorStyle: FiniteColorPicker.ColorStyle

    var body: some View {
        Button {
            selection = color
        } label: {
            applyFillFromColorStyle(to: Circle())
                .frame(width: Constants.pinColorSize, height: Constants.pinColorSize)
                .overlay {
                    if color == selection {
                        filledIndicator
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityValue("Selected", isEnabled: color == selection)
        .tag(color)
        .help(String(describing: color).localizedCapitalized)
        .accessibilityLabel(String(describing: color).localizedCapitalized)
    }

    private func applyFillFromColorStyle(to view: Circle) -> some View {
        Group {
            if colorStyle == .gradient || (colorStyle == .automatic && Constants.automaticallyApplyGradient) {
                view.fill(color.gradient)
            } else {
                view.fill(color)
            }
        }
    }

    private var filledIndicator: some View {
        Circle().fill(.white)
            .frame(
                width: Constants.pinColorSize / Constants.pinHeightMultiplier,
                height: Constants.pinColorSize / Constants.pinHeightMultiplier
            )
    }
}

#Preview {
    @Previewable @State var color = Color.blue
    HStack {
        ColorChoiceButton(selection: $color, color: .blue, colorStyle: .plain)
        ColorChoiceButton(selection: $color, color: .red, colorStyle: .gradient)
    }
    .padding()
}
