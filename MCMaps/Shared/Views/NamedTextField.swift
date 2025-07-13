//
//  NamedTextField.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import SwiftUI

struct NamedTextField: View {
    var title: LocalizedStringKey
    @Binding var text: String

    private var disabled = false

    init(_ title: LocalizedStringKey, text: Binding<String>, disabled: Bool = false) {
        self.title = title
        self.disabled = disabled
        self._text = text
    }

    var body: some View {
        #if os(iOS)
        LabeledContent(title) {
            TextField("", text: $text)
                .foregroundStyle(disabled ? Color.secondary : Color.primary)
        }
        #else
        TextField(title, text: $text)
        #endif
    }
}
