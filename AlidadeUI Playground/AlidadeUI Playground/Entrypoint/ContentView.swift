//
//  ContentView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI

struct ContentView: View {
    @State private var filterQuery = ""
    @State private var currentRoute: Route?

    private var components: [Route] {
        if filterQuery.isEmpty { return Route.allCases }
        return Route.allCases.filter { $0.name.localizedLowercase.contains(filterQuery) }
    }

    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    if components.isEmpty {
                        ContentUnavailableView.search(text: filterQuery)
                    } else {
                        ForEach(components, id: \.self) { route in
                            route.navigationLink
                        }
                    }
                } header: {
                    Text("Components")
                }
            }
            .navigationTitle("UI Components")
            .navigationDestination(for: Route.self) { route in
                detail(for: route)
            }
            .searchable(text: $filterQuery, placement: .sidebar)
        } detail: {
            detail(for: currentRoute)
        }
    }

    private func detail(for currentRoute: Route?) -> some View {
        Group {
            switch currentRoute {
            case .chipTextField:
                ChipTextFieldDemoView()
            case .finiteColorPicker:
                FiniteColorPickerDemoView()
            case .formHeader:
                FormHeaderDemoView()
            case .inlineBanner:
                InlineBannerDemoView()
            case .namedLocation:
                NamedLocationDemoView()
            case .namedTextField:
                NamedTextFieldDemoView()
            case nil:
                ContentUnavailableView(
                    "Select a component",
                    systemImage: "info.circle")
            }
        }
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.browser)
        #else
            .navigationSubtitle("Alidade UI Library")
        #endif
    }
}

#Preview {
    ContentView()
}
