//
//  FiniteColorPickerDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 26-05-2025.
//

import AlidadeUI
import SwiftUI

struct FiniteColorPickerDemoView: View {
    @State private var selectedColor = Color.blue
    @State private var allowCustom = false
    @State private var colorStyle = FiniteColorPicker.ColorStyle.automatic
    @State private var titleKey = "Select a color: "

    var availableColors: [Color] {
        [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .gray]
    }

    var body: some View {
        DemoPage {
            Section {
                ScrollView(.horizontal) {
                    FiniteColorPicker(LocalizedStringKey(titleKey), selection: $selectedColor, in: availableColors)
                        .includeCustomSelection(isActive: allowCustom)
                        .colorStyle(colorStyle)
                }
            } header: {
                Text("Demo")
            } footer: {
                Label("This view has been wrapped in a scroll view.", systemImage: "info.circle")
            }
        } inspector: {
            Group {
                Section {
                    TextField("Title", text: $titleKey)
                    Toggle("Show Custom Selector", isOn: $allowCustom)
                } header: {
                    Text("Basic Configuration")
                }

                Section {
                    Picker("Color Style", selection: $colorStyle) {
                        Text("Automatic").tag(FiniteColorPicker.ColorStyle.automatic)
                        Text("Plain").tag(FiniteColorPicker.ColorStyle.plain)
                        Text("Gradient").tag(FiniteColorPicker.ColorStyle.gradient)
                    }
                } header: {
                    Text("Styling Configuration")
                }
            }
        }
        .navigationTitle("Finite Color Picker")
    }
}

#Preview {
    NavigationStack {
        FiniteColorPickerDemoView()
    }
}
