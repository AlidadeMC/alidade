//
//  NamedLocationDemoView.swift
//  AlidadeUI Playground
//
//  Created by Marquis Kurt on 25-05-2025.
//

import AlidadeUI
import SwiftUI

extension NamedLocationView.CoordinateDisplayMode: @retroactive Hashable {
    public static func == (
        lhs: NamedLocationView.CoordinateDisplayMode,
        rhs: NamedLocationView.CoordinateDisplayMode
    ) -> Bool {
        switch (lhs, rhs) {
        case (.absolute, .absolute):
            return true
        case let (.relative(lhsCoord), .relative(rhsCoord)):
            return lhsCoord == rhsCoord
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .absolute:
            hasher.combine(0)
        case .relative(let cGPoint):
            hasher.combine(cGPoint)
        }
    }
}

struct NamedLocationDemoView: View {
    enum SampleLocation {
        case zero, augenwaldburg, cupertino
    }

    @State private var name = "My Location"
    @State private var symbol = "mappin"
    @State private var color = Color.accentColor
    @State private var coordinateDisplayMode = NamedLocationView.CoordinateDisplayMode.absolute
    @State private var location = SampleLocation.zero

    private var locationPoint: CGPoint {
        switch location {
        case .zero:
            CGPoint.zero
        case .augenwaldburg:
            CGPoint(x: 1847, y: 1847)
        case .cupertino:
            CGPoint(x: 124, y: 1984)
        }
    }

    var body: some View {
        DemoPage {
            Section {
                NamedLocationView(name: name, location: locationPoint, systemImage: symbol, color: color)
                    .coordinateDisplayMode(coordinateDisplayMode)
            } header: {
                Text("Demo")
            }
        } inspector: {
            Group {
                Section {
                    TextField("Name", text: $name)
                    Picker("Location", selection: $location) {
                        Text("Origin").tag(SampleLocation.zero)
                        Text("Augenwaldburg").tag(SampleLocation.augenwaldburg)
                        Text("Cupertino").tag(SampleLocation.cupertino)
                    }
                } header: {
                    Text("Basic Configuration")
                }
                
                Section {
                    TextField("System Image", text: $symbol)
                        .autocorrectionDisabled()
                        #if os(iOS)
                            .textInputAutocapitalization(.never)
                        #endif
                        .monospaced()
                    ColorPicker("Color", selection: $color)
                    Picker("Coordinate Display Mode", selection: $coordinateDisplayMode) {
                        Text("Absolute").tag(NamedLocationView.CoordinateDisplayMode.absolute)
                        Text("Relative").tag(NamedLocationView.CoordinateDisplayMode.relative(.zero))
                    }
                } header: {
                    Text("Styling Configuration")
                }
            }
        }
        .navigationTitle("Named Location")
    }
}

#Preview {
    NavigationStack {
        NamedLocationDemoView()
    }
}
