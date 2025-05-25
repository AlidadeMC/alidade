# ``MCMapManifest_v2``

### Changes from CartographyMap

- The ``MCMapManifest_v1/mcVersion`` and ``MCMapManifest_v1/seed`` keys have
  been moved into a new ``worldSettings`` object.
- The ``worldSettings`` object now has a
  ``MCMapManifestWorldSettings/largeBiomes`` property to control whether
  large biomes are enabled for that world.
- Pins now have an optional ``MCMapManifestPin/tags`` property, which
  contain a set of strings the player has associated with a pin.
