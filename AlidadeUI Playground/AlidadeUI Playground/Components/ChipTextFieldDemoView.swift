//
//  ChipTextFieldDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import AlidadeUI
import SwiftUI

struct ChipTextFieldDemoView: View {
    @State private var tags = Set<String>(["Personal"])
    @State private var chipPlacement = ChipTextField.ChipPlacement.leading
    @State private var chipTextFieldStyle = ChipTextField.Style.plain
    @State private var submitWithSpaces = true
    @State private var prompt: LocalizedStringKey = "Write a tag..."
    @State private var promptText = "Write a tag..."
    @State private var title: LocalizedStringKey = "Tags"
    @State private var titleText = "Tags"

    var body: some View {
        DemoPage {
            Section {
                ChipTextField(title, chips: $tags, prompt: prompt, submitWithSpaces: submitWithSpaces)
                    .chipPlacement(chipPlacement)
                    .chipTextFieldStyle(chipTextFieldStyle)

            } header: {
                Text("Demo")
            }
        } inspector: {
            Group {
                Section {
                    TextField("Title", text: $titleText)
                    Toggle("Submit with Spaces", isOn: $submitWithSpaces)
                    TextField("Prompt", text: $promptText)
                    
                } header: {
                    Text("Basic Configuration")
                }
                
                Section {
                    Picker("Chip Placement", selection: $chipPlacement) {
                        Text("Leading").tag(ChipTextField.ChipPlacement.leading)
                        Text("Trailing").tag(ChipTextField.ChipPlacement.trailing)
                    }
                    Picker("Style", selection: $chipTextFieldStyle) {
                        Text("Plain").tag(ChipTextField.Style.plain)
                        Text("Rounded Border").tag(ChipTextField.Style.roundedBorder)
                        Text("Borderless").tag(ChipTextField.Style.borderless)
                    }
                } header: {
                    Text("Styling Configuration")
                }
            }
        }
        .navigationTitle("Chip Text Field")
        .onChange(of: promptText) { _, newValue in
            prompt = LocalizedStringKey(newValue)
        }
        .onChange(of: titleText) { _, newValue in
            title = LocalizedStringKey(newValue)
        }
    }
}

#Preview {
    NavigationStack {
        ChipTextFieldDemoView()
    }
}
