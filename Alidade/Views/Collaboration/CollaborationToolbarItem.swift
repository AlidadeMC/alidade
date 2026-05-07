//
//  CollaborationToolbarItem.swift
//  Alidade
//
//  Created by Marquis Kurt on 07-05-2026.
//

import CloudKit
import Observation
import SharedWithYou
import SwiftUI

#if canImport(AppKit)
    import AppKit
#endif

@Observable
class Coordinator: NSObject, SWCollaborationActionHandler {
    func collaborationCoordinator(
        _ coordinator: SWCollaborationCoordinator,
        handle action: SWStartCollaborationAction
    ) {
        print(action)
    }

    func collaborationCoordinator(
        _ coordinator: SWCollaborationCoordinator,
        handle action: SWUpdateCollaborationParticipantsAction
    ) {
        print(action)
    }
}

struct CollaborationToolbarItem {
    var itemProvider: NSItemProvider

    init(itemProvider: NSItemProvider) {
        self.itemProvider = itemProvider
    }

    init?(contentsOf url: URL) {
        guard let provider = NSItemProvider(contentsOf: url) else {
            return nil
        }
        self.itemProvider = provider
    }
}

#if canImport(AppKit)
    extension CollaborationToolbarItem: NSViewRepresentable {
        typealias NSViewType = SWCollaborationView

        func makeNSView(context: Context) -> SWCollaborationView {
            let collaborationView = SWCollaborationView(itemProvider: itemProvider)
            return collaborationView
        }

        func updateNSView(_ nsView: SWCollaborationView, context: Context) {

        }
    }
#endif

#if canImport(UIKit)
    extension CollaborationToolbarItem: UIViewRepresentable {
        typealias UIViewType = SWCollaborationView

        func makeUIView(context: Context) -> SWCollaborationView {
            let collaborationView = SWCollaborationView(itemProvider: itemProvider)
            return collaborationView
        }

        func updateUIView(_ uiView: SWCollaborationView, context: Context) {}
    }
#endif
