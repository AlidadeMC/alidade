# Unreleased Features

View release notes upcoming features not yet available in an Alidade
release.

@Metadata {
    @TitleHeading("Release Notes")
    @PageColor(purple)
    @PageImage(purpose: card, source: "Card-Changelog")
}

## Overview

This document is used to cover upcoming features and changes to Alidade
that aren't available in a particular release yet. These will change over
time as new versions and features are added.

### Gallery

- Players can now switch between photos when previewing them with Quick
  Look.

### Integrations

- Players can now enable Realtime Sync for Bluemap to get realtime updates
  for player locations. Server and death markers sync independently of
  players.
- Players can now search for markers from Bluemap in the search views.

### Map

- Maps will now group pins together in a cluster if they're close enough
  to each other. Player-crated pins will be clustered together in their
  own category; Bluemap death markers and Bluemap server markers are
  grouped in their own clusters, respectively.
- Performance of map loading has improved with Swift concurrency thanks to
  moving biome generation to a separate actor.

### Pins

- Players can now select custom icons to use when displayed in the list
  and grid views in the library, along with their appearance on the map.
- In the Red Window design, players can now tap on a photo in the detail
  view for any pin to preview it in full detail.
- Players can now set the dimension for where a pin is located. Pins are
  assumed to be in the overworld by default when migrating from MCMap v1.
- Things that pertain to editing the pin (except for photos) are now
  displayed when you’re actively editing the pin in the edit mode.
- On iOS (and macOS, though it already did this by default), the title
  text field now has a proper border and background, making it clearer
  that it is, in fact, a text field.
- When entering edit mode, the cover image is replaced with a color
  gradient and the gallery is hidden. This is mostly due to the fact that
  editing with those images visible causes performance issues.
- There’s a new coordinates section that displays coordinate information
  between the Overworld and the Nether. For coordinates in the End, only
  the End coordinate is displayed.
- For windows that _can_ display the map view on the side, you can now
  toggle this at your own discretion.

### Search

- Searches can be filtered relative to a specific coordinate using the
  `@{x,z}` syntax, where `x` and `z` are the X and Z coordinates of the
  location.
- The search page now displays tips for refining search results.
