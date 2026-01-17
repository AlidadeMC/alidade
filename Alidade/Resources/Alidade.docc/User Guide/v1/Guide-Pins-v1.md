# Create and customize pins

Pin memorable locations and add information about them.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "1.0", deprecated: "2025.2")
    @PageImage(purpose: icon, source: "Icon-Guide")
}

## Overview

Alidade provides a system for pinning locations that players may want to
remember or come back to for various reasons. Pins can be given a name and
color, and players can write descriptions about specific pins, along with
providing screenshots of their world at those locations to personalize
pins.


### Create a pin arbitrarily

@TabNavigator {
    @Tab("Mac") {
        1. Click the pin with the plus badge in the toolbar or press
           Command + P on your keyboard.
        2. In the **Create Pin** form, provide the name, color, and
           coordinates for the pin.
        3. Click **Create** to create the pin. It will be displayed in the
           sidebar under the Library section.
    }
    
    @Tab("iPhone and iPad") {
        1. Tap the pin with the plus badge in the toolbar.
        2. In the **Create Pin** form, provide the name, color, and
           coordinates for the pin.
        3. Click **Create** to create the pin. It will be displayed in the
           sidebar under the Library section.
    }
}

### Create a pin from a recent location

@TabNavigator {
    @Tab("Mac") {
        1. Right-click or swipe right on a recent location to create a
           pin.
        2. In the **Create Pin** form, provide a name and color you'd like
           to associate the location with.
        3. Click **Create** to create the pin. It will be displayed in the
           sidebar under the Library section.
    }
    
    @Tab("iPhone and iPad") {
        1. Tap and hold or swipe right on a recent location to create a
           pin.
        2. In the **Create Pin** form, provide a name and color you'd like
           to associate the location with.
        3. Click **Create** to create the pin. It will be displayed in the
           sidebar under the Library section.
    }
}

### Navigate to a pin

@TabNavigator {
    @Tab("Mac") {
        In the Library, click on the pin or right-click and select
        **Go Here** to visit the pin on the map.
    }
    
    @Tab("iPhone and iPad") {
        In the Library, tap on the pin or tap and hold and select
        **Go Here** to visit the pin on the map.
    }
}

### Update a pin's contents

To open the pin inspector, do the following:

@Row(numberOfColumns: 5) {
    @Column(size: 3) {
        @TabNavigator {
            @Tab("Mac") {
                1. Click on the pin you'd like to update or make changes
                   to.
                2. The pin should open in an inspector pane on the right of
                   the window. If the pane isn't visible, click on the Pin
                   Inspector toolbar item (the icon with a pin and a gear).
            }
                
            @Tab("iPhone and iPad") {
                1. Tap on the pin you'd like to update or make changes to.
            }
        }

        ---
            
        The following fields of a pin can be edited:

        - Pressing on the pin's name will let you rename the pin to
          anything you'd like.
        - Pressing any of the colored circles about the **About** box will
          let you change the pin's color.
        - Pressing on the **About** box at the bottom of the inspector
          will let you write any notes or description for the pin.
        
        > Tip: The pin inspector pane displays two sets of coordinates:
        > the first being for the overworld (denoted by the tree symbol),
        > and the second being the Nether coordinate (denoted by a flame
        > symbol) that you'd need to visit to place a portal and appear at
        > that location in the overworld.
    }
    @Column(size: 2) {
        ![The pin inspector pane](FileFormat-Pins.png)
        _Fig. 2_: The pin inspector pane on Mac.
    }
}
  
#### Add screenshots and photos to a pin

@TabNavigator {
    @Tab("Mac") {
        - To add a photo from your Photos library, click the "From Photos"
          option in the **Add Photos** section of the pin inspector. The
          system photo library picker appears, where you can select the
          photos you'd like to add to the pin.
        
        > Note: Alidade is only given access to the photos you directly
        > select for upload. It cannot read or write to your photo
        > library.
      - To add a photo from your Mac outside of the Photos library, click
        the "From Finder" option in the **Add Photos** section of the pin
        inspector. The system will display a file picker where you can
        select the image you'd like to add to the library.
    }
        
    @Tab("iPhone and iPad") {
        - To add a photo from your Photos library, tap the **Add Photos**
          button. If you already have photos added to a pin, swipe left to
          the end of the photos carousel and tap the plus button.
        
        > Note: Alidade is only given access to the photos you directly
        > select for upload. It cannot read or write to your photo
        > library.
    }
}

## Delete a pin

@TabNavigator {
    @Tab("Mac") {
        1. Right-click and select **Delete Pin...** or swipe left on a pin
           to delete it.
        2. A new dialog will appear, warning you that any associated
           photos will be removed along with the pin. To confirm, click
           **Remove**.
    }
    
    @Tab("iPhone and iPad") {
        1. Tap and hold and select **Delete Pin...** or swipe left on a
           pin to delete it.
       2. A new dialog will appear, warning you that any associated
          photos will be removed along with the pin. To confirm, tap
          **Remove**.
    }
}

> Important: Removing a pin from the library will also remove any
> associated photos. However, changes only take effect when you close or
> save the file.
