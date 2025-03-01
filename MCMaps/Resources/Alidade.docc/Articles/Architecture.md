# Architecture

@Metadata {
    @PageImage(purpose: card, source: "Card-Architecture")
}

Learn and understand Alidade's architecture and view hierarchy.

## Overview

Alidade presents slightly different interfaces based on the platform it is
running on. This document will outline the views used to lay out this
architecture, and how the view hierarchy is navigated.

## App Architecture

Alidade uses a typical Model/View/View Model (MVVM) approach while
leveraging the binding and state capabilities of SwiftUI. Most views will
reference the main view model, ``CartographyMapViewModel``, and the
current file via ``CartographyMapFile``. Some views might present their
own view models, generally derived from the main view model; for example,
the pin detail view creates a ``CartographyPinViewModel`` using the
current file and pin index to automatically read and write the changes for
a specific pin.

Some views might maintain their own internal state independent of the main
view model, such as in ``OrnamentedView``. These should remain lightweight
or generate their own view model.

## Entrypoint

Alidade shares the same entry point across macOS, iOS, and iPadOS through
``MCMapsApp`` and ``ContentView``. These entry points are used to set up
the document group that handles reading and writing files, along with the
document launch windows for macOS, iOS, and iPadOS. It also handles
creating the main view model that is generally passed down through a
`@Binding` property.

``ContentView`` handles displaying the appropriate layouts based on the
platform and window size, and it applies the appropriate toolbar items.
This is mostly due to how `DocumentGroup` handles displaying document
views, where macOS receives no additional navigation view.

Both the iOS and macOS versions of the app use a document launch view to
provide facilities for creating new maps and opening recent files. The iOS
version leverages the `DocumentLaunchGroupScene` introduced in iOS 18,
while the macOS version creates its own view that looks and functions
similarly to that of other apps like Grids and Xcode.

## Common Routing

To maintain a consistent routing system between macOS, iOS, and iPadOS, a
routing system is defined through ``CartographyRoute``. Routes define
common pathways for various parts of the app, such as the pin detail view
and the world information editor.

On iOS and iPadOS, these routes will be displayed as views in the
navigation stack inside of the main sidebar sheet
(see ``CartographyMapSidebarSheet`` and ``AdaptableSidebarSheetView``,
respectively).

macOS displays some of these routes differently based on the type of route
being displayed. To assist with these behaviors, the
``CartographyRoute/requiresInspectorDisplay`` and
``CartographyRoute/requiresModalDisplay`` properties are available on the
current route. To maintain bindings with SwiftUI, these properties also
have shadow properties through the main view model (see 
``CartographyMapViewModel/displayCurrentRouteAsInspector`` and
``CartographyMapViewModel/displayCurrentRouteModally``, respectively).

## View hierarchy

While Alidade uses a common entrypoint and content view, the user
interfaces and experiences vary based on the target platform it is running
on. Most internal views will be shared between the two experiences to
maintain consistency, however, such as the ``CartographyOrnamentMap`` and
the ``CartographyMapSidebar``.

### macOS - Split View

@Image(
   source: "Architecture-MacOS_Main",
   alt: "A traditional Alidade Mac window")
_Fig. 1: A traditional Alidade Mac window_

The macOS target uses a traditional `NavigationSplitView` to display a
collapsible sidebar on the left, and the map as the main detail content on
the right. This view is defined in ``CartographyMapSplitView``, and it is
only available for the macOS target. See below for how various routes
defined in ``CartographyRoute`` are handled.

@TabNavigator {
    @Tab("Inspectors") {
        Routes that are to be displayed as inspectors (see
        ``CartographyRoute/requiresInspectorDisplay``) will display in an
        inspector pane, sharing space with the map. A toolbar button is
        available to toggle whether this pane is displayed per player
        preference.

        > Note: Currently, this only applies to the
        > ``CartographyRoute/pin(_:pin:)`` route.

        @Image(
           source: "Architecture-MacOS_Inspector",
           alt: "An Alidade Mac window with the pin inspector open")
        _Fig. 2a: An Alidade Mac window with the pin inspector open_
    }
    @Tab("Sheets") {
        Routes that are to be displayed as modals (see
        ``CartographyRoute/requiresModalDisplay``) will display as a sheet
        on top of the main view. Only one sheet can be present at a given
        time, and the corresponding views are responsible for displaying
        mechanisms for dismissing sheets in one form or another.

        @Image(
           source: "Architecture-MacOS_Sheet",
           alt: "An Alidade Mac window with the world editor sheet open")
        _Fig. 2b: An Alidade Mac window with the world editor sheet open_
    }
}

### iOS and iPadOS - Sidebar Sheet

The iOS and iPadOS targets use a custom view type,
``AdaptableSidebarSheetView``. This view type allows iOS and iPadOS to
share the same sheet content and scale accordingly based on the width of
available space. Routes defined with ``CartographyRoute`` will be pushed
to the navigation stack containing the sheet view.


The sidebar sheet view is always visible, and it cannot be dismissed
automatically. On iOS or smaller widths (such as when running via Slide
Over), the view takes on the appearance of a regular sheet, allowing for
adjustments at small, medium, and large breakpoints. On iPadOS or larger
widths, the view takes on the appearance of a floating sidebar, allowing
for adjustments at similar breakpoints. 

@Row(numberOfColumns: 4) {
    @Column(size: 3) {
        @Image(source: "Architecture-iOS_Sidebar",
               alt: "The Alidade app running on iPadOS")
        _Fig. 3a: The sidebar sheet as it appears on iPad._
    }
    @Column(size: 1) {
        @Image(source: "Architecture-iOS_Sheet",
               alt: "The Alidade app running on iOS")
        _Fig. 3b: The sidebar sheet as it appears on iPhone._
    }
}
