//
//  AboutWindowView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import BedrockUI
import SwiftUI

/// A view for displaying information about the current app.
///
/// Currently, this is used on the macOS side to replace the standard "About Alidade" window, providing more
/// information such as the open-source projects and libraries used, the contributors that have helped with the project,
/// etc.
struct AboutWindowView: View {
    private enum Constants {
        static let appIconSize: Double = 128.0
        static let paneWidth: Double = 325.0
        static let windowHeight: Double = 425.0
    }

    private var version: String {
        return String(localized: "v\(Alidade.information.version) (Build \(Alidade.information.buildNumber))")
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                VStack {
                    Group {
                        Image("AppIcon-static")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.appIconSize, height: Constants.appIconSize)
                    }
                    .balatroCardEffect(speed: 0.5, rotation: 2, direction: .clockwise)
                    .padding(2)
                    Text(Alidade.information.name)
                        .font(.title)
                        .bold()
                    Text(version)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(Alidade.information.copyrightString)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                }

                VStack(alignment: .leading) {
                    if let github = URL(appLink: .github) {
                        Link(destination: github) {
                            Label("View Source Code", systemImage: "hammer")
                        }
                    }
                    if let issues = URL(appLink: .issues) {
                        Link(destination: issues) {
                            Label("Send Feedback", systemImage: "ladybug")
                        }
                    }
                    if let docs = URL(appLink: .docs) {
                        Link(destination: docs) {
                            Label("View Documentation", systemImage: "books.vertical")
                        }
                    }
                }
                .padding(.top, 16)
            }
            .frame(width: Constants.paneWidth)
            .frame(maxHeight: .infinity)

            CreditsScrollView()
                .frame(width: Constants.paneWidth)
                .frame(maxHeight: .infinity)
                .background(.windowBackground)
                .usePreferredAppearance()
        }
        .frame(width: Constants.paneWidth * 2, height: Constants.windowHeight)
        .background(.clear)
    }
}

#if DEBUG
    extension AboutWindowView {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: AboutWindowView

            fileprivate init(target: AboutWindowView) {
                self.target = target
            }

            var versionString: String {
                target.version
            }
        }
    }
#endif
