# ``MinecraftMapView``

### Differences with MKMapView

The Minecraft map view is a subclass of the MKMapView, with some notable
differences:

- Rotation (pitch) is disabled. While rotation works on macOS, it has
  caused issues on iOS and iPadOS.
- A pre-defined zoom range is in place (64 meters minimum, 512 meters
  maximum). While this can be adjusted, it isn't recommended, as your app
  might crash due to the larger tile sizes.
- Concurrent drawing on macOS is automatically enabled to improve
  performance.

## Customizing the map

### Displaying ornaments

Ornaments refer to controls and views that sit above the map, typically to
adjust the map or display additional information in some way. This can be
adjusted with the ``ornaments`` property:

```swift
let mapView = MinecraftMapView(world: ..., frame: .zero)
mapView.ornaments = [.compass]
```

> Important: Although ``MinecraftMapView`` subclasses MKMapView, it is not
> recommended to set the individual ornaments (i.e., `showZoomControls`,
> `showsCompass`). Setting the ``ornaments`` property will handle this for
> you.

### Customizing the color scheme

By default, map views will render using the default color scheme, which is
common among tools like Amidst, Cubiomes Viewer, Chunkbase, and more. The
color scheme can be changed by adding
``MinecraftWorldRenderer/Options-swift.struct/naturalColors`` to the map
view's ``renderOptions``:


```swift
let mapView = MinecraftMapView(world: ..., frame: .zero)
mapView.ornaments = [.compass]
mapView.renderOptions = [.naturalColors]
```

### Listening for delegate events

The Minecraft map view implements the MKMapViewDelegate to handle drawing
Minecraft map tiles and other annotations. To listen for map events such
as the region changing, create a delegate and assign it to the
``mcMapViewDelegate`` property:

```swift
class MyView: UIViewController {
    lazy var mapView: MinecraftMapView = {
        let mapView = MinecraftMapView(world: ..., frame: .zero)
        mapView.translatesautoresizingMaskIntoConstraints = false
        mapView.ornaments = [.compass]
        mapView.mcMapViewDelegate = self
        view.addSubview(mapView)
        return mapView
    }()
}


extension MyView: MinecraftMapViewDelegate {
    ...
}
```

## Topics

### Delegates

- ``mcMapViewDelegate``
- ``MinecraftMapViewDelegate``
