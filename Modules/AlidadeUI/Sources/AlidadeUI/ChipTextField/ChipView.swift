//
//  ChipView.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 23-05-2025.
//

import SwiftUI

struct ChipView: View {
    private enum Constants {
        static let horizontalPadding = 8.0
        static let verticalPadding = 4.0
        static let cornerRadius = 4.0
    }
    var text: String
    var onDelete: (() -> Void)?

    var body: some View {
        HStack {
            Text(text)
            if let onDelete {
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .tint(.secondary)
                .buttonStyle(.borderless)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Chip")
        .accessibilityValue(text)
        .accessibilityHint(Text("Remove Chip"))
        .accessibilityAction(.default) {
            onDelete?()
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(.tertiary.opacity(0.5))
        )
    }
}

#Preview {
    VStack {
        ChipView(text: "Chips")
        ChipView(
            text: "Foo",
            onDelete: {
                print("I was tapped!")
            })
    }
}
