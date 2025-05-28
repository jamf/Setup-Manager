# Network Connectivity

Setup Manager can display the current network status in the top right corner of the main window.

By default, the icon will only appear when the network is _not_ active, or when Network Relay is configured. You can always toggle the visibility of the network status icon with command-N.

The icon will show the network "globe" icon when the network is connected, the icon with a slash when it is disconnected, and the icon with a shield when it is connected and Network Relay is configured.

You can click on the icon for more detailed information:
- network connection name
- IP addresses (IPv4 and IPv6, when present)
- Network Bandwidth information (these take a while to appear, be patient)
- When Network Relay is configured, it will show the connectivity to the HTTP3/QUIC and HTTP2 hosts
- Connectivity to certain hosts
  - by default, the Jamf Server will be shown
  - You can add a list of custom hosts in the configuration profile
  
### `networkCheck`
(array of dict, optional)

Provides a list of hosts to check connectivity to. These will be shown in the 'Connectivity' section in the network info pane.

Each dict in this array represents a check for a connection to a host. The dict can contain the following keys:

#### `host`

(string)

The host name, e.g. `host.example.com` (no url scheme) to test a connection to.

#### `port`

(integer, optional, default: `443`)

The port to test a connection to.

#### `protocol`

(string, optional, default: `tcp`)

The connection protocol to test: `tcp` or `udp`.

#### `label`

(string, localizable, optional)

A display label for the connection test.

Example:

```xml
<key>networkCheck</key>
<array>
  <dict>
    <key>host</key>
    <string>map.wandera.com</string>
    <key>label</key>
    <string>Intranet Maps</string>
    <key>port</key>
    <integer>443</integer>
    <key>protocol</key>
    <string>tcp</string>
  </dict>
</array>
```


