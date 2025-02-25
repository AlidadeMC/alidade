# Building Alidade from Source

@Metadata {
    @PageImage(purpose: card, source: "Card-Building")
    @CallToAction(url: "https://github.com/alicerunsonfedora/mcmaps/archive/refs/heads/main.zip", purpose: download)
}

Build the Alidade app from the source code.

## Overview

This article will outline the process of building the Alidade app from
its source code. The process will be familiar for experienced developers
on Apple's platforms, but this should provide insight for new developers
and contributors, or for those seeking to sideload Alidade on their own
devices in markets where the app is not available.


### Before you begin

Ensure that you have the following tools installed on your Mac:

- [Xcode (v16 or later)](https://developer.apple.com/xcode/)
- Git (Installable from the Xcode Command Line Tools)

It is also recommended to have an Apple Developer account available for
signing and distribution on iOS. You can create a free account on the
[Apple Developer website](https://developer.apple.com) to allow signing of
apps from Xcode for a week.

## Downloading the project

Download a copy of the code by either pressing the download button at the
top of this article, or run the following command below in your Terminal:

```
git clone --recursive https://github.com/alicerunsonfedora/mcmaps.git 'Alidade'
```

> Important: Alidade requires dependencies cloned via Git submodules, such
> as Cubiomes. Ensure that you initialize or clone with the `--recursive`
> flag to get all of the dependencies.

## Building the project

Open the file titled **Alidade.xcworkspace** to open the project and
related Swift packages. If the Swift package dependencies don't
automatically download and resolve themselves, go to
**File > Packages > Resolve Package Versions** to do so now.

To build and run the project, simply select the **Alidade** scheme, set
the appropriate target to either "My Mac", your device name, or one of the
simulator targets.

> Note: You might need to prepare your personal device for development if
> building and running the iOS version by enabling Developer Mode, and
> connecting to Xcode for the first time.
>
> For more information, see 
> [Get to Know Developer Mode](https://developer.apple.com/videos/play/wwdc2022/110344/)
> from WWDC22.

### Schemes

There will be some schemes available in the toolbar when opening the
project:

- **Alidade** is the main project scheme used to build and run the app,
  along with the unit test suite.
- **Alidade (Debugging)** is the project scheme used to build and run the
  app with the debugger attached to allow for easier debugging.

### Exporting the project

To make an archive of the project, set the target to either
"Any Mac (arm64, x86_64)" or "Any iOS Device (arm64)", then go to
**Product > Archive** in the menu bar. The Organizer window will appear
when the archiving is complete to let you export it.

> Important: To distribute signed copies of Alidade for macOS and iOS via
> the App Store, you will need to be a part of the Apple Developer
> program.
>
> For more information on distributing an app, refer to the
> [Distribution](https://developer.apple.com/documentation/xcode/distribution)
> section of Apple's developer documentation.
