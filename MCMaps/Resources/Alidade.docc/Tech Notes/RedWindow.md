# TN0001: Designing for Liquid Glass via Red Window

@Metadata {
    @TitleHeading("Technical Note")
    @PageColor(orange)
    @Redirected(from: "RedWindow")
}

Understand the changes that control the new Liquid Glass design.

The next major version of Alidade will feature a new, refined design that
leverages and embraces the Liquid Glass design system Apple introduced at
WWDC 2025. This new Alidade redesign is codenamed _Red Window_, and it
will become the new default experience for players on OS 26.

However, to maintain the current experience in development, such features
and work have been heavily gated off.

This technical note will cover how this redesign is gated off and how to
enable it on development and testing builds.

## Compilation and build settings

Most of the new design leverages existing SwiftUI APIs that don't require
gating at the compilation level. However, some APIs are only available in
the OS 26 SDK, and they will not compile under Xcode 16.

To handle this, a new compilation condition called `RED_WINDOW` has been
introduced. It should **only** be used to gate new APIs that cannot be
compiled under Xcode 16:

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        Label("Foo", systemImage: "square.and.pencil")
        #if RED_WINDOW
            .glassEffect()
        #endif
    }
}
```

> Important: This compilation condition is only available when building
> the **Alidade (Red Window)** Xcode scheme. Ensure that you switch to
> this scheme when building in Xcode 26.

## Feature flags

> Important: This feature flag has been deprecated in favor of using OS
> availability checks starting with build 85. Setting this flag will do
> nothing, and this flag has been removed from the Feature Flags pages in
> Settings.

Most, if not all, of the design changes specific to the new design should
be gated behind the `redWindow` feature flag. This is checked in views
that are required to switch between the current design and the new design,
such as the body for the main app:

```swift
import SwiftUI

@main
struct MCMapsApp: App {
    ...
    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    var body: some Scene {
        DocumentGroup(...) { configuration in
            if useRedWindowDesign {
                RedWindowContentView(...)
            } else {
                ContentView(...)
                    .toolbarRole(.editor)
                    #if os(iOS)
                    .toolbarVisibility(...)
                    #endif
            }
        }
    }
}
```

This feature flag can be toggled on and off in the app's settings. For iOS
and iPadOS, this appears in Alidade's Settings page under the Feature
Flags child pane. On macOS, this appears in the app's settings from
**Alidade > Settings...**.

> Note: On macOS, this can only be toggled when running on macOS 26 Tahoe.
> For iOS and iPadOS, the toggle is turned off by default to get around
> limitations in settings bundles. To test the new design on Macs running
> macOS Sequoia, run the following in the terminal:
>
> ```
> defaults write net.marquiskurt.MCMaps flags.red_window true
> ```

## Roadmap for Liquid Glass

Red Window is being mapped out in the following manner:

| Timeframe | Action |
| --- | --- |
| ~~**Summer 2025**~~ | ~~Development of Red Window is gated and controlled by feature flags while OS 26 remains in beta (both developer and public).~~ |
| **Fall 2025** | Around the time of the release candidates, the feature flag will be deprecated in favor of OS availability checks. When OS 26 releases and, later, Alidade, Red Window will be available for players on OS 26. Players on macOS 15 Sequoia and iOS/iPadOS 18 will continue to have the current Alidade design. By this time, the feature flag for Red Window will be removed entirely.
| **Summer 2026** | The current Alidade design will be removed entirely when OS 27 releases, and Red Window will be the only design experience. |
