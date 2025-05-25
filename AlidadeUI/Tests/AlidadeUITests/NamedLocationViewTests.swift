//
//  NamedLocationViewTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 25-05-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct NamedLocationViewTests {
    @Test(.tags(.namedLocation))
    func initializeWithParameters() throws {
        let view = NamedLocationView(
            name: "Location",
            location: .zero,
            systemImage: "location.fill",
            color: .gray
        )

        #expect(view.testHooks.name == "Location")
        #expect(view.testHooks.location == .zero)
        #expect(view.testHooks.systemImage == "location.fill")
        #expect(view.testHooks.color == .gray)
    }

    @Test(.tags(.namedLocation))
    func viewLayout() throws {
        let view = NamedLocationView(name: "Pin", location: .zero)
        let sut = try view.inspect()

        let image = try sut.hStack().image(0)
        #expect(try image.actualImage() == Image(systemName: "mappin"))
        #expect(try image.foregroundStyleShapeStyle(Color.self) == .white)
        #expect(image.hasPadding())
        #expect(try image.padding() == .init(top: 6, leading: 6, bottom: 6, trailing: 6))
        #expect(try image.background().shape().fillShapeStyle(Color.self) == .accentColor)

        let nameLabel = try sut.hStack(0).vStack(1).text(0)
        let locationLabel = try sut.hStack(0).vStack(1).text(1)

        #expect(try nameLabel.string() == "Pin")
        #expect(try nameLabel.attributes().font() == .headline)

        #expect(try locationLabel.string() == "(0, 0)")
        #expect(try locationLabel.attributes().font() == .subheadline)
    }
}
