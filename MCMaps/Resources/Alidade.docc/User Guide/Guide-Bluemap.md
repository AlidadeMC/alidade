# Add Bluemap data to your map

Show players and server markers from Minecraft servers with Bluemap
installed.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "2025.2")
    @PageImage(purpose: icon, source: "Icon-Guide")
}

## Overview

Bluemap is a popular Minecraft server plugin that provides a 3D map view
of a Minecraft server and its various worlds. It can provides its own
markers and map annotations, and it displays active players on the server
and their locations in real time.

Starting with Alidade v2025.2, players with Minecraft servers that have
this plugin can incorporate its data into their maps directly, making them
visible on their map.

> Important: You will need to ensure that your Bluemap server supports
> access through HTTPS to use this functionality in Alidade. You may need
> to set up a reverse proxy using Caddy or NGINX to allow this behavior.
>
> [Set up a reverse proxy &rsaquo;](https://bluemap.bluecolored.de/wiki/webserver/ReverseProxy.html)

## Enabling Bluemap integration

Bluemap integration is an opt-in feature, requiring that you manually
enable the feature yourself.

> Important:
> You will need the following information to enable the integration:
> 
> - The domain to where the Bluemap service is being hosted.

1. Open the map you'd like to integrate with Bluemap.
2. In the World tab, go to **Bluemap** in the Integrations section.
3. Turn on **Enable Integration** in the Bluemap integration page.
4. Under the **Bluemap Server** section, enter the host where the Bluemap
   web app is being hosted.

> Important: You do _not_ need to provide the `http://` prefix when
> entering the Bluemap host.

### Custom worlds

Some Minecraft servers might map the Overworld, Nether, and End dimensions
to different worlds. Alidade will automatically try to infer the world
structure with sane defaults, but you can override this by provide the
corresponding mapping.

Under the **Dimensions** section, provide the world name for each
dimension. If you are unsure of the world names, refer to the worlds list
on the Bluemap web app for your server.

### Customize what to display

Under the **Display** section, you can configure what information is
displayed on your map when pulling data from Bluemap:

- **Player Markers** show active players on the server at their active
  location.
- **Player Death Markers** show markers where players have died.
- **Points of Interest** show markers on the map provided by the server.

### Realtime player sync

By default, Alidade will attempt to pull player locations at the same time
it tries to pull data from Bluemap to preserve battery life and reduce
network usage. However, you can force Alidade to fetch player markers more
frequently.

1. Open the map you'd like to integrate with Bluemap.
2. In the World tab, go to **Bluemap** in the Integrations section.
3. Under the **Bluemap Server** section, toggle **Realtime Sync**.

When this toggle is enabled, player markers will be fetched every
half-second, independently of the standard syncing parameters defined by
the **Refresh every:** time interval in the **Bluemap Server** section.

## Search for Bluemap markers

When the integration is enabled, Bluemap markers will be visible in search
results. This allows you to look for server points of interest easily
using the same search experience.

### Create local pins from server markers

When searching for server marks in the search bar, you can create a local
copy of a server marker to further customize it. Alidade will store the ID
of the marker from the server into your pin, preferring to display your
local copy wherever possible.

@Row {
    @Column {
        > Important: If the ID of the marker changes on the Bluemap
        > server, Alidade will treat it as a different pin. However, you
        > can edit the pin manually and assign the new ID by adding the
        > corresponding ID to the `alternateIDs` field of the pin.
        >
        > For more information, refer to the pin format on the MCMap
        > format documentation.
        >
        > [View MCMap documentation &rsaquo;](https://mcmap.alidade.dev)

    }
    @Column {
        > SeeAlso: For more information on creating pins from search
        > results, refer to
        > [Create a pin from a search result](doc:Guide-Pins#Create-a-pin-from-a-search-result).
    }
}

## Additional resources

[Bluemap &rsaquo;](https://bluemap.bluecolored.de)

