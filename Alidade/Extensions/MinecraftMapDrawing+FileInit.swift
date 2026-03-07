//
//  MinecraftMapDrawing+FileInit.swift
//  Alidade
//
//  Created by Marquis Kurt on 07-03-2026.
//

import CubiomesKit
import MCMap
import MapKit

extension MinecraftMapDrawing {
    init(cartographyDrawing drawing: CartographyDrawing) {
        let location = CLLocationCoordinate2D(projecting: drawing.data.coordinate)
        self.init(
            id: drawing.id,
            drawing: drawing.data.drawing,
            location: location,
            mapRect: MKMapRect(cartographyRect: drawing.data.mapRect))
    }
}

extension MKMapRect {
    init(cartographyRect rect: CartographyDrawing.DrawingOverlay.MapRect) {
        self.init(x: Double(rect.x), y: Double(rect.z), width: Double(rect.width), height: Double(rect.height))
    }
}
