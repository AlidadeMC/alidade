# ``MinecraftMapContentBuilder``

This is typically used to generate corresponding `MKAnnotation` annotations
for ``MinecraftMapView`` or other MapKit views. The ``MinecraftMap`` view,
for example, uses this allow creating annotations inline with its
initializer:

```swift
var myMap: some View {
    MinecraftMap(world: ...) {
        Marker(location: CGPoint(...), title: "My Base")
        if isNether {
            Marker(location: ..., title: "Nether Farm")
        }
    }
}
```

## Topics

### Building Content

- ``MinecraftMapBuilderContent``
- ``MinecraftMapContent``
