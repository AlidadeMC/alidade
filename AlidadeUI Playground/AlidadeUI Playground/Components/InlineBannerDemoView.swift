//
//  InlineBannerDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 26-05-2025.
//

import AlidadeUI
import SwiftUI

struct InlineBannerDemoView: View {
    @State private var title = "Truth recovered"
    @State private var message = "This is as close to the truth as we will get."
    @State private var variant = InlineBanner.Variant.information

    var body: some View {
        DemoPage {
            Section {
                InlineBanner(LocalizedStringKey(title), message: LocalizedStringKey(message))
                    .inlineBannerVariant(variant)
            } header: {
                Text("Demo")
            }
        } inspector: {
            Group {
                Section {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message)
                } header: {
                    Text("Basic Configuration")
                }

                Section {
                    Picker("Variant", selection: $variant) {
                        Text("Information").tag(InlineBanner.Variant.information)
                        Text("Success").tag(InlineBanner.Variant.success)
                        Text("Warning").tag(InlineBanner.Variant.warning)
                        Text("Error").tag(InlineBanner.Variant.error)
                    }
                }
            }
        }
        .navigationTitle("Inline Banner")
    }
}

#Preview {
    InlineBannerDemoView()
}
