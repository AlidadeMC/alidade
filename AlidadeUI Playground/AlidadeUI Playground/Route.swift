//
//  Route.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI

enum Route: Hashable, CaseIterable {
    case chipTextField
}

extension Route {
    var name: String {
        switch self {
        case .chipTextField:
            "Chip Text Field"
        }
    }

    var symbol: String {
        switch self {
        case .chipTextField:
            "tag"
        }
    }

    var navigationLink: some View {
        NavigationLink(value: self) {
            Label(self.name, systemImage: self.symbol)
        }
    }
}
