# Alidade 2025.2 Release Notes

View the release notes for the 2025.2.x release series of Alidade.

@Metadata {
    @TitleHeading("Release Notes")
    @PageColor(purple)
    @PageImage(purpose: card, source: "Card-Changelog")
}

> Important: The following release is **pre-release software**. Features
> and improvements may change over time, and the current releases are not
> indicative of the final release build. Proceed with caution.

## 2025.2 (Build 70) [Beta]

### General Changes

- Alidade's versioning scheme is being updated with this new release. All
  released will now follow the `<year>.<release-number>.<bugfix?>` format,
  making it easier to identify versions over time. Currently, this release
  will be reflected as `2025.2`.
- The map should now display more accurate biome boundaries based on the
  dimension being viewed.

### File Format

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

### Integrations

- Alidade can now optionally fetch server markers and player markers from
  Minecraft servers that have the Bluemap server plugin installed.
  Settings such as the server, refresh rate, and which data to fetch can
  be configured per map in the world settings.

### Pins

- Players can create and edit tags for pins in the inspector (#15). When
  searching for content, players can filter by a given tag to show pins
  that are tagged with the specified tag.
- The new Gallery view allows players to view all the photos in their
  world from the pins they've created in a single place (#14).

### User Interface

- Starting with macOS/iOS/iPadOS 26, players will interact with a new user
  interface codenamed "Red Window", leveraging the new Liquid Glass design
  language from Apple. The new interface offers a unified design across
  the platforms that expands the current feature set. More technical
  information about Red Window can be found at <doc:RedWindow>.
- The Recents section has been moved to the top in the legacy view, and
  the maximum number of items has been trimmed to five locations,
  providing better visibility for the player's library.

#### Known Issues

- Editing the title or description of a pin when accessed from the sidebar
  on macOS or iPadOS causes the app to jump back to the map unexpectedly,
  only saving the first character typed. (#45)

**Workaround**: Navigate to the pin from the **All Pins** tab in the
sidebar, and toggle edit mode there.

- Pins when displayed on the map in the pin detail view may display as
  '#nodraw' and don't accurately reflect the location on macOS and,
  occasionally, iPadOS. (#46) 

