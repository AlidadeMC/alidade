# ``MinecraftWorld``

Minecraft worlds consist of a specified version the world was created in,
and the seed used to generate the world.

A world can be initialized by specifying this information:

```swift
let world = try MinecraftWorld(version: "1.21", seed: 123)
```

> Note: If the version maps or parses to an invalid Minecraft version, the
> ``WorldError/invalidVersionNumber`` is thrown.

## Topics

### World dimensions

- ``Dimension``

### Searching for structures and biomes

- ``findBiomes(ofType:at:inRadius:dimension:)``
- ``findStructures(ofType:at:inRadius:dimension:)``
