//
//  CartographyIconPicker.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-07-2025.
//

import MCMap
import SwiftUI

struct CartographyIconPicker: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var icon: CartographyIcon
    var context: CartographyIconContext

    @State private var query = ""

    private var symbols: [CartographyIcon] {
        if query.isEmpty { return CartographyIcon.allCases }
        return CartographyIcon.allCases.filter { $0.rawValue.lowercased().contains(query.lowercased()) }
    }

    var body: some View {
        Group {
            if #available(iOS 19.0, macOS 16.0, *) {
                picker
                    .searchable(text: $query)
            } else {
                picker
            }
        }
    }

    private var picker: some View {
        ScrollView {
            if #unavailable(iOS 19.0, macOS 16.0) {
                TextField("Search...", text: $query)
                    .controlSize(.large)
                    .textFieldStyle(.roundedBorder)
                    .padding([.top, .leading, .trailing])
            }
            if symbols.isEmpty {
                ContentUnavailableView.search(text: query)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 48), spacing: 8)], spacing: 8) {
                ForEach(symbols, id: \.rawValue) { icon in
                    Button {
                        self.icon = icon
                        dismiss()
                    } label: {
                        Image(cartographyIcon: icon, in: context)
                            .font(.title)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)

                }
            }
            .padding()
        }
        .frame(idealWidth: 300, minHeight: 450)
    }
}

#Preview {
    @Previewable @State var icon: CartographyIcon = .default

    NavigationStack {
        CartographyIconPicker(icon: $icon, context: .pin)
            .navigationTitle("Select an Icon")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}
