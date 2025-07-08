# Network Connectivity

Setup Manager can display the current network status in the top right corner of the main window.

By default, the icon will only appear when 
- there is no network connection
- Network Relay is configured
- the `networkCheck` array is present in the profile

You can always manually toggle the visibility of the network status icon with command-N.

The icon will show the network "globe" icon when the network is connected, the icon with a slash when it is disconnected, and the icon with a small shield when it is connected and Network Relay is configured.

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

## Network Change logging

Setup Manager 1.3 adds logging for changes to network interfaces. It is possible that there will multiple entries in the log with regards to the same network change. Most changes logged will be neutral and should not affect your deployment negatively.

However, it is possible that changes to the network configuration of a device can influence the deployment workflow. Changes to network or Wi-Fi configurations and other network or security tools might disrupt the network connectivity during enrollment. This might interrupt or cancel downloads.

For example, when a configuration profile with the access information for a secure corporate Wifi is installed on the device, then the download access to required resources might change. Another example are security tools that might lead to restricted access for downloads (Installomator uses `curl` to download data, which might trigger security tools.) 

Checking the log for network changes or outages during enrollment can be useful for troubleshooting.
