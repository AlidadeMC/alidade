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

extension Image {
    @MainActor
    fileprivate var renderedData: CFData? {
        let render = ImageRenderer(content: self)
        return render.cgImage?.dataProvider?.data
    }
}
