//
//  DocumentLaunchViewButtonModifier.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-10-2025.
//

import SwiftUI

private struct DocumentLaunchViewButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 26, iOS 26, *) {
            self.glassStyle(content: content)
        } else {
            self.classicButtonStyle(content: content)
        }
    }

    @available(iOS 26, macOS 26, *)
    private func glassStyle(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .controlSize(.extraLarge)
            .buttonStyle(.glass)
            .bold()
    }

    private func classicButtonStyle(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
            .controlSize(.extraLarge)
            .buttonStyle(.borderless)
            .bold()
            .clipped()
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func documentLaunchViewButtonStyle() -> some View {
        self.modifier(DocumentLaunchViewButtonModifier())
    }
}
