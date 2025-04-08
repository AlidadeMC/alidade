# ``MinecraftWorldRenderer``

The world renderer is used to generate map tiles into portable pixmap
data (PPM) that can be saved to a file or rendered directly in views, as
with ``MinecraftMapView``.

```swift
let renderer = MinecraftWorldRenderer(world: world)
let snapshotRange = MinecraftWorldRange(
    origin: MinecraftPoint(x: 0, y: 0, z: 0),
    scalingTo: 256) 
let ppmData = renderer.render(inRange: snapshotRange)
```

## Customizing the renderer

To generate a map tile using natural colors, add ``Options/naturalColors``
to the set of options to the renderer:

```swift
let renderer = MinecraftWorldRenderer(world: world)
renderer.options = [.naturalColors]
let ppmData = renderer.render(inRange: snapshotRange)
```

### Adjusting rendering positions

By default, the renderer will render a map with the assumption that the
origin provided in the range refers to the center tile. To change this to
the top left, remove the ``Options/centerPositions`` option from the
options provided:

```swift
let renderer = MinecraftWorldRenderer(world: world)
renderer.options.remove(.centerPositions)
let ppmData = renderer.render(inRange: snapshotRange)
```
