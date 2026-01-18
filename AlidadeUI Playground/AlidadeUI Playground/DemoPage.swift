//
//  DemoPage.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI

struct DemoPage<Content: View, ConfigurationContent: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #if os(macOS)
        @State private var displayInspector = true
    #else
        @State private var displayInspector = false
    #endif

    var content: () -> Content
    var inspector: () -> ConfigurationContent

    var body: some View {
        Form {
            content()
            if horizontalSizeClass == .compact {
                inspector()
            }
        }
        #if os(macOS)
            .formStyle(.grouped)
        #endif
        .inspector(isPresented: $displayInspector) {
            Form {
                inspector()
            }
        }
        .toolbar {
            ToolbarItem {
                if horizontalSizeClass == .regular {
                    Button {
                        displayInspector.toggle()
                    } label: {
                        Label("Inspector", systemImage: "info.circle")
                    }
                }
            }
        }
    }
}
