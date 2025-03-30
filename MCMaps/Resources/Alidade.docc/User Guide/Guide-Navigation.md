# Navigate around maps

Navigate and teleport around maps.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "1.0")
    @PageImage(purpose: icon, source: "Icon-Guide")
}


## Move around the map

@Row(numberOfColumns: 4) {
    @Column(size: 3) {
        A small navigator circle should appear in the bottom right hand corner of
        the app. If you do not see this circle on iPhone or iPads with the app in
        Slide Over, you may need to pull down the sheet first.

        Press any of the arrows in the designated circle to move up, down, left,
        or right by 256 blocks in each direction, respectively.

        > Tip: On macOS or iPads with Magic Keyboard attached, you can press the
        > Command key followed by any of the arrow keys to perform these actions.
    }
    @Column(size: 1) {
        ![The navigator wheel](Navigation-Wheel.png)
        _Fig. 1: The navigation wheel in Alidade._
    }
}

> Important: At the time of writing this, Alidade does not support navigation
> gestures with infinite scrolling or zooming. This is a known quirk and
> is planned for future iterations of the app.
>
> For more details, refer to GitHub issue
> [#21: Infinity grid](https://github.com/alicerunsonfedora/mcmaps/issues/21).


## Jump to a location

1. Tap or click on the search bar labeled **Go To...**.
2. Type the coordinate you'd like to jump to. For example, to head to
   (X=12, Z=31), type '`12, 31`'.
3. Select the **Jump Here** item that appears at the top of the search
   results.

> SeeAlso: For more information on searching, refer to <doc:Guide-Search>.

### Switch between dimensions

Alidade supports displaying maps in the Overworld, Nether, and End
dimensions.

@TabNavigator {
    @Tab("Mac") {
        1. In the toolbar, click on the map icon.
        2. In the dropdown, select the dimension you'd like to view.
    }
    @Tab("iPhone and iPad") {
        1. Tap the map icon that appears on top of the map.
        2. In the menu, select the dimension you'd like to view.
    }
}

> Note: Some maps in other dimensions may not render correctly if the map's
> Minecraft version doesn't support that dimension and will instead
> display a solid color.

## Change the visual appearance of maps

Alidade uses a natural color scheme designed to closely resemble the real
environments in-game. However, some players may prefer to use the
traditional color schemes used by other tools like Amidst, Chunkbase, etc.

@TabNavigator {
    @Tab("Mac") {
        1. In the toolbar, click on the map icon.
        2. In the dropdown, select the **Natural Colors** entry.
    }
    @Tab("iPhone and iPad") {
        1. Tap the map icon that appears on top of the map.
        2. In the dropdown, select the **Natural Colors** entry.
    }
}

This setting is applied across the entire app, rather than a specific map.
