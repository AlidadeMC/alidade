# ``CubiomesKit``

@Metadata {
    @PageColor(green)
}

Generate, inspect, and view Minecraft Java worlds.

## Overview

With CubiomesKit, you can create and inspect Minecraft Java worlds
programmatically in your macOS, iOS, and iPadOS apps. It leverages the
[Cubiomes](https://github.com/Cubitect/cubiomes) library to facilitate
generation, searches, and rendering map images.

CubiomesKit also supports integration with MapKit to display interactive
maps, with support for AppKit/UIKit and SwiftUI.

> Important: At this time, only words generated in Minecraft Java Edition
> are supported.

## Topics

### Generating Minecraft Worlds

- ``MinecraftWorld``
- ``MinecraftVersion``

### Querying World Information

Query information about a Minecraft world, such as nearby biomes and
structures.

- ``MinecraftBiome``
- ``MinecraftBiomeSearching``
- ``MinecraftStructure``
- ``MinecraftStructureSearching``

### Rendering Map Tiles

Render map images of Minecraft worlds.

- ``MinecraftWorldRenderer``
- ``PPMData``

### MapKit Integration

- <doc:MapKit> 

### Point and Space Representations

- ``Point3D``
- ``MinecraftPoint``
- ``MinecraftWorldRect``
