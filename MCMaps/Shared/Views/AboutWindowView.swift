//
//  AboutWindowView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import SwiftUI

/// A view for displaying information about the current app.
///
/// Currently, this is used on the macOS side to replace the standard "About Alidade" window, providing more
/// information such as the open-source projects and libraries used, the contributors that have helped with the project,
/// etc.
struct AboutWindowView: View {
    private enum Constants {
        static let appIconSize: Double = 128.0
        static let paneWidth: Double = 300.0
    }
    private var version: String {
        return String(localized: "v\(MCMapsApp.version) (Build \(MCMapsApp.buildNumber))")
    }

    @State private var creditsPane: AttributedString?

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                VStack {
                    Image("AppIcon-static")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.appIconSize, height: Constants.appIconSize)
                    Text(MCMapsApp.appName)
                        .font(.title)
                        .bold()
                    Text(version)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(MCMapsApp.copyrightString)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                }

                VStack {
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
            Group {
                if let creditsPane {
                    ScrollView {
                        Text(creditsPane)
                            .padding(.horizontal, 12)
                    }
                }
            }
            .frame(width: Constants.paneWidth)
            .frame(maxHeight: .infinity)
            .background(.windowBackground)

        }
        .task {
            guard let creditsPath = Bundle.main.url(forResource: "Credits", withExtension: "md") else {
                return
            }
            do {
                let contents = try String(contentsOf: creditsPath, encoding: .utf8)
                creditsPane = try AttributedString(
                    markdown: contents,
                    options: AttributedString
                        .MarkdownParsingOptions(
                            allowsExtendedAttributes: true,
                            interpretedSyntax: .inlineOnlyPreservingWhitespace
                        )
                )
            } catch {
                print("Failed to get credits file: \(error.localizedDescription)")
            }
        }
        .frame(width: 600, height: 400)
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

            var creditsFile: AttributedString? {
                target.creditsPane
            }
        }
    }
#endif
