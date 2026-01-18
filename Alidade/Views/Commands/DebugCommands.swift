//
//  DebugCommands.swift
//  Alidade
//
//  Created by Marquis Kurt on 18-01-2026.
//

#if DEBUG
    import SwiftUI
    import TipKit

    /// A group of commands useful for debugging Alidade.
    ///
    /// > Note: This command group is only available in debug builds of Alidade.
    struct DebugCommands: Commands {
        var body: some Commands {
            CommandMenu("Debug") {
                Menu("Tips") {
                    Button("Show All Tips") {
                        Tips.showAllTipsForTesting()
                    }
                    Button("Hide All Tips") {
                        Tips.hideAllTipsForTesting()
                    }
                    Button("Reset Tip Datastore") {
                        do {
                            try Tips.resetDatastore()
                        } catch {
                            print("Failed to reset datastore: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
#endif
