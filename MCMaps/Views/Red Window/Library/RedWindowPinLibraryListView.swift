//
//  RedWindowPinLibraryListView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinLibraryListView: View {
    @Binding var navigationPath: NavigationPath

    var pins: [MCMapManifestPin]

    @State private var selection: MCMapManifestPin.ID?

    var body: some View {
        Table(pins, selection: $selection) {
            TableColumn("Name") { val in
                Label {
                    Text(val.name)
                } icon: {
                    Image(systemName: "mappin")
                        .foregroundStyle(val.color?.swiftUIColor ?? .accent)
                }
            }
            TableColumn("Location", value: \.position.accessibilityReadout)
            TableColumn("Tags") { val in
                Group {
                    if let tags = val.tags, !tags.isEmpty {
                        ViewThatFits {
                            HStack {
                                ForEach(Array(tags), id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.quaternary.opacity(0.25))
                                        )
                                }
                            }
                            Text("^[\(tags.count) Tag](inflect: true)")
                        }
                    } else {
                        Text("No Tags")
                    }
                }
            }
        }
        .contextMenu(forSelectionType: MCMapManifestPin.ID.self) { _ in } primaryAction: { selection in
            guard let pin = selection.first else { return }
            navigationPath.append(LibraryNavigationPath.pin(pin))
        }
    }
}
