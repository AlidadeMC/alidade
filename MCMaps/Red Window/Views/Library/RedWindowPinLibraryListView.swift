//
//  RedWindowPinLibraryListView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import MCMap
import SwiftUI

/// A collection view that displays player-created pins in a list layout.
///
/// Pins are displayed using a table, showing the pin's name, location, and associated tags. Depending on the
/// available space, tags might be truncated.
///
/// Players can swipe on table rows to initiate a selection. Selecting a pin will inform the parent navigation view to
/// open the child page for the pin. Additionally, a request to delete a set of pins might be provided through the
/// ``deletionRequest`` property.
struct RedWindowPinLibraryListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The parent navigation view's path.
    @Binding var navigationPath: NavigationPath

    /// The current request to delete a given set of pins.
    @Binding var deletionRequest: RedWindowPinDeletionRequest

    /// The pins to display in the list.
    var pins: IndexedPinCollection

    @State private var selection = Set<IndexedPinCollection.Element.ID>()
    @ScaledMetric private var baseScale = 1.0

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
                    Image(cartographyIcon: val.content.icon ?? .default, in: .pin)
                        .foregroundStyle(val.content.color?.swiftUIColor ?? .accent)
                        .frame(width: 28 * baseScale)
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
                Button("Copy Coordinates", systemImage: "document.on.document") {
                    Task {
                        let pin = pins[element]
                        let pasteboard = PasteboardActor()
                        await pasteboard.copy(pin.content.position)
                    }
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
