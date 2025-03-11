# ``Alidade``

@Metadata {
    @PageImage(purpose: icon, source: "AppIcon", alt: "The Alidade app icon")
    @PageColor(green)
}

Navigate and explore your Minecraft Java worlds.

## Overview

@Row(numberOfColumns: 5) {
    @Column(size: 3) {
        **Alidade** is a seed map app for Mac, iPhone, and iPad that lets
        you browse your various Minecraft Java worlds. Jump to a
        coordinate and view the surrounding world, and pin your favorite
        locations.

        This documentation bundle serves to document various aspects of
        the app and its codebase, including documentation for the
        Minecraft map package format (`.mcmap`), architecture and view
        hierarchy, and the various views and modifiers that make up the
        app.
        
        > Note: If you are viewing this documentation online, please note
        > that the documentation served is per the latest commits on the
        > `main` branch in the source code repository.
    }
    @Column(size: 2) {
        @Image(source: "AllDevices",
               alt: "Alidade running on all devices")
    }
}

### Why make Alidade?

The Minecraft community has made countless seed mapping tools and
libraries such as Chunkbase, Mineatlas, and Amidst. These tools work
great on the desktop, and they will likely suffice for you. However,
Alidade aims to offer some features that you might benefit from:

- A native app that works across Mac, iPhone, and iPad, tuned for each
  platform, respectively
- Pinning common or favorite locations visited frequently
- Deep integrations into the Apple ecosystem
- A "file over app" approach, where pinned locations, worlds frequently
  explored, etc., are all save in a simple JSON file
  
Alidade isn't being built to strictly _compete_ with the other tools
out there, but it exists as an addition to that market.

## Recommended Docs

The following docs are recommended for new and experienced developers and
contributors to read through.

@Links(visualStyle: compactGrid) {
    - <doc:Changelog>
    - <doc:FileFormat>
    - <doc:Building>
}

## Topics

### File Format

- <doc:FileFormat>
- ``CartographyMapFile``
- ``CartographyMap``
- ``CartographyMapPin``

### Architecture and View Hierarchy

- <doc:Architecture>
- ``MCMapsApp``
- ``ContentView``
- ``DocumentLaunchView-6qz0r``
- ``CartographyMapSplitView``
- ``AdaptableSidebarSheetView``

### View Models and Routing

- ``CartographyRoute``
- ``CartographyMapViewModel``
- ``CartographyPinViewModel``

### Services

- ``CartographySearchService``

### Ornament View

- ``OrnamentedView``
- ``Ornament``

### Maps

- ``CartographyOrnamentMap``
- ``MapOrnament``
- ``CartographyMapView``
- ``CartographyMapViewState``

### Map Ornaments

- ``LocationBadge``
- ``DirectionNavigator``

### Editor Forms

- ``MapCreatorForm``
- ``PinCreatorForm``
- ``MapEditorFormSheet``

### Named Locations and Pins

- ``CartographyNamedLocationView``
- ``CartographyMapPinDetailView``

### Pickers

- ``CartographyMapPinColorPicker``
- ``WorldDimensionPickerView``

### Sidebar

- ``CartographyMapSidebar``
- ``CartographyMapSidebarSheet``
- ``RecentLocationsListSection``
- ``PinnedLibrarySection``
- ``GroupedPinsSection``

### Tips and Onboarding

- ``DirectionNavigatorTip``
- ``LibraryOnboardingTip``
- ``WorldDimensionPickerTip``

### View Modifiers

- ``ZoomableModifier``

### Contributing

- <doc:Building>
- <doc:Styleguide>
