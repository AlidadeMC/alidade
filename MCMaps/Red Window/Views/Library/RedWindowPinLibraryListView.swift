//
//  RedWindowPinLibraryListView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowPinLibraryListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var navigationPath: NavigationPath
    @Binding var deletionRequest: RedWindowPinDeletionRequest

    var pins: IndexedPinCollection

    @State private var selection = Set<IndexedPinCollection.Element.ID>()

    var body: some View {
        Table(pins, selection: $selection) {
            TableColumn("Name") { val in
                Label {
                    VStack(alignment: .leading) {
                        Text(val.content.name)
                            .bold(horizontalSizeClass == .compact)
                        if horizontalSizeClass == .compact {
                            Text(val.content.position.accessibilityReadout)
                                .foregroundStyle(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: "mappin")
                        .foregroundStyle(val.content.color?.swiftUIColor ?? .accent)
                }
            }
            TableColumn("Location", value: \.content.position.accessibilityReadout)
            TableColumn("Tags") { val in
                Group {
                    if let tags = val.content.tags, !tags.isEmpty {
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
        .contextMenu(forSelectionType: IndexedPinCollection.Element.ID.self) { selection in
            if let element = selection.first {
                Button("Get Info", systemImage: "info.circle") {
                    let pin = pins[element]
                    navigationPath.append(RedWindowLibraryNavigationPath.pin(pin.content, index: pin.index))
                }
                Button("Remove...", systemImage: "trash", role: .destructive) {
                    deletionRequest.elementIDs = selection
                    deletionRequest.presentAlert = true
                }
            }
        } primaryAction: { selection in
            guard let pin = selection.first else { return }
            let element = pins[pin]
            navigationPath.append(RedWindowLibraryNavigationPath.pin(element.content, index: element.index))
        }
    }
}
