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

    var pins: IndexedPinCollection

    @State private var selection: IndexedPinCollection.Element.ID?
    @State private var deletePinAlertPresentation = false
    @State private var deletePinAlert: IndexedPinCollection.Element?

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
                    navigationPath.append(LibraryNavigationPath.pin(pin.content, index: pin.index))
                }
                Button("Remove...", systemImage: "trash", role: .destructive) {
                    deletePinAlert = pins[element]
                    deletePinAlertPresentation.toggle()
                }
            }
        } primaryAction: { selection in
            guard let pin = selection.first else { return }
            let element = pins[pin]
            navigationPath.append(LibraryNavigationPath.pin(element.content, index: element.index))
        }
        .alert(
            "Are you sure you want to remove '\(deletePinAlert?.content.name ?? "Pin")'?",
            isPresented: $deletePinAlertPresentation) {
                Button("Remove Pin", role: .destructive) {}
                Button("Don't Remove", role: .cancel) {
                    deletePinAlert = nil
                    deletePinAlertPresentation = false
                }
            } message: {
                Text("Removing this pin will also remove any images associated with this pin.")
            }
    }
}
