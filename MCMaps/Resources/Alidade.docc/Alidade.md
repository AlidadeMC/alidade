# ``Alidade``

Navigate and explore your Minecraft Java worlds

## Overview

**Alidade** is a small maps app for Mac, iPhone, and iPad that lets you
browse your various Minecraft Java worlds. Jump to a coordinate and view
the surrounding world, and pin your favorite locations.

> Warning: Alidade is prerelease software. The current feature set,
> design, and overall functionality is not final and will change over
> time. Proceed with caution!

The following pages are designed to document the inner workings of the
codebase, the Minecraft map package file format (`.mcmap`), and other
relevant parts of the app.

## Topics

### File Format

- <doc:FileFormat>
- ``CartographyMapFile``
- ``CartographyMap``
- ``CartographyMapPin``

### App Entrypoint

- ``MCMapsApp``
- ``ContentView``

### Navigation

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
- ``SearchedStructuresSection``

### View Modifiers

- ``ZoomableModifier``
