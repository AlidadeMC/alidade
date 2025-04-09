# ``MinecraftMapContent``

This protocol is used to simplify adding and removing map content in
``MinecraftMap`` and ``MinecraftMapView`` types, especially under SwiftUI.

This protocol isn't useful on its own, as it is mostly conformed to by map
content types such as ``MinecraftMapMarkerAnnotation``. Likewise, these
types are as a result from result builders such as
``MinecraftMapContentBuilder``.

Map content can either be an annotation or an overlay. Conforming types
should also conform to their respective MapKit types as well: notably,
annotations should also conform to `MKAnnotation`, and overlays should
conform to `MKOverlay`.

## Topics

### Content Types

- ``MinecraftMapContentType``
- ``contentType``
