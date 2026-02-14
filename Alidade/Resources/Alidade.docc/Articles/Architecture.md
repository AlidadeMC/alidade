# Architecture

Learn and understand Alidade's architecture and view hierarchy.

@Metadata {
    @PageImage(purpose: card, source: "Card-Architecture")
}

## Overview

Alidade provides a consistent architecture and user interface that applies
across Mac, iPhone, and iPad. This article will cover how the app is
structured and how it interacts with other views.

### Rationale

In the past, Alidade needed to provide unique interfaces for each of the
major platforms, shared by a common view model. While this allowed each
platform to have an interface uniquely tuned for it, this came at the cost
of maintainability, as views became much more bloated or confusing.

When creating the **Red Window** design as noted in <doc:RedWindow>, we
had the opportunity to restructure the app in a way that allows for more
portable views while leveraging what SwiftUI has to offer.

## Entrypoint

The main app starts at the ``Alidade`` entrypoint. Here, the
``RedWindowContentView`` is created, which receives the currently open file
as an argument. Information about the current app state is passed through
as an environment object, ``RedWindowEnvironment``. This environment
object contains key information such as which tab route is currently
active, what pins should be deleted, etc:

```swift
import SwiftUI

struct Alidade: App {
    @State private var redWindowEnv = RedWindowEnvironment()
    var body: some Scene {
        DocumentGroup(...) { configuration in
            ...
        }
        .environment(redWindowEnv)
    }
}
```

At this time, any integration services are also set up. For example, the
Bluemap integration service is provided as an environment variable to the
view through the ``SwiftUICore/EnvironmentValues/bluemapService`` key
path.

On top of this, menu commands for managing the current environment are
provided here.

## Main content view

The ``RedWindowContentView`` provides a tabbed interface that works across
macOS, iOS, and iPadOS seamlessly. On iPhone, a more compact tab bar is
used, with pins being a child page in the library. On macOS and iPadOS,
pins can be listed on the side as their own tab. On iPadOS, this can be
configured so that only certain pins are displayed.

### Routing

Each tab is configured to map to a corresponding ``RedWindowRoute``. The
library is unique in that there are two routes corresponding to it: the
``RedWindowRoute/allPinsCompact`` is used whenever the interface is
displayed in a compact horizontal size class, such as with the iPhone.
When the view expands into the regular horizontal size class, this tab
will automatically transition itself to the ``RedWindowRoute/allPins``
route.

### Tab pages

Because each tab page provides its own interface, there are no assumptions
made about navigation stacks or additional child views. Some child routes
such as ``RedWindowRoute/pin(_:)`` will have their own tab pages, but
these are generally registered for their own corresponding tab in the
interface. As such, each tab page view is responsible for providing their
own models and interfaces.

For legacy or shared views that need a little extra setup, the content
view will wrap these views in a navigation stack. Such examples include
the ``RedWindowRoute/worldEdit`` and ``RedWindowRoute/gallery`` views.

### Tab customizations

On some platforms (most notably, iPadOS), players can customize the tabs
and sidebar to display the elements they'd like to see. Starting with v2
of the Minecraft map package format, these changes are automatically
stored and saved into the app state directory.

## Multiple windows

Some parts of the app, such as the gallery feature, can be opened in a new
window entirely, allowing more flexibility across workflows and devices.
These window types are generally registered at the entrypoint and can be
invoked through SwiftUI's `openWindow` method.

Generally, it is recommended to use
``SwiftUI/OpenWindowAction/callAsFunction(id:)`` or
``SwiftUI/OpenWindowAction/callAsFunction(id:context:)``, as these
overloads can guarantee type safety for the various window types
registered under ``WindowID``. For example, to open the Gallery in a
separate window:

```swift
import SwiftUI

struct MyView: View {
    typealias Context = CartographyGalleryWindowContext
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Open Gallery") {
            openWindow(
                id: .gallery,
                context: Context(...))
        }
    }
}
```

> Note: For some views such as the Gallery, these window features are
> shared with the legacy architecture and can be invoked in the same way.

## Topics

### Routing and environment

- ``RedWindowEnvironment``
- ``RedWindowRoute``
- ``RedWindowModalRoute``
- ``RedWindowPinDeletionRequest``

### Entrypoint content

- ``RedWindowContentView``

### Child pages

- ``RedWindowMapView``
- ``RedWindowSearchView``
- ``RedWindowPinLibraryView``
- ``RedWindowPinDetailView``

### Working with multiple windows

- ``WindowID``
- ``SwiftUI/OpenWindowAction/callAsFunction(id:)``
- ``SwiftUI/OpenWindowAction/callAsFunction(id:context:)``
