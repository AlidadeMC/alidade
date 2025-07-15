//
//  NamedTextFieldDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 15-07-2025.
//

import AlidadeUI
import SwiftUI

struct NamedTextFieldDemoView: View {
    @State private var title = "Title"
    @State private var currentText = ""
    
    var body: some View {
        DemoPage {
            Section {
                NamedTextField(title, text: $currentText)
            } header: {
                Text("Demo")
            }
        } inspector: {
            Section {
                NamedTextField("Title", text: $title)
            } header: {
                Text("Basic Configuration")
            }
        }
        .navigationTitle("Named Text Field")
    }
}

#Preview {
    NavigationStack {
        NamedTextFieldDemoView()
    }
}
