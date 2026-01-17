# TN0002: Bluemap Integration with a Local Server

@Metadata {
    @TitleHeading("Technical Note")
    @PageColor(orange)
    @Redirected(from: "RedWindow")
}

Read and understand common pitfalls or gotchas when using the Bluemap
integration on a local server.

## Overview

In Alidade v2025.2, a new feature was introduced that allows players to
fetch player locations and server markers from Minecraft servers with the
Bluemap plugin installed. However, if you are hosting this server locally,
you may run into some additional problems or need to perform extra steps
to ensure it works correctly.

> SeeAlso: For more information on how to set this up at a basic level,
> refer to <doc:Guide-Bluemap>.

## Alidade expectations

For the Bluemap integration to work correctly, Alidade expects the
following to be true:

- The server is hosted on a standard port or can be access with a valid
  domain name.
- The server can be accessed securely via HTTPS.

Most of this can be handled easily by putting Bluemap behind a reverse
proxy using a service like Nginx or Caddy. The Bluemap documentation
provides an excellent resource for learning how to set this up.

[Set up a reverse proxy for Bluemap &rsaquo;](https://bluemap.bluecolored.de/wiki/webserver/ReverseProxy.html)

### SSL certificates

You will need to provide SSL certificates, either self-signed or from a
trusted certificate authority (CA). If you are planning to host your
Bluemap externally, you can do this easily with the `certbot` utility and
using certificates provided by Let's Encrypt.

Self-signed certificates are also an option, but you will need to ensure
that your devices have the certificate installed locally and trust your
certificate.

[Create self-signed certificates in Keychain Access on Mac &rsaquo;](https://support.apple.com/guide/keychain-access/create-self-signed-certificates-kyca8916/mac)  
[Trust manually installed certificate profiles in iOS, iPadOS, and visionOS &rsaquo;](https://support.apple.com/en-us/102390)

### Internal DNS server

If you have set your server with an internal DNS server so that your
domain maps both locally and externally, you may run into difficulties
with connecting to Bluemap through Alidade on iOS and iPadOS. Turning off
the **Limit IP Address Tracking** for your WiFi network that maps to the
internal DNS server might restore this functionality.
