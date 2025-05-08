# ``MCMapManifest_v2``

The manifest a basic JSON object that contains a few key pieces:

| Key                                | Type   | Description                                                                                          |
| ---------------------------------- | ------ | --------------------------------------------------------------------------------------------------   |
| ``CartographyMap/manifestVersion`` | Number | The manifest version of the file format. The default should be v1 (`1`).                             |
| ``CartographyMap/name``            | String | A player-supplied name for the world. This can be used in place of the file name in some views.      |
| ``CartographyMap/pins``            | Array  | A list of player-generated pins for the Minecraft world.                                             |
| ``CartographyMap/recentLocations`` | Array  | A list of recently-visited locations in the world. Commonly used to store previous search results.   |

### Changes from CartographyMap

- The ``CartographyMap/mcVersion`` and ``CartographyMap/seed`` keys have
  been moved into a new ``worldSettings`` object.
- The ``worldSettings`` object now has a
  ``MCMapManifestWorldSettings/largeBiomes`` property to control whether
  large biomes are enabled for that world.
