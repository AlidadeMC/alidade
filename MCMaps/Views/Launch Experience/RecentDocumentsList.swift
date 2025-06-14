//
//  RecentDocumentsList.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-03-2025.
//

import DesignLibrary
import SwiftUI

/// A view that displays a list of recent documents.
struct RecentDocumentsList: View {
    /// The view model used to interact with recent documents.
    var viewModel: DocumentLaunchViewModel

    /// A list of recent documents the player has interacted with.
    ///
    /// This is typically pulled from macOS itself, and it shouldn't be manually crafted.
    var recentDocuments: [URL]

    @ScaledMetric private var fileHeight = 36.0
    @ScaledMetric private var filePaddingH = 4.0
    @ScaledMetric private var filePaddingV = 2.0

    var body: some View {
        List(selection: viewModel.selectedFileURL) {
            ForEach(recentDocuments, id: \.self) { url in
                HStack {
                    Image("File Preview")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 1)
                        .padding(.vertical, filePaddingV)
                        .padding(.horizontal, filePaddingH)
                        .frame(height: fileHeight)
                    VStack(alignment: .leading) {
                        Text(viewModel.sanitize(url: url))
                            .font(.headline)
                        HStack {
                            if viewModel.isInMobileDocuments(url) {
                                Image(systemName: "icloud")
                                    .foregroundStyle(SemanticColors.DocumentLaunch.mobileDocument)
                            }
                            Text(viewModel.friendlyUrl(url))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 2)
                .tag(url)
            }
        }
        .buttonStyle(.plain)
        .listStyle(.sidebar)
        .background(.thinMaterial)
        .ignoresSafeArea(.container)
    }
}
