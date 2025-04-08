# ``MinecraftVersion``

Different Minecraft versions can alter behaviors in the world, such as
which structures are available, what biomes are generated, etc. A version
can be defined by parsing a string:

```swift
let version = MinecraftVersion("1.21")
```

or by using a Cubiomes type:

```swift
let version = MC_1_21
```

> Note: Due to limitations with the way this enumeration is imported in
> Cubiomes, all of their cases are separate. They are prefixed with `MC_`.

### Validation

Some versions may be unsupported by Cubiomes or may be parsed incorrectly.
The `isUndefined` property can be used to determine such cases:

```swift
if version.isUndefined { ... }
```
