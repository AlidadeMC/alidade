//
//  CartographyMapViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyMapViewTests {
    @Test func displayProgressWhenLoading() throws {
        let mapView = CartographyMapView(state: .loading)
        let sut = try mapView.inspect().implicitAnyView()

        #expect(mapView.state == .loading)
        #expect(try !sut.group().progressView(0).isAbsent)
    }

    @Test func displayErrorWhenUnavailable() throws {
        let mapView = CartographyMapView(state: .unavailable)
        let sut = try mapView.inspect().implicitAnyView()

        #expect(mapView.state == .unavailable)
        #expect(try !sut.group().contentUnavailableView(0).isAbsent)

        let unavailableView = try sut.group().contentUnavailableView(0)
        #expect(
            try unavailableView
                .labelView()
                .label()
                .title()
                .text()
                .string() == String(localized: "No Map Available", bundle: Bundle.main)
        )
        #expect(try unavailableView.labelView().label().icon().image().actualImage() == Image(systemName: "map"))
    }

    @Test func displayMapData() throws {
        guard let imagePath = Bundle(for: Helper.self).url(forResource: "map", withExtension: "ppm") else {
            Issue.record("Resource not found.")
            return
        }
        let data = try Data(contentsOf: imagePath)
        let mapView = CartographyMapView(state: .success(data))
        let sut = try mapView.inspect().implicitAnyView()

        #expect(mapView.state == .success(data))
        #expect(try !sut.group().anyView(0).isAbsent)

        let image = try sut.group().anyView(0).image(0)
        #expect(throws: Never.self) {
            try image.actualImage()
        }

        #expect(try image.actualImage().renderedData == Image(data: data).resizable().renderedData)
    }
}

extension Image {
    @MainActor
    fileprivate var renderedData: CFData? {
        let render = ImageRenderer(content: self)
        return render.cgImage?.dataProvider?.data
    }
}
