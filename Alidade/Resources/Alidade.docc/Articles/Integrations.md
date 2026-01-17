# Integrations

Interact with other Minecraft services and server plugins.

## Overview

Starting with Alidade 2025.2, the app can integrate with other common
Minecraft services and plugins, pulling in data that can be displayed in
the main app. These integrations are opt-in and offer a host of settings
to configure the integration per map.

> Important: The documentation for integrations is currently a work in
> progress. Proceed with caution!

## Topics

### Bluemap

Alidade can pull server markers and player locations from a Minecraft
server with the Bluemap plugin installed.

- ``CartographyBluemapService``
- ``BluemapPlayerResponse``
- ``BluemapPlayer``
- ``BluemapMarkerAnnotationGroup``
- ``BluemapMarkerAnnotation``
- ``BluemapResults``
- ``BluemapDisplayProperties``
- ``BluemapPosition``

### Integration Networking

- ``NetworkServiceable``
- ``NetworkServicableError``
- ``IntegrationFetchState``
- ``CartographyIntegrationService``
- ``CartographyIntegrationServiceData``
- ``CartographyIntegrationServiceProvider``

### Integration Views

- ``IntegrationFetchStateView``
- ``BluemapIntegrationFormSection``
