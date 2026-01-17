# Create and manage worlds

Create and manage Minecraft world maps in Alidade.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "2025.2")
    @PageImage(purpose: icon, source: "Icon-Guide")
}

## Overview

Unlike most seed map apps, Alidade takes a document-based approach to seed
maps to make it easier to switch between worlds across various Minecraft
versions.

### Create a map

@TabNavigator {
    @Tab("Mac") {
        1. In the "Welcome to Alidade" window, click **Create a Map**.
        2. In the **Create Map** form, enter the name of your world,
           select a Minecraft version, and enter the seed of the world.
           You can use the `/seed` command in your Minecraft world to get
           the seed to insert. If your world was created with the Large
           Biomes feature, click the toggle to enable it.
        3. Click **Create** to create the map.
    }
    @Tab("iPhone and iPad") {
        1. On the launch screen, tap the **Create Map** button.
        2. In the **Create Map** form, enter the name of your world,
           select a Minecraft version, and enter the seed of the world.
           You can use the `/seed` command in your Minecraft world to get
           the seed to insert. If your world was created with the Large
           Biomes feature, tap the toggle to enable it.
        3. Tap **Create** to create the map.
    }
}

### Change where Alidade saves maps

@TabNavigator {
    @Tab("iPhone and iPad") {
        1. Open the Settings app on your device.
        2. Navigate to **Apps › Alidade**.
        3. Tap **Document Storage**, then select the location you'd like to
           save maps to.
    }
}

> Note: This section is only applicable to iPhone and iPad. On the Mac,
> you will be prompted to select the location of where you'd like to save
> the map.

### Update map information

If you need to update the world information at a later point in time, you
can open the world info editor to make changes to the world settings.

> Important: The following documentation applies for Alidade 2025.2 when
> running on macOS 26 Tahoe and later or iOS/iPadOS 26 and later. To review
> the guide for macOS 15 Sequoia or iOS/iPadOS 18, refer to the guide for
> v1: <doc:Guide-Navigation-v1>.

1. Open the world map containing the world you'd like to make changes to.
2. Navigate to the **World** tab or go to **View &rsaquo; World** in the
   menu bar.
3. Perform the changes you'd like to the world. Changes are applied
   automatically and will be saved when you save the map.

### Delete a map

You can use a file browser such as the Files app on iPhone and iPad or the
Finder on the Mac to delete the corresponding `.mcmap` file from your
device.
