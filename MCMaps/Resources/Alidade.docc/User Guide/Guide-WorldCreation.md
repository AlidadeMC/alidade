# Create and manage worlds

Create and manage Minecraft world maps in Alidade.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "1.0")
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
           the seed to insert.
        3. Click **Create** to create the map.
    }
    @Tab("iPhone and iPad") {
        1. On the launch screen, tap the **Create Map** button.
        2. In the **Create Map** form, enter the name of your world,
           select a Minecraft version, and enter the seed of the world.
           You can use the `/seed` command in your Minecraft world to get
           the seed to insert.
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
can open the world info editor to retrigger the flow.

@TabNavigator {
    @Tab("Mac") {
        1. In the world you want to edit, click the "World Info" button
           (this appears as a globe with a gear).
        2. In the **World Info** form, update the fields as if you were
           creating a new map.
        3. Click **Done** to dismiss the form.
    }
    @Tab("iPhone and iPad") {
        1. In the world you want to edit, tap the name of the file and
           select **Update World Info**.
        2. In the **World Info** form, update the fields as if you were
           creating a new map.
        3. Tap the back arrow (‹) to go back to the library.
    }
}

### Delete a map

You can use a file browser such as the Files app on iPhone and iPad or the
Finder on the Mac to delete the corresponding `.mcmap` file from your
device.
