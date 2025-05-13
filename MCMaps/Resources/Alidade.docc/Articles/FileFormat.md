# Minecraft Map packages (.mcmap)

@Metadata {
    @TitleHeading("Specification")
    @PageImage(purpose: card, source: "Card-FileFormat")
    @PageColor(purple)
}

Learn and understand the file format Alidade uses to read and write
Minecraft world maps.

## Overview

Minecraft worlds will generate differently based on the version being
played and the seed used to run the internal generation algorithms.
Players will often juggle between other worlds across devices and
versions, making re-entering this data particularly cumbersome. To address
this, Alidade uses a document-based approach to store worlds as files
using the `.mcmap` file package format.

The following article will outline the file format, key structures
involved, and best practices for working with the file format.

**Last Updated**: 3 May 2025  
**Current Format Version**: 1

### Key Tenets

The `.mcmap` format has been carefully designed with the following key 
tenets in mind:

- **Portability**: The file format should be portable and easy to
  assemble.
- **Cross-platform**: Wherever possible, the file format should be
  designed to work across platforms, both within and outside of the Apple
  ecosystem.
- **Human-readable**: The format should be readable and inspectable to
  players.
- **Performant**: The file format should be performant to read from and
  write to.

## General Structure

An `.mcmap` file is a package that consist of at least one file,
`Info.json` (see ``CartographyMapFile/Keys/metadata``). Below is an
example structure of how an `.mcmap` file looks on disk:

```
My World.mcmap/
    Info.json
    Images/
        f6654efd-e52c-4dae-b5e0-e91f08d8cb54.heic
        309643c9-d86b-4079-a9a6-4805d1b3c8e4.heic
        0c25dea0-ec2e-4061-87ca-da9391193889.heic
```

> Note: The `.mcmap` file is not a compressed archive. On Windows and
> other platforms that don't have Alidade installed, it will appear as a
> directory.


`.mcmap` files might also contain an `Images` directory (see
``CartographyMapFile/Keys/images``), containing various images, typically
stored in the HEIC file format.

<a name="File-metadata" />

## The Manifest

The `.mcmap` file contains a top-level file, `Info.json`, which provides
critical metadata about the file. This file is known as the _manifest_,
and it is heavily versioned.

The manifest will usually contain data such as the world's name, version,
seed, and player-created pins. Depending on the manifest version, they can
be stored in different locations or keys. At the time of writing, the
latest stable version of the manifest is Version **1**; files without the
``MCMapManifestProviding/manifestVersion`` key supplied are assumed to be
this version.

```json
{
    "manifestVersion": 2,
    "name": "My World",
    "world": {
        "version": "1.21",
        "seed": 123
    },
    "pins": [ ... ],
    "recentLocations": [ ... ]
}
```

> SeeAlso: The latest version of the manifest can be accessed via
> ``MCMapManifest``. Refer to its documentation to learn the differences
> across versions.

The manifest also contains a `name` property, which represents the name of
the world, if it doesn't match the name of the file.

### World settings

Most manifest versions store world-specific information in the world
settings object, denoted as `world`, which contains three required
properties:

- ``MCMapManifestWorldSettings/version``: (String) The version of
  Minecraft: Java Edition used to create the world.
- ``MCMapManifestWorldSettings/seed``: (Int) The seed used to generate the
  Minecraft world.
- ``MCMapManifestWorldSettings/largeBiomes``: (Bool) Whether to use the
  "Large Biomes" setting to generate the world.

> Note: In older manifest versions,
> ``MCMapManifestWorldSettings/largeBiomes`` would always evaluate to
> false, as those versions did not support this key.

### Recent locations

The `recentLocations` key is used to store a list of recently visited
locations that the player can revisit or use to create a pin. It consists
of a two-dimensional array, with each subarray representing coordinates on
the X and Z axes:

```json
{
    "recentLocations": [ [0, 0], [1847, 1847] ]
}
```

### Pins

@Row(numberOfColumns: 6) {
    @Column(size: 4) {
        Pins are objects created by the player to mark specific points of
        interest in the world and associate specific metadata with them,
        such as images, colors, and descriptions. Pins are intended to be
        customizable and personal to the player's preferences and should
        offer flexibility.
        
        > Note: Pins are still a work in progress feature that will be
        > updated over time with more customization and personalization
        > options.
        
        A pin must contain the following keys:
        
        - `name`: (String) The player-assigned name for the pin.
        - `position`: (Array) The location of the pin in the world on the
           X and Z axes.
    }
    @Column(size: 2) {
        @Image(source: "FileFormat-Pins", alt: "A screenshot showing a player-made pin")
        An example pin for a player in their Minecraft world.
    }
}

Pins can also contain any of the following properties, which can be
customized by players:

- `aboutDescription`: (String) A player-authored description about the
  pin.
- `color`: (String) The pin's associated color.
- `images`: (Array) A list of images associated with this pin.

Some manifest versions might also provide their own properties on top of
these ones.

> Tip: To conserve disk space and memory, when players decide to delete
> pins, any associated images to that pin should also be removed. This is
> already handled with ``CartographyMapFile/removePins(at:)`` and
> ``CartographyMapFile/removePin(at:)`` in ``CartographyMapFile``.


## Images

Pins and other relevant data types might contain images that are
associated to them. Officially, the `.mcmap` file format doesn't
enforce a consistent naming convention for image files, but
Alidade will generate a unique UUID string to be used as the
file's name when a player uploads a photo from their Photos
library or an image file from their Mac through the Finder.

Images that correspond to a given data type, such as a pin, should
match the name of the file as it is stored in the 
``CartographyMapFile/Keys/images`` directory, without the folder
path. See below for how this is correlated for a pin as an
example.

@Row {
    @Column {
        **Info.json**
        ```json
        {
            ...,
            "pins" : [
                {
                    "name" : "My Pin",
                    "position" : [
                        0,
                        0
                    ],
                    "images" : [
                        "MyFile.heic"
                    ],
                    ...
                }
            ]
        }
        ```
    }
    @Column {
        **My World.mcmap**
        ```
        My World.mcmap/
            Info.json
            Images/
                MyFile.heic
                ...
        ```
    }
}

> Tip: Consider making image file names unique, and don't tie them
> with names of data types. Since players can rename these types
> at any given moment, having a unique name that isn't associated
> with a data type's name ensures stability across rename
> operations.

## Topics

### File Structures

- ``CartographyMapFile``

### Manifests

- ``CartographyMapFile/Manifest-swift.typealias``
- ``MCMapManifest``
- ``MCMapManifest_PreVersioning``
- ``MCMapManifest_v1``
- ``MCMapManifest_v2``
