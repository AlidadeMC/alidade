# Minecraft Map packages (.mcmap)

@Metadata {
    @PageImage(purpose: card, source: "Card-FileFormat")
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

**Last Updated**: 29 April 2025  
**Current Format Version**: 1.0

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

## File Metadata

Metadata about the world is stored in the `Info.json` file
(``CartographyMapFile/Keys/metadata``). It is a basic JSON object that
contains a few key pieces:

| Key                                | Type   | Description                                                                                          |
| ---------------------------------- | ------ | --------------------------------------------------------------------------------------------------   |
| ``CartographyMap/name``            | String | A player-supplied name for the world. This can be used in place of the file name in some views.      |
| ``CartographyMap/mcVersion``       | String | The version of Minecraft used to generate the world.                                                 |
| ``CartographyMap/seed``            | Number | The seed used to generate the Minecraft world.                                                       |
| ``CartographyMap/pins``            | Array  | A list of player-generated pins for the Minecraft world.                                             |
| ``CartographyMap/recentLocations`` | Array  | A list of recently-visited locations in the world. Commonly used to store previous search results.   |

The ``CartographyMap`` structure is used to handle the encoding and
decoding of these values automatically. This data can be accessed through
the ``CartographyMapFile/map`` property in the ``CartographyMapFile``.

### Recent Locations

The ``CartographyMap/recentLocations`` property is used to store recent
locations the player has visited in the app. It contains a two-dimensional
array of locations stored by their X and Z coordinates as numbers:

```json
"recentLocations" : [
    [
        -1099,
        1099
    ]
]
```

> Note: The recent locations list shouldn't contain more than a handful of
> items. It should be treated as a queue, and older entries should be
> removed from the list periodically.

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

        | Key                            | Type   | Description                                                           |
        | ------------------------------ | ------ | --------------------------------------------------------------------- |
        | ``CartographyMapPin/name``     | String | The player-assigned name for the pin.                                 |
        | ``CartographyMapPin/position`` | Array  | The location of the pin in the world. X and Z coordinates are stored. |
    }
    @Column(size: 2) {
        @Image(source: "FileFormat-Pins", alt: "A screenshot showing a player-made pin")
        An example pin for a player in their Minecraft world.
    }
}

Pins can also contain any of the following properties, which can be
customized by players:

| Key                                        | Type   | Description                                  |
| ------------------------------------------ | ------ | -------------------------------------------- |
| ``CartographyMapPin/aboutDescription``     | String | A player-authored description about the pin. |
| ``CartographyMapPin/color-swift.property`` | String | The pin's associated color.                  |
| ``CartographyMapPin/images``               | Array  | A list of images associated with this pin.   |

> Tip: To conserve disk space and memory, when players decide to delete
> pins, any associated images to that pin should also be removed. This is
> already handled with ``CartographyMapFile/removePins(at:)`` and
> ``CartographyMapFile/removePin(at:)``.

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
