//
//  HelpCommands.swift
//  Alidade
//
//  Created by Marquis Kurt on 18-01-2026.
//

import SwiftUI

/// A group of commands that make up the "Help" menu.
struct HelpCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Link("\(MCMapsApp.information.name) Help", destination: URL(appLink: .help)!)
            Divider()
            if let docs = URL(appLink: .docs) {
                Link("View \(MCMapsApp.information.name) Documentation", destination: docs)
            }
            if let feedback = URL(appLink: .issues) {
                Link("Send \(MCMapsApp.information.name) Feedback", destination: feedback)
            }
        }
    }
}
