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

### General

- Alidade 2026.1 now requires iOS/macOS 26 or later.

### Drawings

> Important: The Drawings feature is currently in beta and is controlled
> by the feature flag `flags.features.map_drawings`. Visit the Alidade
> Settings page to enable the feature.

- Players can now draw on the map directly using Apple Pencil or touch
  input to create custom overlays that can be displayed on Mac, iPhone, and
  iPad (ALD-7).
- The new Drawings tab allows players to view and manage all of their
  drawings in one convenient place.

### Map

- The coordinate indicator can now be hidden by going to the map settings.
  On macOS, this can be used to improve general performance.

### Search

- Search capabilities have been expanded to support new syntax for power
  users.
  - Use the `tag: <tag>` or `#tag` syntax to filter results by a specific
    tag.
  - Use `origin: {X,Z}` to localize results to a specific origin point.
  - Use `dimension: <dimension>` to filter results to a specific
    dimension.
- On macOS, the search bar is now automatically focused when navigating to
  the search bar. This can be disabled in the settings via 'Automatically
  focus the search bar when going to the Search tab' (ALD-26).
