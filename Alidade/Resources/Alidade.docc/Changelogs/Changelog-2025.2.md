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

## 2025.2.3 (Build 101)

### General Changes

- Fixes a critical issue that prevents players from using Alidade on
  iPadOS 26.1. As a consequence, the default tab has been set to the
  World Editor, and players will need to manually select the map
  (ALD-29).

## 2025.2.2 (Build 98)

### General Changes

- Fixes search bar placement on iPadOS 26 to be in line with the new
  guidelines.
- The document launch window on macOS 26 now uses glass style buttons.

## 2025.2.1 (Build 94)

### General Changes

- Fixes a bug where pins of the same name get saved into the same pin
  file, potentially causing data loss (ALD-24).

## 2025.2 (Build 91) [Release Candidate]

### General Changes

- Ensure that the UUID is being used instead of the pin's name so that
  multiple pins of the same name can still appear in the tab view.

## 2025.2 (Build 89) [Release Candidate]

### General Changes

- Adjusted the user interface on macOS to remain consistent with iOS and
  iPadOS.
- Updated icon imagery to match the new design language.

## 2025.2 (Build 87) [Beta]

### Gallery

- Players can now switch between photos when previewing them with Quick
  Look.

### General Changes

- Alidade's source code repository is now being hosted on
  [SkyVault](https://source.marquiskurt.net), a hosted Git service
  independent of GitHub. SkyVault is intended to be the source of truth,
  but the GitHub repository will be remain available as a mirror and a
  source for accepting pull requests.

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

