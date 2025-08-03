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
