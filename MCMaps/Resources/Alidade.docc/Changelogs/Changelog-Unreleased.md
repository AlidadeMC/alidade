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

## General Changes

- Alidade's versioning scheme is being updated with this new release. All
  released will now follow the `<year>.<release-number>.<bugfix?>` format,
  making it easier to identify versions over time. Currently, this release
  will be reflected as `2025.2`.
- The map should now display more accurate biome boundaries based on the
  dimension being viewed.

## File Format

- The second version of the Minecraft map package format is under
  development. Currently, v2 makes a few changes:
  - The `mcVersion` and `seed` properties are being moved into a new
    `world` object.
  - The `world` object now includes a property for large biomes (defaults)
    to `false`.
  - A new `tags` property is available on pins, which contains a set of
    strings.
  - The format includes new `AppState` and `Integrations` subdirectories
    that are used to store configuration data for the app's state and the
    integrations supported for a given map, respectively.
- Code pertaining to the encoding and decoding of the file format is now
  moved into a separate package, `MCMapFormat`. This may become its own
  repository in the future.

## Integrations

- Alidade can now optionally fetch server markers and player markers from
  Minecraft servers that have the Bluemap server plugin installed.
  Settings such as the server, refresh rate, and which data to fetch can
  be configured per map in the world settings.

## Pins

- Players can create and edit tags for pins in the inspector (#15). When
  searching for content, players can filter by a given tag to show pins
  that are tagged with the specified tag.
- The new Gallery view allows players to view all the photos in their
  world from the pins they've created in a single place (#14).

## User Interface

- Starting with macOS/iOS/iPadOS 26, players will interact with a new user
  interface codenamed "Red Window", leveraging the new Liquid Glass design
  language from Apple. The new interface offers a unified design across
  the platforms that expands the current feature set. More technical
  information about Red Window can be found at <doc:RedWindow>.
- The Recents section has been moved to the top in the legacy view, and
  the maximum number of items has been trimmed to five locations,
  providing better visibility for the player's library.
