//
//  FormHeaderDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 15-07-2025.
//

import AlidadeUI
import SwiftUI

struct FormHeaderDemoView: View {
    enum DemoType {
        case systemImage
        case imageAsset
        case custom
    }

    @State private var demoType = DemoType.systemImage
    @State private var systemTint = Color.blue

    var body: some View {
        DemoPage {
            Section {
                switch demoType {
                case .systemImage:
                    FormHeader(systemImage: "wifi", tint: systemTint) {
                        Text("Wi-Fi")
                    } description: {
                        Text(
                            "Connect to Wi-Fi, view available networks, and manage settings for joining networks and nearby hotspots. [Learn more...](https://example.com)"
                        )
                    }
                case .imageAsset:
                    FormHeader(name: "Swift") {
                        Text("Wi-Fi")
                    } description: {
                        Text(
                            "Connect to Wi-Fi, view available networks, and manage settings for joining networks and nearby hotspots. [Learn more...](https://example.com)"
                        )
                    }
                case .custom:
                    FormHeader {
                        ProgressView()
                    } title: {
                        Text("Wi-Fi")
                    } description: {
                        Text(
                            "Connect to Wi-Fi, view available networks, and manage settings for joining networks and nearby hotspots. [Learn more...](https://example.com)"
                        )
                    }
                }

            } header: {
                Text("Demo")
            }

        } inspector: {
            Group {
                Section {
                    Picker("Initializer", selection: $demoType) {
                        Text("System Image").tag(DemoType.systemImage)
                        Text("Image Asset").tag(DemoType.imageAsset)
                        Text("Custom Icon View").tag(DemoType.custom)
                    }
                } header: {
                    Text("Basic Configuration")
                }
                Section {
                    ScrollView(.horizontal) {
                        FiniteColorPicker(
                            "System Tint",
                            selection: $systemTint,
                            in: [.red, .blue, .green, .orange, .gray]
                        )
                        .disabled(demoType != .systemImage)
                    }
                } header: {
                    Text("Appearance")
                }
            }
        }
        .navigationTitle("Form Header")
    }
}

#Preview {
    NavigationStack {
        FormHeaderDemoView()
    }
}
