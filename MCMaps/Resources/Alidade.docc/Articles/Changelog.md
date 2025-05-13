# What's New in Alidade

@Metadata {
    @TitleHeading("Release Notes")
    @PageColor(purple)
    @PageImage(purpose: card, source: "Card-Changelog")
}

Read through the release notes for the latest versions of Alidade.

## Overview

The following document outlines the changes in each version of the app
across Mac, iPhone, and iPad.

### Unreleased

> Note: The following changelist contains information for an unreleased
> build. To get these features, you will need to build from source.
> Refer to <doc:Building> for more information.

- The second version of the Minecraft map package format is under
  development. Currently, v2 makes a few changes:
  - The `mcVersion` and `seed` properties are being moved into a new
    `world` object.
  - The `world` object now includes a property for large biomes (defaults)
    to `false`.

## 1.0.1 (Build 45)

**Also released as**: 1.0 (Build 45) [Beta]

- **Fixed**: Changing the "Natural Colors" setting on a map wouldn't
  refresh the entire map.
- To further ensure compatibility with future `.mcmap` package formats,
  files saved in Alidade will now apply a ``MCMapManifest_v1/manifestVersion``
  key.

## 1.0 (Build 43)

Initial public release 🎉

### 1.0 (Build 42) [RC]

- Players can now create pins without visiting a location by tapping the
  new pin button in the toolbar.

### 1.0 (Build 41) [RC]

- On iOS and iPadOS, the sidebar sheet should now retain the behavior of
  expanding the view when beginning a search, if t wasn't expanded
  already.
- On iOS and iPadOS, when creating a new map, a message will appear below
  to inform players the app only supports Minecraft: Java Editions worlds
  in order to reduce confusion.

### 1.0 (Build 38) [Beta]

- CubiomesKit, the internal library used to generate Minecraft map content
  and search for content, has been moved to its own separate repository at
  https://github.com/alicerunsonfedora/cubiomeskit! This allows the
  library to be updated independently of Alidade, and lets developers
  leverage the technologies in their own apps and services.
- Rendered map tiles are now cached, so loading should be faster on iOS
  and iPadOS.
- The location badge on the map view should now properly reflect the
  centermost coordinate of the map view.
- The codebase has been update to ensure full compatibility with Swift 6,
  ensuring better handling of concurrency and protection against data
  races.

### 1.0 (Build 33) [Beta]

- Maps have been completely revamped in this release. Rather than
  displaying a static snapshot, map can be moved around more easily thanks
  to the migration to MapKit with custom tile overlays. Maps also now
  support proper zooming with the scroll wheel, plus/minus keys, and
  gestures.
- Pins are now visible on the map. Tapping on them will also display their
  corresponding coordinate value.
- Files in iOS and iPadOS now have a corresponding icon that uses the
  Alidade pin (thanks @joeisanerd)!
- The location badge includes a new transition for the numbers when the
  location changes.
- A tip for pinning recent locations has been added to guide players to
  where pinning locations takes place (#24).
- A new <doc:UserGuide> article collection is available in the
  documentation to help players learn how to use the app, if they are
  unfamiliar with using the app, and the tips being displayed aren't
  helpful to them. Navigating to **Help › Alidade Help** on the Mac will
  open this user guide collection in their default browser.
- The sidebar sheet on iPhone and iPad has been slightly redesigned to
  address presentation changes in the iOS 18.4 SDK.

### 1.0 (Build 29) [Beta]

- In the pin detail view, the coordinates for both the Overworld and the
  Nether are displayed. This allows players to identify ways of travel
  across dimensions, along with marking notable location in the Nether.
- The adaptable sidebar sheet view has been moved into its own package,
  which can be found on [GitHub](https://github.com/alicerunsonfedora/adaptablesidebarsheetview).
- A tip for adding photos to a created pin now displays in the pin's
  detail view to encourage players to add screenshots or photos from their
  world (#24).
- Alidade is going through a minor visual refresh that matches the new
  design system being developed and designed. This current release
  replaces the accent color from the default system green color to the new
  "Firewatch Red" brand color.
- The document launch view on macOS has been redesigned to align with the
  Apple-provided one on iOS and iPadOS, providing the same visual
  background and sheet appearance.
- The app and document icons, along with the background in the document
  launch view have been replaced with new versions that align with the
  Alidade design system.
- Fixes visual alignment issues with the "About Alidade" window on macOS.

### 1.0 (Build 27) [Beta]

- Updates the new document experience on macOS to match iOS and iPadOS
  with a new form that lets players enter the Minecraft version and seed
  before launching into a blank document.
- Replaces the generic about screen with a more specialized and purpose
  built version on macOS.
- Replaces the Minecraft version text field with a dropdown menu to
  ensure that valid versions are identifiable and selectable.

### 1.0 (Build 25) [Beta]

- Adds new menu bar entries for "Send Alidade Feedback" and "View Alidade
  Documentation" under the Help menu on macOS.
- Introduces tips for getting started with Alidade, starting with the
  library/sidebar, navigation controls, and the world dimension picker.
  This is an ongoing effort aimed to help highlight features (#24).
- Fixes an issue where documents wouldn't always open on the recent
  projects list in the "Welcome to Alidade" window on macOS (#22).
- Changes the button style on the navigator wheel to allow more lenient
  mouse presses on macOS (#23).
- Adds keyboard shortcuts to quickly navigate with the wheel with Command
  and the arrow keys: i.e., Cmd + Up to go up, Cmd + Left to go left,
  etc. (#23).

### 1.0 (Build 23) [Beta]

- Initial release.
