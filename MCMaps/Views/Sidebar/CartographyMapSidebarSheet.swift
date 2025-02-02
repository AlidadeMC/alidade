//
//  CartographyMapSidebarSheet.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import SwiftUI

extension PresentationDetent {
    static var smallSearch = Self.height(108)
}

struct CartographyMapSidebarSheet<T: ToolbarContent>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var viewModel: CartographyMapViewModel
    @Binding var file: CartographyMapFile
    
    var sheetToolbar: () -> T
    
    var body: some View {
        NavigationStack {
            CartographyMapSidebar(viewModel: $viewModel, file: $file)
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
#if os(iOS)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .navigationTitle(file.map.name)
                .navigationDocument(file, preview: SharePreview(file.map.name))
                .toolbar { sheetToolbar() }
        }
        .presentationDetents([.smallSearch, .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled()
        
    }
}
