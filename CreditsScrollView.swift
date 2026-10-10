//
//  CreditsScrollView.swift
//  
//
//  Created by Marquis Kurt on 10-10-2026.
//


private struct CreditsScrollView: View {
    @State private var creditsPane: AttributedString?

    var body: some View {
        ScrollView {
            Group {
                InlineBanner("Authored by Humans", message: "GEN_AI_DISCLOSURE")
                    .inlineBannerVariant(.humanAuthored)
                if let creditsPane {
                    Text(creditsPane)
                }
            }
            .padding(.horizontal, 12)
        }
        .task {
            guard let creditsPath = Bundle.main.url(forResource: "Credits", withExtension: "md") else {
                return
            }
            do {
                let contents = try String(contentsOf: creditsPath, encoding: .utf8)
                creditsPane = try AttributedString(
                    markdown: contents,
                    options:
                        AttributedString
                        .MarkdownParsingOptions(
                            allowsExtendedAttributes: true,
                            interpretedSyntax: .inlineOnlyPreservingWhitespace
                        )
                )
            } catch {
                print("Failed to get credits file: \(error.localizedDescription)")
            }
        }
    }
}