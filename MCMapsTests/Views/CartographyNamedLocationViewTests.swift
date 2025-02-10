//
//  CartographyNamedLocationViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 10-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyNamedLocationViewTests {
    @Test func initalizeWithPin() throws {
        let view = CartographyNamedLocationView(pin: .init(position: .zero, name: "Pin", color: .blue))

        #expect(view.name == "Pin")
        #expect(view.location == .zero)
        #expect(view.color == .blue)
        #expect(view.systemImage == "mappin")
    }

    @Test func initializeWithParameters() throws {
        let view = CartographyNamedLocationView(
            name: "Location",
            location: .zero,
            systemImage: "location.fill",
            color: .gray
        )

        #expect(view.name == "Location")
        #expect(view.location == .zero)
        #expect(view.systemImage == "location.fill")
        #expect(view.color == .gray)
    }

    @Test func viewLayout() throws {
        let view = CartographyNamedLocationView(pin: .init(position: .zero, name: "Pin"))
        let sut = try view.inspect().implicitAnyView()

        let image = try sut.hStack().image(0)
        #expect(try image.actualImage() == Image(systemName: "mappin"))
        #expect(try image.foregroundStyleShapeStyle(Color.self) == .white)
        #expect(image.hasPadding())
        #expect(try image.padding() == .init(top: 6, leading: 6, bottom: 6, trailing: 6))
        #expect(try image.background().shape().fillShapeStyle(Color.self) == .blue)

        let nameLabel = try sut.hStack(0).vStack(1).text(0)
        let locationLabel = try sut.hStack(0).vStack(1).text(1)

        #expect(try nameLabel.string() == "Pin")
        #expect(try nameLabel.attributes().font() == .headline)

        #expect(try locationLabel.string() == "(0, 0)")
        #expect(try locationLabel.attributes().font() == .subheadline)
    }
}
