//
//  Route.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI

enum Route: Hashable, CaseIterable {
    case chipTextField
    case namedLocation
}

extension Route {
    var name: String {
        switch self {
        case .chipTextField:
            "Chip Text Field"
        case .namedLocation:
            "Named Location"
        }
    }

    var symbol: String {
        switch self {
        case .chipTextField:
            "tag"
        case .namedLocation:
            "mappin"
        }
    }

    var navigationLink: some View {
        NavigationLink(value: self) {
            Label(self.name, systemImage: self.symbol)
        }
    }
}
