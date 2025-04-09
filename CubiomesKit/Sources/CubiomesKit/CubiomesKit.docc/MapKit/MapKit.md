# MapKit for CubiomesKit

Display and interact with Minecraft world maps using a purpose-built
MapKit view.

## Overview

CubiomesKit provides integration with the MapKit framework to dynamically
display entire Minecraft world maps as map views in your macOS, iOS, and
iPadOS apps. These views support dynamically loading and unloading tiles,
along with displaying markers and annotation represented as Minecraft
coordinates.

## Topics

### Displaying a Map in AppKit/UIKit

- ``MinecraftMapView``
- ``MinecraftMapMarkerAnnotation``

### Displaying a Map in SwiftUI

- ``MinecraftMap``
- ``Marker``
- ``MinecraftMapContentBuilder``

### Point Projections and Conversions

- ``Point3D/init(projectedFrom:)``
- ``CoreLocation/CLLocationCoordinate2D/init(projecting:)``
