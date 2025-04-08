# ``MinecraftWorldRect``

World rectangles start at an origin point (``origin``) and expand by a
given ``size``. For example, the following creates a rect that spans 256
blocks in each direction along the world, with a height of one block:

```swift
let myRect = MinecraftWorldRect(origin: .zero,
    size: MinecraftWorldRect.Size(squaring: 256))
```

### Reference points and scaling

Most systems, such as structure and biome search, will treat the
``origin`` as the centermost point, and the ``size`` will scale evenly
outside, radiating from the center. However, in some instances, the origin
can be treated as the top left corner of the rectangle. Such examples
include:

- Map tiles in ``MinecraftMapView``
- Images generated with the ``MinecraftWorldRenderer``, unless
  ``MinecraftWorldRenderer/Options-swift.struct/centerPositions`` is
  specified.

