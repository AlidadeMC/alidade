//
//  MinecraftMapView.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import Foundation
import MapKit

public final class MinecraftMapView: MKMapView {
    public struct Ornaments: OptionSet, Sendable {
        public let rawValue: Int

        public static let compass = Ornaments(rawValue: 1 << 0)
        public static let zoom = Ornaments(rawValue: 1 << 1)
        public static let scale = Ornaments(rawValue: 1 << 2)

        public static let all: Ornaments = [.compass, .zoom, .scale]

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public var centerBlockCoordinate: CGPoint {
        get { return MinecraftMapMarkerAnnotation.unproject(centerCoordinate) }
        set {
            print(newValue, MinecraftMapMarkerAnnotation.project(newValue))
            DispatchQueue.main.async { [weak self] in
                self?.setCenter(MinecraftMapMarkerAnnotation.project(newValue), animated: true)
            }
        }
    }

    public var dimension: MinecraftWorld.Dimension = .overworld {
        didSet {
            redrawDimension()
        }
    }

    public var renderOptions: MinecraftWorldRenderer.Options = [.naturalColors] {
        didSet {
            minecraftOverlay?.renderer.options = renderOptions
        }
    }

    public var ornaments: Ornaments = [.compass] {
        didSet { reconfigureOrnaments() }
    }

    public var world: MinecraftWorld

    var minecraftOverlay: MinecraftRenderedTileOverlay!

    public init(world: MinecraftWorld, frame: CGRect, dimension: MinecraftWorld.Dimension = .overworld) {
        self.world = world
        self.dimension = dimension
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self

        self.register(MKMarkerAnnotationView.self,
                      forAnnotationViewWithReuseIdentifier: "\(MKMarkerAnnotationView.self)")

        self.configureMapView()
        self.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        let overlay = MinecraftRenderedTileOverlay(world: world, dimension: dimension)
        self.addOverlay(overlay, level: .aboveLabels)
        self.minecraftOverlay = overlay
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureMapView() {
        #if os(macOS)
        self.canDrawConcurrently = true
        #endif
        self.cameraZoomRange = CameraZoomRange(minCenterCoordinateDistance: 64, maxCenterCoordinateDistance: 256)
        self.isPitchEnabled = false
        self.isZoomEnabled = true
        self.isRotateEnabled = false
    }

    func reconfigureOrnaments() {
        self.showsCompass = ornaments.contains(.compass)
        #if os(macOS)
        self.showsZoomControls = ornaments.contains(.zoom)
        #endif
        self.showsScale = ornaments.contains(.scale)
    }

    func redrawDimension() {
        guard let minecraftOverlay else { return }
        minecraftOverlay.dimension = self.dimension
        if let renderer = renderer(for: minecraftOverlay) as? MKTileOverlayRenderer {
            renderer.reloadData()
        }
    }

    static func compareAnnotations(_ lhs: any MKAnnotation, _ rhs: any MKAnnotation) -> Bool {
        switch (lhs, rhs) {
        case let (lhs as MinecraftMapMarkerAnnotation, rhs as MinecraftMapMarkerAnnotation):
            return lhs.coordinate == rhs.coordinate && lhs.title == rhs.title
        default:
            return lhs.coordinate == rhs.coordinate
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MinecraftMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        return switch overlay {
        case let overlay as MKTileOverlay:
            MKTileOverlayRenderer(overlay: overlay)
        default:
            MKOverlayRenderer(overlay: overlay)
        }
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MinecraftMapMarkerAnnotation else { return MKAnnotationView() }
        guard let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: "\(MKMarkerAnnotationView.self)",
            for: annotation
        ) as? MKMarkerAnnotationView else {
            return MKMarkerAnnotationView()
        }
        
        view.markerTintColor = annotation.color
        return view
    }
}
